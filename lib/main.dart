import 'package:cosmicvision/notification.dart';
import 'package:cosmicvision/views/home.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.request();
  if (await Permission.notification.isGranted) {
    NotificationHelper.scheduleDailyNotification();
  }
  runApp(MaterialApp(
    theme: ThemeData(
        appBarTheme:
            const AppBarTheme(iconTheme: IconThemeData(color: Colors.white))),
    home: const Home(),
    debugShowCheckedModeBanner: false,
  ));
}
