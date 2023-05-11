import 'package:app/Screen/timetable_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Finds title', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: TimetableScreen()));
    final titleFinder = find.text('The bus takes a one-way circular route, stopping at: ');

    expect(titleFinder, findsOneWidget);
  });

  testWidgets('Finds footer', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: TimetableScreen()));
    final footerFinder = find.byKey(const Key("Timetable footer"));

    expect(footerFinder, findsOneWidget);
  });
}