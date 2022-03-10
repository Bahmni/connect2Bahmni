import 'dart:async';

import 'package:flutter/material.dart';

class Debouncer {
  VoidCallback? action;
  Timer? timer;

  run(VoidCallback action) {
    if (null != timer) {
      timer!.cancel();
    }
    timer = Timer(const Duration(milliseconds: Duration.millisecondsPerSecond),action,);
    //timer = Timer(const Duration(milliseconds: 500),action,);
  }
}