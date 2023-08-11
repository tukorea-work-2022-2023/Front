import 'package:book/screens/ItBook.dart';
import 'package:book/screens/User/First.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'main.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? ItBook() : First(), // 로그인 상태에 따라 페이지 결정
    );
  }
}
