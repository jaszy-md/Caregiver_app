import 'package:flutter/material.dart';

class AppLogger {
  static void info(String message) => debugPrint("ℹ️ $message");
  static void error(String message) => debugPrint("❌ $message");
}
