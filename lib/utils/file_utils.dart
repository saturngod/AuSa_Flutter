import 'dart:math';

import 'package:path_provider/path_provider.dart';

class FileUtils {
  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  String get randomFileName {
    final random = Random();

    // Generate a random number between 1000 and 9999
    final randomNumber = random.nextInt(9000) + 1000;

    // Get the current timestamp
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    // Combine the random number and timestamp to create the file name
    final fileName = 'file_${randomNumber}_$timestamp';

    return fileName;
  }
}
