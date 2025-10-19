import 'package:flutter/foundation.dart';

class JoystickController {
  static final JoystickController _instance = JoystickController._internal();
  factory JoystickController() => _instance;
  JoystickController._internal();

  final ValueNotifier<bool> activeNotifier = ValueNotifier(true);

  bool get active => activeNotifier.value;

  void setActive(bool value) {
    if (activeNotifier.value != value) {
      activeNotifier.value = value;
    }
  }
}
