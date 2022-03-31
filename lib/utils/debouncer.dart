import 'dart:async';

import 'package:flutter/material.dart';

class Debouncer {
  VoidCallback? action;
  Timer? timer;
  bool forceStopped = false;

  run(VoidCallback action) {
    if (null != timer) {
      timer!.cancel();
    }
    if (forceStopped) return;
    timer = Timer(const Duration(milliseconds: Duration.millisecondsPerSecond),action,);
    //timer = Timer(const Duration(milliseconds: 500),action,);
  }

  void forceStop() {
    forceStopped = true;
  }
}