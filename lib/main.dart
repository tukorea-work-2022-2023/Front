import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Myapp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

bool isLoggedIn = false;
