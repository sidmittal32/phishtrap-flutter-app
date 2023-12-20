import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:notification_reader/notification_reader.dart';
import 'notification_service.dart';
import 'about.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _MyAppState();
}

class _MyAppState extends State<HomePage> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  List<NotificationData> titleList = [];
  Map<String, String> predictionResults = {};
  Set<NotificationData> fetchedNotifications = {};
  late Timer _timer;
  final int _timerIntervalInSeconds =
      5; // Set the interval for checking notifications (in seconds)
  Set<String> uniqueNotificationIds = {};

  @override
  void initState() {
    super.initState();
    initPlatformState();

    // Initialize the flutterLocalNotificationsPlugin
    initializeNotifications();

    // Start a periodic timer after initState is called
    _timer =
        Timer.periodic(Duration(seconds: _timerIntervalInSeconds), (Timer t) {
      initPlatformState();
    });
  }

  @override
  void dispose() {
    // Cancel the timer to avoid memory leaks when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF0a1034),
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 42, 64, 136),
          title: const Text(
            'Notification Prediction',
            style: TextStyle(),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
              icon: const Icon(Icons.info_outline), // Icon for AboutPage
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 105, 141, 240),
                      Color.fromARGB(255, 42, 67, 136),
                    ], // Replace with your gradient colors
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    await NotificationReader.openNotificationReaderSettings;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.transparent, // Make button transparent
                    shadowColor: Colors.transparent, // Remove shadow
                    padding: const EdgeInsets.all(16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    "Allow App to Read Notifications",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 105, 141, 240),
                      Color.fromARGB(255, 42, 67, 136),
                    ], // Replace with your gradient colors
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    initPlatformState();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.transparent, // Make button transparent
                    shadowColor: Colors.transparent, // Remove shadow
                    padding: const EdgeInsets.all(16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    "Check Received Notification",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                primary: false,
                reverse: true,
                itemCount: titleList.length,
                itemBuilder: (c, i) {
                  String body = titleList[i].body ?? "";
                  String prediction = predictionResults[body] ?? "";
                  Color boxColor =
                      prediction == "Smishing" ? Colors.red : Colors.green;

                  return SizedBox(
                    height: 120, // Set a fixed height for each card
                    child: Card(
                      color: boxColor,
                      elevation: 5,
                      margin: const EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              titleList[i].title ?? "",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Text(
                                  body,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            Text(
                              titleList[i].packageName ?? "",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> requestNotificationPermissions() async {
    // Check if the platform is Android
    if (Theme.of(context).platform == TargetPlatform.android) {
      // Check if notification permission is granted
      PermissionStatus status = await Permission.notification.status;

      if (!status.isGranted) {
        // Request notification permission only for Android
        Map<Permission, PermissionStatus> statuses = await [
          Permission.notification,
        ].request();

        if (statuses[Permission.notification] == PermissionStatus.granted) {
          // Permission granted, proceed with handling notifications
          // Call the method for handling notifications or initialization here
        } else {
          // Permission denied. You might want to display a message to the user.
        }
      } else {
        // Permission was already granted previously, proceed with handling notifications
        // Call the method for handling notifications or initialization here
      }
    } else {
      // Handle other platforms if needed
    }
  }

  Future<void> initializeNotifications() async {
    // Create an instance of FlutterLocalNotificationsPlugin
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Configure settings for Android and iOS
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            'app_icon'); // Replace 'app_icon' with your app's icon name

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: null, // No specific iOS settings for this example
    );

    // Initialize the plugin with the settings
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Function to show local notification for Smishing attempt
  // Function to show local notification for Smishing attempt
  Future<void> showSmishingNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'smishing_channel_id',
      'Smishing Channel',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Construct the notification message including the title and body
    String notificationMessage =
        'Potential Smishing Attempt\n\nTitle: $title\nBody: $body\n\nBe cautious. This may be a Smishing attempt!';

    // Show the notification to the user
    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID (change as needed)
      'Potential Smishing Attempt',
      notificationMessage,
      platformChannelSpecifics,
      payload: 'Smishing Notification',
    );
  }

  // Inside your initPlatformState() function
  // Inside your initPlatformState() function
  Future<void> initPlatformState() async {
    var res = await NotificationReader.onNotificationRecieve();

    // Check if the notification is from Google Messages
    if (res.packageName == 'com.google.android.apps.messaging' &&
        res.body != null) {
      fetchedNotifications.add(res);

      // Classify the notification to check if it's Smishing
      await classifyNotification(res, predictionResults);

      // Check if the title or body already exists in the titleList
      bool alreadyExists = titleList.any((notification) =>
          notification.title == res.title && notification.body == res.body);

      if (!alreadyExists) {
        setState(() {
          titleList.add(res);
        });

        // Check if the prediction is 'Smishing' and send a notification
        if (predictionResults[res.body!] == 'Smishing') {
          await showSmishingNotification(res.title ?? '', res.body ?? '');
        }
      }
    }
  }
}
