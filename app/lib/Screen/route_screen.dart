import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    _fromRouteDropDownController = SingleValueDropDownController();
    _toRouteDropDownController = SingleValueDropDownController();
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
            DropDownTextField(
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
            DropDownTextField(
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
          ]),
    );
  }
}
