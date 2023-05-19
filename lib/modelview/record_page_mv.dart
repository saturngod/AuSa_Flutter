import 'package:record/record.dart';
import 'package:ausa_flutter/utils/file_utils.dart';
import 'package:flutter/material.dart';

class RecordPageModelView with ChangeNotifier {
  final record = Record();
  var _currentFile = "";
  RecordState recordState = RecordState.stop;
  
  

  String getFileName() {
    return _currentFile;
  }

  String get buttonText {
    if(recordState == RecordState.stop) {
      return "Start Record";
    }
    else  {
      return "Stop Record";
    }
  }

  onPressButton() async {
    if(recordState == RecordState.stop) {
      
      startRecord();
    }
    else  {
      stopRecord();
      debugPrint(_currentFile);
    }
  }

  startRecord() async {
    if (await record.hasPermission()) {
      // Start recording
      var path = await FileUtils().localPath;
      var name = FileUtils().randomFileName;
      _currentFile = '$path/$name.m4a';
      await record.start(
        path: _currentFile,
        encoder: AudioEncoder.aacLc,
      );
      recordState = RecordState.record;
      notifyListeners();
    }
  }

  stopRecord() async {
    record.stop();
    recordState = RecordState.stop;
    notifyListeners();
  }
}