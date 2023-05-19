import 'dart:io';

import 'package:ausa_flutter/utils/ausa_pusher.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:record/record.dart';
import 'package:ausa_flutter/utils/file_utils.dart';
import 'package:flutter/material.dart';

class RecordPageModelView with ChangeNotifier {
  final record = Record();
  var _currentFile = "";
  var _resultMessage = "";
  RecordState recordState = RecordState.stop;

  RecordPageModelView() {
    initPusher();
  }
  String getFileName() {
    return _currentFile;
  }

  String getResultMessage() {
    return _resultMessage;
  }

  String get buttonText {
    if (recordState == RecordState.stop) {
      return "Start Record";
    } else {
      return "Stop Record";
    }
  }

  onPressButton() async {
    if (recordState == RecordState.stop) {
      await startRecord();
    } else {
      await stopRecord();
      uploadFile(_currentFile);
    }
  }

  startRecord() async {
    if (await record.hasPermission()) {
      // Start recording
      var path = await FileUtils().localPath;
      var name = FileUtils().randomFileName;
      _currentFile = '$path/$name.wav';
      await record.start(
        path: _currentFile,
        encoder: AudioEncoder.wav,
      );
      recordState = RecordState.record;
      notifyListeners();
    }
  }

  stopRecord() async {
    await record.stop();
    recordState = RecordState.stop;
    notifyListeners();
  }

  initPusher() async {
    final myChannel = await AuSaPusher.instance().pusher.subscribe(
        channelName: "result-channel",
        onEvent: (event) {
          if (event.eventName == "show") {
            _resultMessage = event.data;
            notifyListeners();
          }
        });

    AuSaPusher.instance().connect();
  }

  Future<void> uploadFile(String filePath) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://172.19.142.247:3000/upload'));

    // Create a file stream from the file path
    var fileStream =
        http.ByteStream(Stream.castFrom(File(filePath).openRead()));

    // Get the file name from the file path
    var fileName = filePath.split('/').last;

    // Create a multipart file with the file stream and content type
    var multipartFile = http.MultipartFile(
      'file',
      fileStream,
      File(filePath).lengthSync(),
      filename: fileName,
      contentType: MediaType('application', 'octet-stream'),
    );

    // Add the multipart file to the request
    request.files.add(multipartFile);

    // Send the request and get the response
    var response = await request.send();
    final respStr = await response.stream.bytesToString();
    debugPrint(respStr);
    // Check if the request was successful
    if (response.statusCode == 200) {
      debugPrint('File uploaded successfully');
    } else {
      debugPrint('File upload failed');
    }
  }
}
