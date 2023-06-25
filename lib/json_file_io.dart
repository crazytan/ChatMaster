import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class JsonFileIO {
  static Future<File> get _localFile async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/data.json');
  }

  static Future<Map<String, dynamic>> readJsonFile() async {
    try {
      final file = await _localFile;
      String content = await file.readAsString();
      return jsonDecode(content);
    } catch (e) {
      // Handle file not found or empty file
      return {};
    }
  }

  static Future<File> writeJsonFile(Map<String, dynamic> data) async {
    final file = await _localFile;
    return file.writeAsString(jsonEncode(data));
  }
}
