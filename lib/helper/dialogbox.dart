import 'package:flutter/material.dart';

class Dialogbox {
  static void showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: const Color(0xff98c1d9).withOpacity(.8),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void progressbar(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => const Center(
              child: CircularProgressIndicator(
                color: Color(0xff98c1d9),
              ),
            ));
  }
}
