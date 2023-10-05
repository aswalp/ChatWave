import 'package:chatapp/services/api/apiservices.dart';
import 'package:chatapp/view/auth/loginsrceen.dart';
import 'package:chatapp/view/homescreen/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../responsive/responsive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
      if (Api.auth.currentUser != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => LoginScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: Responsive.h(150, context),
          width: Responsive.w(150, context),
          child: Image.asset(
            "assets/icons/appicon.png",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
