import 'package:flutter/material.dart';

/// Extends DropdownButton to allow DropdownButton's to hold a routeOrder fpr sorting purposes.
class DropdownButtonBusStop<E> extends DropdownButton<E>
{
  final int routeOrder;
  DropdownButtonBusStop({super.key, required this.routeOrder, required super.items, required super.onChanged, required super.value, required super.menuMaxHeight, required super.elevation, required super.isExpanded, required super.underline});
}