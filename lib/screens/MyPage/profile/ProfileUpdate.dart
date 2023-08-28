import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../controller/user_controller.dart';
import '../../../global/global.dart';
import 'Profile.dart';

class ProfileUpdate extends StatefulWidget {
  final Map<String, dynamic> userData;

  ProfileUpdate({required this.userData});
  @override
  _ProfileUpdateState createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  late TextEditingController nicknameController;
  late TextEditingController studentNumberController;
  late TextEditingController majorController;
  late TextEditingController interestController;
  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();

    // Initialize the controllers with userData values
    nicknameController =
        TextEditingController(text: widget.userData['nickname']);
    studentNumberController =
        TextEditingController(text: widget.userData['studentnumber']);
    majorController = TextEditingController(text: widget.userData['major']);
    if (widget.userData.containsKey('interest') &&
        widget.userData['interest'] != null) {
      interestController =
          TextEditingController(text: widget.userData['interest'].join(', '));
    } else {
      interestController =
          TextEditingController(); // Initialize with empty text
    }
  }

  Future<void> updateProfile() async {
    final String url =
        '${Global.baseUrl}/account/profile/${AuthService.userId}';

    String authorizationToken = "${AuthService.accessToken}";

    try {
      var request = http.MultipartRequest('PUT', Uri.parse(url));
      request.headers['Authorization'] = 'Bearer $authorizationToken';

      if (_selectedImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          _selectedImage!.path,
        ));
      }

      // Convert int value to String
      request.fields['user'] = AuthService.userId.toString();
      request.fields['nickname'] = nicknameController.text;
      request.fields['studentnumber'] = studentNumberController.text;
      request.fields['major'] = majorController.text;
      request.fields['interest'] = interestController.text
          .split(",")
          .map((e) => e.trim())
          .toList()
          .join(', ');

      var response = await request.send();

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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _selectedImage = pickedImage;
    });
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: _pickImage,
              child: ClipOval(
                child: _selectedImage != null
                    ? Image.file(
                        File(_selectedImage!.path),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        widget.userData["image"],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: _pickImage,
              child: Text(
                '이미지 선택',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: nicknameController,
              decoration: InputDecoration(labelText: '닉네임'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: studentNumberController,
              decoration: InputDecoration(labelText: '학번'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: majorController,
              decoration: InputDecoration(labelText: '전공'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: interestController,
              decoration: InputDecoration(labelText: '관심사'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
