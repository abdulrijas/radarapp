import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../data/load.dart';

const Color droneColor = Color(0xFF26E5FF);
const Color birdColor = Color(0xFFFFCF26);

class ChartData {
  final List<PieChartSectionData> pieChartSectionData = [];
  bool isLoading = true;

  final dataLoader = DataLoader();

  Future<void> initializeData() async {
    _processData();
  }

  void _processData() {
    for (var item in dataLoader.mongoData) {
      final type = item.type as String;
      final value = type == 'Drone' ? 1 : 2; // Assign values based on type
      final color = type == 'Drone' ? droneColor : birdColor;

      pieChartSectionData.add(
        PieChartSectionData(
          color: color,
          value: value.toDouble(),
          showTitle: false,
        ),
      );
    }
  }
}
