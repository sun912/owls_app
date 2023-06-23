import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';

class RuleItem {
  RuleItem({
    required this.key,
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
    this.isApplied = false,
  });
  String expandedValue;
  String headerValue;
  bool isExpanded;
  bool isApplied;
  GlobalKey<ExpansionTileCardState> key;
}
