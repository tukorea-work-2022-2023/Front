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
              Get.off(() => ProfileUpdate());
              // Handle the "수정" button press here
              // For example, you can navigate to the edit profile page
              // using Navigator.
              // Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage()));
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
            Text('Nickname: ${userProfileData["nickname"]}'),
            Text('Student Number: ${userProfileData["studentnumber"]}'),
            Text('Major: ${userProfileData["major"]}'),
            // Image.network(userProfileData["image"]),
          ],
        ),
      ),
    );
  }
}
