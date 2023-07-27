import 'package:app/Database/database_loader.dart';
import 'package:app/MapData/bus_running_dates.dart';
import 'package:app/MapData/bus_time.dart';
import 'package:app/MapData/feature.dart';
import 'package:mockito/annotations.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:tuple/tuple.dart';

import 'database_loader_test.mocks.dart';

@GenerateMocks([Database])
void main() {
  group('Database Loader Tests', () {
    test('.getDataBaseLoader() Returns same handler', () {
      DatabaseLoader loaderOne = DatabaseLoader.getDataBaseLoader();
      DatabaseLoader loaderTwo = DatabaseLoader.getDataBaseLoader();
      expect(loaderOne, loaderTwo);
    });

    DatabaseLoader loader = DatabaseLoader.getDataBaseLoader();

    test('.loadDatabase(Database) returns the contents of the database if successful', () async {
      final db = MockDatabase();

      // Use Mockito to return a successful response when it calls the
      // provided database.
      when(db.rawQuery('SELECT * FROM Feature')).thenAnswer((_) async =>
      [
        {
          "feature_id": "LM-01",
          "feature_name": "Mock Name 1",
          "longitude": 11.0,
          "latitude": 12.0,
        },
        {
          "feature_id": "UB-02",
          "feature_name": "Mock Name 2",
          "longitude": 22.0,
          "latitude": 23.0,
        },
        {
          "feature_id": "U1-03",
          "feature_name": "Mock Name 3",
          "longitude": 31.0,
          "latitude": 32.0,
        },
        {
          "feature_id": "U1-04",
          "feature_name": "Mock Name 4",
          "longitude": 42.0,
          "latitude": 43.0,
        }
      ]);

      when(db.rawQuery('SELECT * FROM Bus_Times')).thenAnswer((_) async =>
      [
        {
          "bus_stop_id": "U1-03",
          "arrive_time": "11:11",
          "depart_time": "23:23",
          "route" : 1,
        },
        {
          "bus_stop_id": "U1-04",
          "arrive_time": "22:22",
          "depart_time": "24:24",
          "route" : 1,
        }
      ]);

      when(db.rawQuery('SELECT * FROM Term_Dates')).thenAnswer((_) async =>
      [
        {
          "start_date": "2011/11/11",
          "end_date": "2012/12/12"
        },
        {
          "start_date": "2021/11/11",
          "end_date": "2022/12/12"
        }
      ]);

      when(db.rawQuery('SELECT * FROM National_Holidays')).thenAnswer((_) async =>
      [
        {
          "date": "2001/11/11"
        },
        {
          "date": "2002/12/12"
        }
      ]);

      expect(await (loader.loadDatabase(db)), isA<Tuple4<
          Set<Feature>,
          Map<String, List<BusTime>>,
          Map<String, List<BusTime>>,
          BusRunningDates>>());
    });
  });
}
