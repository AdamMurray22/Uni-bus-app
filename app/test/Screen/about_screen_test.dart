import 'package:app/Screen/about_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main()
{
  testWidgets('Finds Top Line', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AboutScreen()));
    final topLineFinder = find.text('This application was made with:');

    expect(topLineFinder, findsOneWidget);
  });

  testWidgets('Finds OpenLayers credit', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AboutScreen()));
    final openLayersFinder = find.byKey(const Key("Open layers credit"));

    expect(openLayersFinder, findsOneWidget);
  });

  testWidgets('Finds OpenStreetMap credit', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AboutScreen()));
    final openStreetMapFinder = find.byKey(const Key("Open Street Map credit"));

    expect(openStreetMapFinder, findsOneWidget);
  });

  testWidgets('Finds Open Source Routing Machine credit', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AboutScreen()));
    final oRSMFinder = find.byKey(const Key("Open Source Routing Machine credit"));

    expect(oRSMFinder, findsOneWidget);
  });

  testWidgets('Finds openstreetmap.de credit', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AboutScreen()));
    final oRSMFinder = find.byKey(const Key("openstreetmap.de credit"));

    expect(oRSMFinder, findsOneWidget);
  });

  testWidgets('Finds fix the map', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AboutScreen()));
    final fixTheMapFinder = find.byKey(const Key("Fix the map"));

    expect(fixTheMapFinder, findsOneWidget);
  });
}