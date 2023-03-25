import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Map/open_layers_map.dart';

/// This holds the route screen.
class RouteScreen extends StatefulWidget {
  const RouteScreen({super.key});

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

// The route screen state.
class _RouteScreenState extends State<RouteScreen> {
  late final SingleValueDropDownController _fromRouteDropDownController;
  late final SingleValueDropDownController _toRouteDropDownController;
  late final OpenLayersMap _mapController;

  @override
  void initState() {
    _fromRouteDropDownController = SingleValueDropDownController();
    _toRouteDropDownController = SingleValueDropDownController();
    _mapController = OpenLayersMap();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
              child: DropDownTextField(
                controller: _fromRouteDropDownController,
                clearOption: true,
                enableSearch: true,
                textFieldDecoration: const InputDecoration(hintText: "From"),
                searchDecoration:
                    const InputDecoration(hintText: "Enter location here"),
                validator: (value) {
                  if (value == null) {
                    return "Required field";
                  } else {
                    return null;
                  }
                },
                dropDownItemCount: 5,
                dropDownList: [],
                onChanged: (value) {
                  if (value == "") {
                    return;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
              child: DropDownTextField(
                controller: _toRouteDropDownController,
                clearOption: true,
                enableSearch: true,
                textFieldDecoration: const InputDecoration(hintText: "To"),
                searchDecoration:
                    const InputDecoration(hintText: "Enter location here"),
                validator: (value) {
                  if (value == null) {
                    return "Required field";
                  } else {
                    return null;
                  }
                },
                dropDownItemCount: 5,
                dropDownList: [],
                onChanged: (value) {
                  if (value == "") {
                    return;
                  }
                },
              ),
            ),
            Container(
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.69694,
                decoration: BoxDecoration(
                  color: const Color(0x1f000000),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.zero,
                  border: Border.all(color: const Color(0x4d9e9e9e), width: 1),
                ),
                child: WebViewWidget(controller: _mapController)),
          ]),
    );
  }
}
