import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lazyui/lazyui.dart';

class Toasts {
  static show(String? text, [Position position = Position.center, Duration duration = const Duration(seconds: 5)]) {
    LzToast.show(text, position: position, duration: duration);

    // Fluttertoast.showToast(msg: text!, toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.CENTER,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: const Color.fromARGB(255, 65, 64, 64),
    //     textColor: Colors.white,
    //     fontSize: 16.0);
  }

  static overlay([String message = 'Loading...']) => LzToast.overlay(message);

  static dismiss() {
    LzToast.dismiss();
    // Fluttertoast.cancel();
  }
}
