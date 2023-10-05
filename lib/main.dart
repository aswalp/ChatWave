import 'dart:developer';

import 'package:chatapp/view/splachscreen/splahscreen.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
// import 'package:flutter_notification_channel/notification_visibility.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    var result = await FlutterNotificationChannel.registerNotificationChannel(
      description: 'For showing message notifaction',
      id: 'chats',
      importance: NotificationImportance.IMPORTANCE_HIGH,
      name: 'chats',
    );
    log("notification:=$result");
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Color(0xff28282B)),
            backgroundColor: Color(0xff98c1d9),
            titleTextStyle: TextStyle(
                fontSize: 24,
                color: Color(0xff28282B),
                fontWeight: FontWeight.w300),
            elevation: 1,
          )),
      home: const SplashScreen(),
    );
  }
}
