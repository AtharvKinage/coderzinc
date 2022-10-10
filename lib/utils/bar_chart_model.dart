import 'package:charts_flutter/flutter.dart' as charts;

class BarChartModel {
  String eventType;
  int time;
  final charts.Color color;

  BarChartModel({
    required this.eventType,
    required this.time,
    required this.color,
  });
}
