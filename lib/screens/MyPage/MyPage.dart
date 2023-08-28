import 'dart:convert';

import 'package:book/screens/MyPage/profile/Profile.dart';
import 'package:book/screens/MyPage/setting.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../constant/constant.dart';
import '../../controller/user_controller.dart';
import '../../global/global.dart';
import '../IamPort/PayPage.dart';
import 'package:http/http.dart' as http;

class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
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
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 30),
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
                    size: 60,
                    color: Colors.grey,
                  )
                : null,
          ),
          Text(
            '${userProfileData["nickname"]}',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Welcome to your profile!',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('My Profile'),
            onTap: () {
              Get.to(() => UserProfilePage());
            },
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Payment'),
            onTap: () {
              Get.to(() => PaymentScreen());
            },
          ),
          // Add more ListTile items for other features
          ListTile(
            leading: Icon(Icons.post_add),
            title: Text('My Posts'),
            onTap: () {
              // Navigate to My Posts screen
            },
          ),
          ListTile(
            leading: Icon(Icons.bookmark),
            title: Text('Saved Posts'),
            onTap: () {
              // Navigate to Saved Posts screen
            },
          ),
          ListTile(
            leading: Icon(Icons.receipt),
            title: Text('내가 대여한 도서'),
            onTap: () {
              // Navigate to Rented Posts screen
            },
          ),
        ],
      ),
    );
  }
}
