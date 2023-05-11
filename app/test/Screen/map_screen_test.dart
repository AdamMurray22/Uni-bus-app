import 'package:app/Screen/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main()
{
  testWidgets('Finds U1 text', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MapScreen()));
    final u1Finder = find.text('U1');

    expect(u1Finder, findsOneWidget);
  });

  testWidgets('Finds U1 button', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MapScreen()));
    final u1Finder = find.byKey(const Key("U1 toggle button"));

    expect(u1Finder, findsOneWidget);
  });

  testWidgets('Finds Uni building text', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MapScreen()));
    final uniBuildingFinder = find.text('Uni buildings');

    expect(uniBuildingFinder, findsOneWidget);
  });

  testWidgets('Finds Uni building button', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MapScreen()));
    final uniBuildingFinder = find.byKey(const Key("Uni building toggle button"));

    expect(uniBuildingFinder, findsOneWidget);
  });

  testWidgets('Finds Landmark text', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MapScreen()));
    final landmarkFinder = find.text('Landmarks');

    expect(landmarkFinder, findsOneWidget);
  });

  testWidgets('Finds Landmark button', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MapScreen()));
    final landmarkFinder = find.byKey(const Key("Landmark toggle button"));

    expect(landmarkFinder, findsOneWidget);
  });

  testWidgets('Finds Search bar', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MapScreen()));
    final searchBarFinder = find.text("Search");

    expect(searchBarFinder, findsOneWidget);
  });
}