import 'dart:async';

import 'package:flutter/material.dart';

class Debouncer {
  VoidCallback? action;
  Timer? _timer;
  bool forceStopped = false;

  void run(VoidCallback action) {
    _timer?.cancel();
    if (forceStopped) return;
    _timer = Timer(const Duration(milliseconds: Duration.millisecondsPerSecond), action);
  }

  void stop() {
    _timer?.cancel();
  }

  void dispose() {
    _timer?.cancel();
  }
}
