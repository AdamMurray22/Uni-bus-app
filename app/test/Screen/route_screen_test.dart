import 'package:app/Screen/route_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Finds From Search bar', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: RouteScreen()));
    final fromSearchBarFinder = find.text("From");

    expect(fromSearchBarFinder, findsOneWidget);
  });

  testWidgets('Finds To Search bar', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: RouteScreen()));
    final toSearchBarFinder = find.text("To");

    expect(toSearchBarFinder, findsOneWidget);
  });
}