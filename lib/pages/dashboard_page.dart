import '../util/responsive.dart';
import '../widgets/dashboard_widget.dart';
import '../widgets/summary_widget.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  void _showFilterDialog(BuildContext context) {
    final List<String> years = ["ALL", "2024", "2023", "2022", "2021", "2020"];
    final List<String> months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    String? selectedYear;
    String? selectedMonth;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Modal Title
                  const Center(
                    child: Text(
                      "Select Filters",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Year Selection Dropdown
                  const Text("Year", style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    value: selectedYear,
                    hint: const Text("Select Year",
                        style: TextStyle(color: Colors.white)),
                    dropdownColor: Colors.grey[850],
                    isExpanded: true,
                    icon:
                        const Icon(Icons.arrow_drop_down, color: Colors.white),
                    items: years
                        .map((year) => DropdownMenuItem<String>(
                              value: year,
                              child: Text(year,
                                  style: const TextStyle(color: Colors.white)),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedYear = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  // Month Selection Dropdown
                  const Text("Month", style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    value: selectedMonth,
                    hint: const Text("Select Month",
                        style: TextStyle(color: Colors.white)),
                    dropdownColor: Colors.grey[850],
                    isExpanded: true,
                    icon:
                        const Icon(Icons.arrow_drop_down, color: Colors.white),
                    items: months
                        .map((month) => DropdownMenuItem<String>(
                              value: month,
                              child: Text(month,
                                  style: const TextStyle(color: Colors.white)),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedMonth = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  // Apply Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Use the selectedYear and selectedMonth for filtering logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                      child: const Text("Apply Filters",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: Image.asset(
            'assets/images/dashb.jpg',
            // Replace with your background image path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        // Foreground content
        Scaffold(
          backgroundColor: Colors.transparent,
          drawer: !isDesktop
              ? const SizedBox(
                  width: 250,
                )
              : null,
          endDrawer: Responsive.isMobile(context)
              ? SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: const SummaryWidget(),
                )
              : null,
          body: SafeArea(
            child: Stack(
              children: [
                // Main Content
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dashboard Widget
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: DashboardWidget(), // Your content
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Filter Button at Bottom-Right
                Positioned(
                  bottom: 10,
                  right: 20,
                  child: ElevatedButton(
                    onPressed: () => _showFilterDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text("Filter",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
