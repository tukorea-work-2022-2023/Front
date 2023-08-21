import 'package:book/screens/MyPage/profile/Profile.dart';
import 'package:book/screens/MyPage/setting.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../constant/constant.dart';
import '../IamPort/PayPage.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appName),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => Setting());
              },
              icon: Icon(Icons.settings))
        ],
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('마이 페이지'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Get.to(() => UserProfilePage());
            },
            child: Text('프로필 조회'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.to(() => PaymentScreen());
            },
            child: Text('결제'),
          )
        ],
      )),
    );
  }
}
