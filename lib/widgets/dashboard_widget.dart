import '../util/responsive.dart'; // Adjusted to a relative path
import '../widgets/bar_graph_widget.dart'; // Adjusted to a relative path
import '../widgets/line_chart_card.dart'; // Adjusted to a relative path
import '../widgets/summary_widget.dart'; // Adjusted to a relative path
import 'package:flutter/material.dart';
import '../widgets/pie_chart_widget.dart';

class DashboardWidget extends StatelessWidget {
  const DashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: [
            const SizedBox(height: 1),
            const Chart(),
            const SizedBox(height: 18),
            const LineChartCard(),
            const SizedBox(height: 18),
            const BarGraphCard(),
            const SizedBox(height: 18),
            if (Responsive.isTablet(context)) const SummaryWidget(),
          ],
        ),
      ),
    );
  }
}
