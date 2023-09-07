import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../controller/user_controller.dart';
import '../../global/global.dart';

class AddStudyPostPage extends StatefulWidget {
  @override
  _AddStudyPostPageState createState() => _AddStudyPostPageState();
}

class _AddStudyPostPageState extends State<AddStudyPostPage> {
  final pk = Get.arguments;

  TextEditingController headcountController = TextEditingController();
  TextEditingController studyContentController = TextEditingController();
  TextEditingController studyPeriodController = TextEditingController();

  Future<void> addStudyPost() async {
    final url = Uri.parse('${Global.baseUrl}/home/study/');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer ${AuthService.accessToken}', // Replace with actual Bearer token
    };

    final body = jsonEncode({
      "book_post": pk,
      "headcount": int.parse(headcountController.text),
      "study_content": studyContentController.text,
      "study_period": int.parse(studyPeriodController.text),
      "recruit_state": "모집중",
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      // Successful post
      print('Study post added successfully');
      Get.back(result: true); // Go back to the previous page
    } else {
      // Failed to post
      print('Failed to add study post. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시물 추가'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: headcountController,
              decoration: InputDecoration(labelText: '인원 수'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: studyContentController,
              decoration: InputDecoration(labelText: '내용'),
              maxLines: null,
            ),
            TextFormField(
              controller: studyPeriodController,
              decoration: InputDecoration(labelText: '스터디 기간(주)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: addStudyPost,
              child: Text('등록'),
            ),
          ],
        ),
      ),
    );
  }
}
