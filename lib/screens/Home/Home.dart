import 'package:book/screens/Home/Board/ChoicePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/constant.dart';
import '../../controller/user_controller.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // print('사용자가 로그인되었습니다. Access Token: ${AuthService.accessToken}');
    // print('사용자 ID: ${AuthService.userId}');
    return Scaffold(
      appBar: AppBar(
        title: Text(appName),
        centerTitle: false,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications_active)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => ChoicePage());
        },
        child: Icon(Icons.add),
      ),
      body: Center(
        child: Text('home 페이지'),
      ),
    );
  }
}
