import 'package:app/Screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main()
{
  testWidgets('Finds Title', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainScreen()));
    final titleFinder = find.text('Uni Bus Portsmouth');

    expect(titleFinder, findsOneWidget);
  });

  testWidgets('Finds Bottom Nav Bar Home', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainScreen()));
    final navBarFinder = find.text("Home");

    expect(navBarFinder, findsOneWidget);
  });

  testWidgets('Finds Bottom Nav Bar Route', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainScreen()));
    final navBarFinder = find.byIcon(Icons.arrow_upward);

    expect(navBarFinder, findsOneWidget);
  });

  testWidgets('Finds Bottom Nav Bar Timetable', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainScreen()));
    final navBarFinder = find.text("Timetable");

    expect(navBarFinder, findsOneWidget);
  });

  testWidgets('Finds Bottom Nav Bar About', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainScreen()));
    final navBarFinder = find.text("About");

    expect(navBarFinder, findsOneWidget);
  });

  testWidgets('Taps Nav Bar Timetable', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainScreen()));
    final navBarFinder = find.text("Timetable");
    await tester.tap(navBarFinder);
    await tester.pump();

    expect(find.text("The bus takes a one-way circular route, stopping at: "), findsOneWidget);
  });
}