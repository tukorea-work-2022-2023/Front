import 'package:book/screens/User/Login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../global/global.dart'; // http 패키지 임포트

class EmailCheck extends StatelessWidget {
  EmailCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메일 인증'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: '인증 코드 입력',
                  border: OutlineInputBorder(),
                ),
                controller: _verificationCodeController,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _verifyCode(); // 인증 코드 확인 메소드 호출
              },
              child: Text('인증 확인'),
            ),
          ],
        ),
      ),
    );
  }

  final TextEditingController _verificationCodeController =
      TextEditingController(); // 컨트롤러 생성

  Future<void> _verifyCode() async {
    final url = Uri.parse('${Global.baseUrl}/account/verify/');

    final response = await http.post(
      url,
      body: {
        "verification_code": _verificationCodeController.text,
      },
    );

    if (response.statusCode == 200) {
      // 성공적으로 응답을 받은 경우
      print('인증 성공');
      Get.offAll(() => Login());
    } else {
      // 인증 실패 처리
      print('인증 실패');
    }
  }
}
