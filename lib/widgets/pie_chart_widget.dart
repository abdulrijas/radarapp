import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../data/pie_chart_data.dart'; // Import ChartData class

class Chart extends StatelessWidget {
  const Chart({super.key});

  @override
  Widget build(BuildContext context) {
    // Create an instance of ChartData
    final chartData = ChartData();
    int droneCount = 0;
    int birdCount = 0;

    return FutureBuilder(
      // Use FutureBuilder to wait for data to load
      future: chartData.initializeData(), // Ensure data is initialized
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator()); // Show loading indicator
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error: ${snapshot.error}')); // Handle error
        } else {
          // Data is loaded, now build the pie chart
          final pieChartSectionData = chartData.pieChartSectionData;
          for (var section in pieChartSectionData) {
            if (section.value == 1) {
              droneCount += 1;
            } else if (section.value == 2) {
              birdCount += 1;
            }
          }

          int totalCount = droneCount + birdCount;
          double dronePercentage = (droneCount / totalCount) * 100;
          double birdPercentage = (birdCount / totalCount) * 100;

          // Create pie chart sections based on drone and bird counts
          List<PieChartSectionData> sections = [
            PieChartSectionData(
              color: Color(0xFF26E5FF), // Color for drone
              value: dronePercentage,
              showTitle: false, // Hide the title inside the section
            ),
            PieChartSectionData(
              color: Color(0xFF6200EA), // Color for bird
              value: birdPercentage,
              showTitle: false, // Hide the title inside the section
            ),
          ];

          // Return the pie chart widget with data
          return SizedBox(
            height: 250,
            child: Stack(
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 70,
                    startDegreeOffset: -90,
                    sections:
                        sections, // Pass the correctly constructed sections
                  ),
                ),
                // Positioning the drone text on the left side
                Positioned(
                  top: 10,
                  left: 10,
                  child: Column(
                    children: [
                      Text(
                        'Bird\n$birdCount',
                        style: const TextStyle(
                          fontSize: 25,
                          // Bigger font size
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6200EA),
                          height: 1.2,
                          shadows: [
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Positioning the bird text on the right side
                Positioned(
                  top: 10,
                  right: 10, // Adjusted to position the text on the right
                  child: Column(
                    children: [
                      Text(
                        'Drone\n$droneCount',
                        style: const TextStyle(
                          fontSize: 25,
                          // Bigger font size
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF26E5FF),
                          height: 1.2,
                          shadows: [
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ],
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
