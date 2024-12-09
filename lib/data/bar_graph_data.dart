import 'package:flutter/material.dart';
import '../model/bar_graph_model.dart';
import '../model/graph_model.dart';
import '../data/load.dart';

class BarGraphData {
  final List<BarGraphModel> data = [];
  bool isLoading = true;

  final dataLoader = DataLoader();

  Future<void> initializeData() async {
    _processData();
  }

  // Process data for bar graph
  void _processData() {
    data.clear();
    List<int> droneCounts = List.filled(7, 0);
    List<int> birdCounts = List.filled(7, 0);

    const List<String> daysOfWeek = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ];

    for (final record in dataLoader.mongoData) {
      final int dayIndex = daysOfWeek.indexOf(record.dayOfWeek);
      if (dayIndex != -1) {
        if (record.type == "Drone") {
          droneCounts[dayIndex]++;
        } else if (record.type == "Bird") {
          birdCounts[dayIndex]++;
        }
      }
    }

    List<double> dronePercentages = [];
    List<double> birdPercentages = [];

    for (int i = 0; i < 7; i++) {
      int totalCount = droneCounts[i] + birdCounts[i];
      if (totalCount > 0) {
        dronePercentages.add(double.parse(
            ((droneCounts[i] / totalCount) * 100).toStringAsFixed(2)));
        birdPercentages.add(double.parse(
            ((birdCounts[i] / totalCount) * 100).toStringAsFixed(2)));
      } else {
        dronePercentages.add(0.0);
        birdPercentages.add(0.0);
      }
    }

    data.add(BarGraphModel(
      label: "Drone Activity in %",
      color: Color(0xFFFEB95A),
      graph: List.generate(
          7,
          (index) =>
              GraphModel(x: index.toDouble(), y: dronePercentages[index])),
    ));

    data.add(BarGraphModel(
      label: "Bird Activity in %",
      color: Color(0xFFF2C8ED),
      graph: List.generate(
          7,
          (index) =>
              GraphModel(x: index.toDouble(), y: birdPercentages[index])),
    ));
  }

  final label = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
}
