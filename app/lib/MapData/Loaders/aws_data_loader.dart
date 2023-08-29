import 'dart:convert';

import 'package:app/MapData/bus_running_dates.dart';
import 'package:app/MapData/bus_time.dart';
import 'package:app/MapData/feature.dart';
import 'package:tuple/tuple.dart';
import '../national_holiday.dart';
import '../term_dates.dart';
import 'data_loader.dart';
import 'package:http/http.dart' as http;

/// Loader that loads the map data from an aws database.
class AWSDataLoader implements DataLoader {
  static AWSDataLoader? _awsDataLoader;
  final String _serverURL =
      "https://ff42hn1swl.execute-api.eu-west-2.amazonaws.com/prod?uniID=UOP";
  Tuple5<Set<Feature>, Map<String, int>, Map<String, List<BusTime>>,
      Map<String, List<BusTime>>, BusRunningDates>? _data;

  AWSDataLoader._();

  /// Returns the only instance of AWSDataLoader.
  static AWSDataLoader getAWSDataLoader() {
    _awsDataLoader ??= AWSDataLoader._();
    return _awsDataLoader!;
  }

  /// Loads the data and saves the result to be given for future calls.
  @override
  Future<
      Tuple5<Set<Feature>, Map<String, int>, Map<String, List<BusTime>>,
          Map<String, List<BusTime>>, BusRunningDates>> load() async {
    _data ??= await loadData();
    return _data!;
  }

  loadData() async {
    Map<String, dynamic> mapData = await _getServerDataJson();

    // Gets the Features table.
    List<dynamic>? featuresList = mapData["Features"];
    featuresList ??= [];

    // Gets the bus stop order table
    List<dynamic>? busStopOrderList = mapData["BusStopOrder"];
    busStopOrderList ??= [];

    // Gets the bus arrTimes table
    List<dynamic>? busTimesList = mapData["BusTimes"];
    busTimesList ??= [];

    // Gets the bus running termDates table
    List<dynamic>? busRunningDatesList = mapData["TermDates"];
    busRunningDatesList ??= [];

    // Gets the national holidays table
    List<dynamic>? nationalHolidaysList = mapData["NationalHoliday"];
    nationalHolidaysList ??= [];

    // Copy's the Feature's table into a set of Features objects.
    Set<Feature> features = {};
    for (Map map in featuresList) {
      features.add(Feature(map["FeatureID"], map["FeatureName"],
          map["Longitude"], map["Latitude"]));
    }

    // Copy's the busStopOrder's table into a map of the bus stops order.
    Map<String, int> busStopOrder = {};
    for (Map map in busStopOrderList) {
      busStopOrder[map["BusStopID"]] = map["Order"];
    }

    // Copy's the Bus Time's arrive table into a map from bus stop id's to BusTime objects.
    Map<String, List<BusTime>> arrTimes = {};
    for (Map map in busTimesList) {
      if (arrTimes[map["BusStopID"]] == null) {
        arrTimes[map["BusStopID"]] = [];
      }
      String? time = map["ArriveTime"];
      if (time != "None") {
        arrTimes[map["BusStopID"]]!
            .add(BusTime(map["ArriveTime"], map["Route"]));
      }
    }

    // Copy's the Bus Time's depart table into a map from bus stop id's to BusTime objects.
    Map<String, List<BusTime>> depTimes = {};
    for (Map map in busTimesList) {
      if (depTimes[map["BusStopID"]] == null) {
        depTimes[map["BusStopID"]] = [];
      }
      String? time = map["DepartTime"];
      if (time != "None") {
        depTimes[map["BusStopID"]]!
            .add(BusTime(map["DepartTime"], map["Route"]));
      }
    }

    // Copy's the bus running termDates table into a set.
    Set<TermDates> termDates = {};
    for (Map map in busRunningDatesList) {
      termDates.add(TermDates(map["StartDate"], map["EndDate"]));
    }

    // Copy's the national holidays table into a set.
    Set<NationalHoliday> nationalHolidays = {};
    for (Map map in nationalHolidaysList) {
      nationalHolidays.add(NationalHoliday(map["Date"]));
    }

    BusRunningDates runningDates = BusRunningDates(termDates, nationalHolidays);

    _data = Tuple5(features, busStopOrder, arrTimes, depTimes, runningDates);
    return _data!;
  }

  Future<Map<String, dynamic>> _getServerDataJson() async {
    return jsonDecode(await _getResponseBody());
  }

  Future<String> _getResponseBody() async {
    Uri uri = _getUri();
    http.Response response = await http.get(uri);
    return response.body;
  }

  Uri _getUri() {
    Uri uri = Uri.parse(_serverURL);
    return uri;
  }
}
