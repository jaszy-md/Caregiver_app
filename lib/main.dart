import 'package:flutter/material.dart';
import 'core/services/firebase/firebase_initializer.dart';
import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase init via jouw initializer
  await FirebaseInitializer.init();

  print('✅ Firebase initialized successfully for CareLink');

  runApp(const CareLinkApp());
}
