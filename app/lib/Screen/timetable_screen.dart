import 'package:app/MapData/bus_stop.dart';
import 'package:app/Screen/dropdown_button_bus_stop.dart';
import 'package:app/Sorts/comparator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../MapData/bus_time.dart';
import '../MapData/map_data_loader.dart';
import '../Sorts/heap_sort.dart';

/// The screen that displays the timetable.
class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  List<DropdownButtonBusStop<String>> _dropDownButtons = [];

  // Comparator for the drop down buttons to sort by the order of the bus stops.
  Comparator Function(DropdownButtonBusStop<String> item1, DropdownButtonBusStop<String> item2) _dropDownButtonsComparator() {
    return ((DropdownButtonBusStop<String> item1, DropdownButtonBusStop<String> item2) {
      if (item1.routeOrder <= item2.routeOrder) {
        return Comparator.before;
      }
      return Comparator.after;
    });
  }

  // Creates the timetable and sorts the bus stops.
  @override
  void initState() {
    MapDataLoader.getDataLoader().onDataLoaded((mapData) {
      setState(() {
        // Adds all the bus stops to the timetable.
        for (BusStop busStop in mapData.getAllBusStops()) {
          if (busStop.getHasSeparateArrDepTimes()) {
            _addBusStop(
                "${busStop.name} (Arrivals)", busStop.getArrivalTimes(), busStop);
            _addBusStop(
                "${busStop.name} (Departures)", busStop.getDepartureTimes(), busStop);
          } else {
            _addBusStop(busStop.name, busStop.getDepartureTimes(), busStop);
          }
        }

        // Sorts the bus stops so that the stops that the bus gets too first
        // appear at the top of the screen.
        HeapSort<DropdownButtonBusStop<String>> sort =
            HeapSort<DropdownButtonBusStop<String>>(_dropDownButtonsComparator());
        _dropDownButtons = sort.sort(_dropDownButtons);
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
                child: Text(
                  "The bus takes a one-way circular route, stopping at: ",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                )),
            ..._dropDownButtons,
            RichText(
              key: const Key("Timetable footer"),
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
  _addBusStop(String busStopName, Iterable<BusTime> busTimes, BusStop busStop) {
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
    _dropDownButtons.add(DropdownButtonBusStop(
      routeOrder: busStop.getBusStopOrder(),
      value: busStopName,
      items: times,
      menuMaxHeight: 500,
      onChanged: (value) {},
      elevation: 8,
      isExpanded: true,
      underline: Container()
    ));
  }
}
