import 'package:app/MapData/bus_stop.dart';
import 'package:flutter/material.dart';

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
        children: dropDownButtons,
      ),
    ));
  }
}
