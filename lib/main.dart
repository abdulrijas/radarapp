import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'data/load.dart';
import 'dbHelper/mongodb.dart';
import 'pages/auth/sign_in_page.dart'; // Ensure the SignInPage is imported
import 'pages/home_page.dart'; // Ensure the HomePage is imported
import 'pages/dashboard_page.dart'; // Ensure the DashboardPage is imported
import 'pages/assist_page.dart'; // Ensure the AssistPage is imported
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase for background handler
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('Handling background message: ${message.messageId}');
}

// Create notification channel
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.',
  importance: Importance.max,
);

// Initialize FlutterLocalNotificationsPlugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> setupFlutterNotifications() async {
  // Set up notification permissions
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // Create the Android notification channel
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // Initialize local notifications
  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ),
    onDidReceiveNotificationResponse: (details) {
      // Handle notification tap
      print('Notification tapped: ${details.payload}');
    },
  );
}

void showNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: android.smallIcon ?? '@mipmap/ic_launcher',
          priority: Priority.max,
          playSound: true,
          enableVibration: true,
          importance: Importance.max,
        ),
      ),
      payload: message.data.toString(),
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();
  await DataLoader().initializeData();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Setup notifications
  await setupFlutterNotifications();

  // Get FCM token
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print("FCM Token: $fcmToken");

  // Handle foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      showNotification(message);
    }
  });

  // Handle when app is opened from a notification
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('App opened from notification: ${message.data}');
    showNotification(message);
  });

  runApp(const RadarApp());
}

class RadarApp extends StatefulWidget {
  const RadarApp({Key? key}) : super(key: key);

  @override
  _RadarAppState createState() => _RadarAppState();
}

class _RadarAppState extends State<RadarApp> {
  bool _isLoggedIn = false;

  void _onLogin() {
    setState(() {
      _isLoggedIn = true;
    });
  }

  void _onLogout() {
    setState(() {
      _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: const MaterialScrollBehavior()
          .copyWith(dragDevices: PointerDeviceKind.values.toSet()),
      debugShowCheckedModeBanner: false,
      title: 'Radar App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: _isLoggedIn
          ? MainPage(onLogout: _onLogout)
          : SignInPage(onSignIn: _onLogin),
    );
  }
}

class MainPage extends StatefulWidget {
  final VoidCallback onLogout;

  const MainPage({Key? key, required this.onLogout}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0; // Default to Home tab

  // Define the pages at the class level
  final List<Widget> _pages = [
    HomePage(
      onLogout: () {
        SignInPage;
      },
    ), // Ensure HomePage is imported and defined
    const DashboardPage(), // Ensure DashboardPage is imported and defined
    const AssistPage(), // Ensure AssistPage is imported and defined
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Radar App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      SignInPage(onSignIn: () {}),
                ),
              );
            }, // Trigger logout callback
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Image covering entire screen
          Positioned.fill(
            child: Image.asset(
              'assets/images/dashb.jpg', // Path to your image
              fit: BoxFit.cover, // Ensures the image covers the entire screen
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Content on top of the background
          _pages[_currentIndex],
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Switch tabs
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(
              icon: Icon(Icons.assist_walker), label: 'Assist'),
        ],
      ),
    );
  }
}
