import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../controller/user_controller.dart';
import '../../global/global.dart';
import 'AddStudy.dart';

class StudyPage extends StatefulWidget {
  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  List<dynamic> studyPosts = []; // Store the fetched study posts here
  void initState() {
    super.initState();
    _fetchStudyPosts();
  }

  Future<void> _fetchStudyPosts() async {
    final String baseUrl = '${Global.baseUrl}/home/study/';

    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {'Authorization': 'Bearer ${AuthService.accessToken}'},
      );

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final parsedData = json.decode(responseBody);
        setState(() {
          studyPosts = parsedData; // Store the fetched study posts in the list
        });
      } else {
        print(
            'Error fetching study posts. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching study posts: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('스터디 페이지'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Get.to(() => AddStudyPostPage());
            },
            child: Text('스터디 모집 게시물 추가'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: studyPosts.length,
              itemBuilder: (context, index) {
                final post = studyPosts[index];
                final studyContent = post['study_content'];
                final recruitState = post['recruit_state'];

                return ListTile(
                  title: Text(studyContent),
                  subtitle: Text(recruitState),
                  // You can customize the ListTile further if needed
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
