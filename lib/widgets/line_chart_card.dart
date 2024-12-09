import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../const/constant.dart';
import '../data/line_chart_data.dart';
import '../widgets/custom_card_widget.dart';

class LineChartCard extends StatelessWidget {
  const LineChartCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = LineData();

    return FutureBuilder<void>(
      future: data.initializeData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final line = data.spots;

          return CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Drone Year Analysis",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[400]),
                ),
                const SizedBox(height: 30),
                AspectRatio(
                  aspectRatio: 16 / 6,
                  child: LineChart(
                    LineChartData(
                      lineTouchData: const LineTouchData(
                        handleBuiltInTouches: true,
                      ),
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return data.bottomTitles[value] != null
                                  ? SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      child: Text(
                                        data.bottomTitles[value]!,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    )
                                  : const SizedBox();
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              return data.leftTitles[value.toInt()] != null
                                  ? Text(
                                      data.leftTitles[value.toInt()]!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[400],
                                      ),
                                    )
                                  : const SizedBox();
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          color: selectionColor,
                          barWidth: 2.5,
                          belowBarData: BarAreaData(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                selectionColor.withOpacity(0.5),
                                Colors.transparent,
                              ],
                            ),
                            show: true,
                          ),
                          dotData: FlDotData(show: false),
                          spots: line,
                        ),
                      ],
                      minX: 1,
                      maxX: 12,
                      minY: 300,
                      maxY: 500,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
