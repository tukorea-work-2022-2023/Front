import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../constant/constant.dart';
import 'package:http/http.dart' as http;

import '../../controller/user_controller.dart';
import '../../global/global.dart';
import '../User/Login.dart';

class Setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appName),
        centerTitle: false,
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _sendRefreshToken,
            child: Text('로그아웃'),
          )
        ],
      )),
    );
  }
}

void _sendRefreshToken() async {
  final String refreshToken = '${AuthService.refreshToken}';

  // Create a map with the refresh token data
  Map<String, String> refreshTokenData = {
    'refresh': refreshToken,
  };

  // Convert the data map to a JSON string
  String jsonData = jsonEncode(refreshTokenData);

  // Set the request headers
  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  // Send the POST request
  final response = await http.post(
    Uri.parse('${Global.baseUrl}/account/login/refresh/'),
    headers: headers,
    body: jsonData,
  );

  // Check the response
  if (response.statusCode == 200) {
    // Refresh token successful
    Get.offAll(() => Login());
    print('Refresh token successful! Response: ${response.body}');
  } else {
    // Refresh token failed
    print('Login failed. Error: ${response.reasonPhrase}');
  }
}
