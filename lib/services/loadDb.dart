import 'dart:io';
import 'package:path/path.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

class LoadDb {
  loadDb() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "dmrcSqlite.db");
    bool exists = await databaseExists(path);
    if (!exists) {
      print('Creating new copy');
      await Directory(dirname(path)).create(recursive: true);
      ByteData data = await rootBundle.load(join("assets", "dmrcSqlite.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    }
    else {
      print("Opening existing db");
    }
  }
}
