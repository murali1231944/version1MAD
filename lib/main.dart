import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart'; // Import your login screen
import 'dashboard_screen.dart'; // Import your dashboard screen
import 'welcome.dart'; // Import your welcome screen

// Top-level function for background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
  // Handle the background message here (e.g., show a local notification)
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? _deviceToken;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _getDeviceToken();
    _handleForegroundMessages();
  }

  Future<void> _requestPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined permission');
    }
  }

  Future<void> _getDeviceToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      setState(() {
        _deviceToken = token;
      });
      if (token != null) {
        _saveDeviceTokenToFirestore(token);
      }
    } catch (e) {
      print('Error getting device token: $e');
    }
  }

  Future<void> _saveDeviceTokenToFirestore(String token) async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (userId.isNotEmpty) {
        await FirebaseFirestore.instance.collection('users').doc(userId).update(
          {'deviceToken': token},
        );
        print('Device token saved to Firestore');
      }
    } catch (e) {
      print('Error saving device token to Firestore: $e');
    }
  }

  void _handleForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        // Display a dialog or local notification
        _showNotificationDialog(message.notification!);
      }
    });
  }

  void _showNotificationDialog(RemoteNotification notification) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(notification.title ?? 'Notification'),
            content: Text(notification.body ?? ''),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WelcomePage(), // Start with WelcomePage
      routes: {
        '/login_screen': (context) => LoginScreen(),
        '/dashboard': (context) => DashboardScreen(),
      },
    );
  }
}

class GradientScaffold extends StatelessWidget {
  final Widget child;

  const GradientScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade800,
              Colors.blue.shade200,
            ], // Gradient colors
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: child,
      ),
    );
  }
}
