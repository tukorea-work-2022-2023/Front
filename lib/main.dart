import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Myapp.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

bool isLoggedIn = false;
