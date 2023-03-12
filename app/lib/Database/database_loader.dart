import 'dart:io';

import 'package:app/MapData/feature.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseLoader {
  static DatabaseLoader? _databaseLoader;
  final String _relativePath = "database/map_info.db";
  Set<Feature>? _features;

  DatabaseLoader._();

  /// Returns the only instance of DatabaseLoader.
  static DatabaseLoader getDataBaseLoader()
  {
    _databaseLoader ??= DatabaseLoader._();
    return _databaseLoader!;
  }

  /// Loads the database and returns a List of Features. Saves the result to be
  /// given for future calls.
  Future<Set<Feature>> load() async
  {
    _features ??= await _loadDatabase();
    return _features!;
  }

  // Loads the database and returns a List of Features.
  Future<Set<Feature>> _loadDatabase() async
  {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, _relativePath);

    // Check if the database exists in getDatabasesPath().
    var exists = await databaseExists(path);

    // If it has not yet been written from the assets folder to the more
    // efficient location to find at getDatabasesPath().
    if (!exists) {
      _writesDatabase(path);
    }

    // Open the database.
    var db = await openDatabase(path, readOnly: true);

    // Gets the Features table.
    List<Map<String, Object?>> list =
    await db.rawQuery('SELECT * FROM Feature');

    // Copy's the Feature's table into a list of Features objects.
    Set<Feature> features = {};
    for (Map map in list) {
      features.add(Feature(map["feature_id"], map["feature_name"],
          map["longitude"], map["latitude"]));
    }

    await db.close();

    return features;
  }

  // This finds the database in the assets folder and copy's it to a location
  // in getDatabasesPath() to be more efficiently found the next time the app
  // loads up.
  _writesDatabase(String path) async
  {
    // Make sure the parent directory exists
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    // Copy from asset
    ByteData data = await rootBundle.load(join("assets", _relativePath));
    List<int> bytes =
    data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Write and flush the bytes written
    await File(path).writeAsBytes(bytes, flush: true);
  }
}
