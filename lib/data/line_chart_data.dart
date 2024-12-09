import 'package:fl_chart/fl_chart.dart';
import '../data/load.dart';

class LineData {
  final List<FlSpot> spots = [];
  bool isLoading = true;
  final dataLoader = DataLoader();

  Future<void> initializeData() async {
    _processData();
  }

  void _processData() {
    spots.clear();
    final Map<int, int> monthCount = {};

    for (final record in dataLoader.mongoData) {
      final int month = record.timestamp.month;
      monthCount[month] = (monthCount[month] ?? 0) + 1;
    }

    monthCount.forEach((month, count) {
      print("Month: $month, Count: $count");
      spots.add(FlSpot(month.toDouble(), count.toDouble()));
    });

    spots.sort((a, b) => a.x.compareTo(b.x));
  }

  final Map<int, String> leftTitles = {
    200: '200',
    220: '220',
    240: '240',
    260: '260',
    280: '280',
    300: '300',
    320: '320',
    340: '340',
    360: '360',
    380: '380',
    400: '400',
  };

  final Map<double, String> bottomTitles = {
    1.0: 'Jan',
    2.0: 'Feb',
    3.0: 'Mar',
    4.0: 'Apr',
    5.0: 'May',
    6.0: 'Jun',
    7.0: 'Jul',
    8.0: 'Aug',
    9.0: 'Sep',
    10.0: 'Oct',
    11.0: 'Nov',
    12.0: 'Dec',
  };
}
