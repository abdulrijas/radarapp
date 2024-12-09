import 'package:flutter/material.dart';
import 'package:radar/dbHelper/mongodb.dart';
import 'package:radar/pages/upload_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int birdCount = 0;
  int droneCount = 0;

  Future<void> fetchData() async {
    try {
      // Connect to MongoDB
      await MongoDatabase.connect();
      final data = await MongoDatabase.getData();

      // Current UTC time
      final now = DateTime.now().toUtc();

      // 24 hours ago
      final last24Hours = now.subtract(const Duration(hours: 24));

      // Reset counts before recalculating
      int birdCountTemp = 0;
      int droneCountTemp = 0;

      // Filter and count data
      for (var entry in data) {
        final timestampStr = entry['timestamp'];
        if (timestampStr != null) {
          final timestamp = DateTime.tryParse(timestampStr)?.toUtc();
          if (timestamp != null && timestamp.isAfter(last24Hours)) {
            if (entry['type'] == 'Bird') {
              birdCountTemp++;
            } else if (entry['type'] == 'Drone') {
              droneCountTemp++;
            }
          }
        }
      }

      // Ensure widget is still mounted before updating state
      if (mounted) {
        setState(() {
          birdCount = birdCountTemp;
          droneCount = droneCountTemp;
        });
      }
    } catch (e) {
      // Handle any errors
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: Colors.blue,
      onRefresh: () async {
        // Replace this delay with the code to be executed during refresh
        // and return asynchronous code
        return Future<void>.delayed(const Duration(seconds: 3));
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadPage()),
                );
              },
              child: const Text('Predict'),
            ),
            const SizedBox(height: 20),
            // Adds space between the button and the count boxes
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Bird Count Box
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Bird Count',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        '$birdCount',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ],
                  ),
                ),
                // Drone Count Box
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Drone Count',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        '$droneCount',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//
// import 'package:flutter/material.dart';
// import 'package:radar/dbHelper/mongodb.dart';
// import 'package:radar/pages/upload_page.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key, required this.onLogout});
//   final VoidCallback onLogout;
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   int birdCount = 0;
//   int droneCount = 0;
//
//   Future<void> fetchData() async {
//     try {
//       // Connect to MongoDB
//       await MongoDatabase.connect();
//       final data = await MongoDatabase.getData();
//
//       // Current UTC time
//       final now = DateTime.now().toUtc();
//
//       // 24 hours ago
//       final last24Hours = now.subtract(const Duration(hours: 24));
//
//       // Reset counts before recalculating
//       int birdCountTemp = 0;
//       int droneCountTemp = 0;
//
//       // Filter and count data
//       for (var entry in data) {
//         final timestampStr = entry['timestamp'];
//         if (timestampStr != null) {
//           final timestamp = DateTime.tryParse(timestampStr)?.toUtc();
//           if (timestamp != null && timestamp.isAfter(last24Hours)) {
//             if (entry['type'] == 'Bird') {
//               birdCountTemp++;
//             } else if (entry['type'] == 'Drone') {
//               droneCountTemp++;
//             }
//           }
//         }
//       }
//
//       // Ensure widget is still mounted before updating state
//       if (mounted) {
//         setState(() {
//           birdCount = birdCountTemp;
//           droneCount = droneCountTemp;
//         });
//       }
//     } catch (e) {
//       // Handle any errors
//       print('Error fetching data: $e');
//     }
//   }
//
//
//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: RefreshIndicator(
//         color: Colors.white,
//         backgroundColor: Colors.blue,
//         onRefresh: fetchData,
//         child: SizedBox.expand(
//           child: Column(
//             children: [
//               // Predict button at the top
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 20),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => UploadPage()),
//                     );
//                   },
//                   child: const Text('Predict'),
//                 ),
//               ),
//               // Spacer to push the boxes to the center
//               const Spacer(),
//               // Bird and Drone Count Boxes
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Bird Count Box
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     margin: const EdgeInsets.symmetric(horizontal: 8),
//                     decoration: BoxDecoration(
//                       color: Colors.blueAccent,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Column(
//                       children: [
//                         const Text(
//                           'Bird Count',
//                           style: TextStyle(color: Colors.white, fontSize: 16),
//                         ),
//                         Text(
//                           '$birdCount',
//                           style: const TextStyle(color: Colors.white, fontSize: 24),
//                         ),
//                       ],
//                     ),
//                   ),
//                   // Drone Count Box
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     margin: const EdgeInsets.symmetric(horizontal: 8),
//                     decoration: BoxDecoration(
//                       color: Colors.redAccent,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Column(
//                       children: [
//                         const Text(
//                           'Drone Count',
//                           style: TextStyle(color: Colors.white, fontSize: 16),
//                         ),
//                         Text(
//                           '$droneCount',
//                           style: const TextStyle(color: Colors.white, fontSize: 24),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               // Spacer to keep the layout centered
//               const Spacer(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
