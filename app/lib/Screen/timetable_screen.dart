import 'package:app/MapData/bus_stop.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../MapData/bus_time.dart';
import '../MapData/map_data_loader.dart';

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
        for (BusStop busStop in mapData.getAllBusStops())
        {
          List<DropdownMenuItem<String>> times = [];
          times.add(DropdownMenuItem(value: busStop.name, child: Text(busStop.name),));
          for (BusTime time in busStop.times)
          {
            times.add(DropdownMenuItem(value: time.toDisplayString(), child: Text(time.toDisplayString()),));
          }
          dropDownButtons.add(DropdownButton(
            value: busStop.name,
            items: times,
            menuMaxHeight: 500,
            onChanged: (value) {  },
            elevation: 8,
            isExpanded: true,
          ));
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [...dropDownButtons,
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'Buses only run on week days during term time excluding bank holidays, check the ',
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
                          path: '/life-at-uni/life-on-campus/getting-to-campus/university-buses'));
                    },
                ),
                const TextSpan(
                  text: ' for a complete list of dates.',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),],
      ),
    ));
  }
}
