import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;

import '../../../controller/user_controller.dart';
import '../../../global/global.dart';
import 'ProfileUpdate.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Map<String, dynamic> userProfileData = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(
        Uri.parse('${Global.baseUrl}/account/profile/${AuthService.userId}'));
    if (response.statusCode == 200) {
      setState(() {
        final decodedBody =
            utf8.decode(response.bodyBytes); // Decode the response body
        userProfileData = json.decode(decodedBody);
        print(userProfileData);
      });
    } else {
      // Handle error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        actions: [
          TextButton(
            onPressed: () {
              Get.off(() => ProfileUpdate(userData: userProfileData));
            },
            child: Text(
              '수정',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
                image: userProfileData["image"] != null
                    ? DecorationImage(
                        image: NetworkImage(userProfileData["image"]),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: userProfileData["image"] == null
                  ? Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.grey,
                    )
                  : null,
            ),
            SizedBox(height: 24),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    'Nickname: ${userProfileData["nickname"]}',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Student Number: ${userProfileData["studentnumber"]}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Major: ${userProfileData["major"]}',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
