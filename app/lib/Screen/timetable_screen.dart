import 'package:app/MapData/bus_stop.dart';
import 'package:app/Sorts/comparator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../MapData/bus_time.dart';
import '../MapData/map_data_loader.dart';
import '../Sorts/heap_sort.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  List<DropdownButton<String>> dropDownButtons = [];

  @override
  void initState() {
    MapDataLoader.getDataLoader().onDataLoaded((mapData) {
      setState(() {
        // Adds all the bus stops to the timetable.
        for (BusStop busStop in mapData.getAllBusStops()) {
          if (busStop.getHasSeparateArrDepTimes()) {
            _addBusStop(
                "${busStop.name} (Arrivals)", busStop.getArrivalTimes());
            _addBusStop(
                "${busStop.name} (Departures)", busStop.getDepartureTimes());
          } else {
            _addBusStop(busStop.name, busStop.getDepartureTimes());
          }
        }

        // Sorts the bus stops so that the stops that the bus gets too first
        // appear at the top of the screen.
        HeapSort<DropdownButton<String>> sort =
            HeapSort<DropdownButton<String>>((item1, item2) {
          List<DropdownMenuItem<String>> times1 =
              item1.items as List<DropdownMenuItem<String>>;
          int hour1 = int.parse(times1[1].value!.substring(0, 2));
          hour1 == 0 ? hour1 = 24 : hour1;
          int minute1 = int.parse(times1[1].value!.substring(3, 5));
          int firstTime1 = minute1 + (hour1 * 60);

          List<DropdownMenuItem<String>> times2 =
              item2.items as List<DropdownMenuItem<String>>;
          int hour2 = int.parse(times2[1].value!.substring(0, 2));
          hour2 == 0 ? hour2 = 24 : hour2;
          int minute2 = int.parse(times2[1].value!.substring(3, 5));
          int firstTime2 = minute2 + (hour2 * 60);

          if (firstTime1 <= firstTime2) {
            return Comparator.before;
          }
          return Comparator.after;
        });
        dropDownButtons = sort.sort(dropDownButtons);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
        const Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child:Text(
              "The bus takes a one-way circular route, stopping at: ",
              style: TextStyle(color: Colors.black),
            )),
            ...dropDownButtons,
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text:
                        'Buses only run on week days during term time excluding'
                            ' bank holidays, check the ',
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: 'Uni Bus website',
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(Uri(
                            scheme: 'https',
                            host: 'myport.port.ac.uk',
                            path:
                                '/life-at-uni/life-on-campus/getting-to-campus'
                                    '/university-buses'));
                      },
                  ),
                  const TextSpan(
                    text: ' for a complete list of dates.',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  // Adds a bus stop to the timetable.
  _addBusStop(String busStopName, Iterable<BusTime> busTimes) {
    List<DropdownMenuItem<String>> times = [];
    times.add(DropdownMenuItem(
      value: busStopName,
      child: Text(busStopName),
    ));
    for (BusTime time in busTimes) {
      times.add(DropdownMenuItem(
        value: time.toDisplayString(),
        child: Text(time.toDisplayString()),
      ));
    }
    dropDownButtons.add(DropdownButton(
      value: busStopName,
      items: times,
      menuMaxHeight: 500,
      onChanged: (value) {},
      elevation: 8,
      isExpanded: true,
    ));
  }
}
