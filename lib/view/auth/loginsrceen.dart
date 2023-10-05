// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:chatapp/firebase/firebasefunction.dart';
import 'package:chatapp/helper/dialogbox.dart';
import 'package:chatapp/view/homescreen/homescreen.dart';
import 'package:chatapp/view/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final Firebaseserives fireauth = Firebaseserives();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Start Chating"),
      ),
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: Responsive.h(100, context),
          ),
          SizedBox(
            height: Responsive.h(250, context),
            width: Responsive.w(250, context),
            child: Image.asset(
              "assets/icons/appicon.png",
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: Responsive.h(60, context),
          ),
          ElevatedButton.icon(
              icon: SizedBox(
                height: Responsive.h(30, context),
                width: Responsive.w(30, context),
                child: Image.asset(
                  "assets/icons/go.png",
                  fit: BoxFit.cover,
                ),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[300],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  minimumSize: Size(
                      Responsive.w(150, context), Responsive.h(50, context))),
              onPressed: () async {
                //!showing progressincigator
                Dialogbox.progressbar(context);
                try {
                  await fireauth.signInWithGoogle(context).then(
                    (user) async {
                      //!stoping progressincigator

                      Navigator.pop(context);
                      if (user != null) {
                        log('${user.user}');
                        log('${user.additionalUserInfo}');

                        if ((await Firebaseserives.userExist())) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HomeScreen(),
                              ));
                        } else {
                          await Firebaseserives.createuser().then((value) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const HomeScreen(),
                                ));
                          });
                        }
                      }
                    },
                  );
                } on PlatformException catch (e) {
                  log('select your account:$e');
                  Dialogbox.showSnackbar(context, "select your account");
                }
              },
              label: const Text(
                "Sign with gmail",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
    );
  }
}
