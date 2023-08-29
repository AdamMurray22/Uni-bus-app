import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:app/MapData/bus_time.dart';
import 'package:app/MapData/feature.dart';
import 'package:app/MapData/national_holiday.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tuple/tuple.dart';

import '../bus_running_dates.dart';
import '../term_dates.dart';
import 'data_loader.dart';

/// Loader that loads the map data from a local database.
class DatabaseLoader implements DataLoader {
  static DatabaseLoader? _databaseLoader;
  final String _relativePath = "database/map_info.db";
  Tuple5<Set<Feature>, Map<String, int>, Map<String, List<BusTime>>, Map<String, List<BusTime>>,
      BusRunningDates>? _data;

  DatabaseLoader._();

  /// Returns the only instance of DatabaseLoader.
  static DatabaseLoader getDataBaseLoader() {
    _databaseLoader ??= DatabaseLoader._();
    return _databaseLoader!;
  }

  /// Loads the database and saves the result to be given for future calls.
  @override
  Future<
      Tuple5<Set<Feature>, Map<String, int>, Map<String, List<BusTime>>,
          Map<String, List<BusTime>>, BusRunningDates>> load() async {
    _data ??= await loadData(await _getDatabase());
    return _data!;
  }

  // Loads the database and returns a List of Features.
  Future<
      Tuple5<
          Set<Feature>,
          Map<String, int>,
          Map<String, List<BusTime>>,
          Map<String, List<BusTime>>,
          BusRunningDates>> loadData(Database db) async {
    // Gets the Features table.
    List<Map<String, Object?>> featuresList =
        await db.rawQuery('SELECT * FROM Feature');

    // Gets the bus stop order table
    List<Map<String, Object?>> busStopOrderList =
      await db.rawQuery('SELECT * FROM Bus_Stop_Order');

    // Gets the bus arrTimes table
    List<Map<String, Object?>> busTimesList =
        await db.rawQuery('SELECT * FROM Bus_Times');

    // Gets the bus running termDates table
    List<Map<String, Object?>> busRunningDatesList =
        await db.rawQuery('SELECT * FROM Term_Dates');

    // Gets the national holidays table
    List<Map<String, Object?>> nationalHolidaysList =
        await db.rawQuery('SELECT * FROM National_Holidays');

    await db.close();

    // Copy's the Feature's table into a set of Features objects.
    Set<Feature> features = {};
    for (Map map in featuresList) {
      features.add(Feature(map["feature_id"], map["feature_name"],
          map["longitude"], map["latitude"]));
    }

    // Copy's the busStopOrder's table into a map of the bus stops order.
    Map<String, int> busStopOrder = {};
    for (Map map in busStopOrderList) {
      busStopOrder[map["bus_stop_id"]] = map["order"];
    }

    // Copy's the Bus Time's arrive table into a map from bus stop id's to BusTime objects.
    Map<String, List<BusTime>> arrTimes = {};
    for (Map map in busTimesList) {
      if (arrTimes[map["bus_stop_id"]] == null) {
        arrTimes[map["bus_stop_id"]] = [];
      }
      String? time = map["arrive_time"];
      if (time != null) {
        arrTimes[map["bus_stop_id"]]!.add(BusTime(map["arrive_time"], map["route"]));
      }
    }

    // Copy's the Bus Time's depart table into a map from bus stop id's to BusTime objects.
    Map<String, List<BusTime>> depTimes = {};
    for (Map map in busTimesList) {
      if (depTimes[map["bus_stop_id"]] == null) {
        depTimes[map["bus_stop_id"]] = [];
      }
      String? time = map["depart_time"];
      if (time != null) {
        depTimes[map["bus_stop_id"]]!.add(BusTime(map["depart_time"], map["route"]));
      }
    }

    // Copy's the bus running termDates table into a set.
    Set<TermDates> termDates = {};
    for (Map map in busRunningDatesList) {
      termDates.add(TermDates(map["start_date"], map["end_date"]));
    }

    // Copy's the national holidays table into a set.
    Set<NationalHoliday> nationalHolidays = {};
    for (Map map in nationalHolidaysList) {
      nationalHolidays.add(NationalHoliday(map["date"]));
    }

    BusRunningDates runningDates = BusRunningDates(termDates, nationalHolidays);

    _data = Tuple5(features, busStopOrder, arrTimes, depTimes, runningDates);
    return _data!;
  }

  Future<Database> _getDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _relativePath);

    // Check if the database exists in getDatabasesPath().
    bool exists = await databaseExists(path);

    // If it has not yet been written from the assets folder to the more
    // efficient location to find at getDatabasesPath().
    if (!exists) {
      await _writesDatabase(path);
    }

    // Used to reload the database from assets when its updated manually
    //await _reloadDatabaseFromAssets(path);

    // Open the database.
    return await openDatabase(path, readOnly: true);
  }

  // This finds the database in the assets folder and copy's it to a location
  // in getDatabasesPath() to be more efficiently found the next time the app
  // loads up.
  _writesDatabase(String path) async {
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

  // Used to reload the database from assets when its updated manually
  _reloadDatabaseFromAssets(String path) async {
    deleteDatabase(path);
    await _writesDatabase(path);
  }
}
