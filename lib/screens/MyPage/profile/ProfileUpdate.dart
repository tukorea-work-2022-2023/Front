import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../controller/user_controller.dart';
import '../../../global/global.dart';
import 'Profile.dart';

class ProfileUpdate extends StatefulWidget {
  @override
  _ProfileUpdateState createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController studentNumberController = TextEditingController();
  final TextEditingController majorController = TextEditingController();
  final TextEditingController interestController = TextEditingController();

  Future<void> updateProfile() async {
    final String url =
        '${Global.baseUrl}/account/profile/${AuthService.userId}';

    Map<String, dynamic> requestBody = {
      "user": "${AuthService.userId}",
      "nickname": nicknameController.text,
      "studentnumber": studentNumberController.text,
      "major": majorController.text,
      "interest":
          interestController.text.split(",").map((e) => e.trim()).toList(),
      // "image": "http://127.0.0.1:8000/media/profile/mike_Zh0IIXB.png",
    };

    String authorizationToken = "${AuthService.accessToken}";

    try {
      final http.Response response = await http.put(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authorizationToken",
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // 성공적으로 업데이트된 경우의 처리
        print("프로필 업데이트 성공");
        Get.off(() => UserProfilePage());
      } else {
        // 실패한 경우의 처리
        print("프로필 업데이트 실패");
      }
    } catch (e) {
      print("오류 발생: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('프로필 업데이트'),
        actions: [
          TextButton(
            onPressed: () {
              updateProfile();
            },
            child: Text(
              '완료',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: nicknameController,
              decoration: InputDecoration(labelText: '닉네임'),
            ),
            TextFormField(
              controller: studentNumberController,
              decoration: InputDecoration(labelText: '학번'),
            ),
            TextFormField(
              controller: majorController,
              decoration: InputDecoration(labelText: '전공'),
            ),
            TextFormField(
              controller: interestController,
              decoration: InputDecoration(labelText: '관심사 (쉼표로 구분하여 입력)'),
            ),
          ],
        ),
      ),
    );
  }
}
