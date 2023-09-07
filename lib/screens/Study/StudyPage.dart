import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../controller/user_controller.dart';
import '../../global/global.dart';
import 'AddStudy.dart';
import 'StudyDetail.dart';

class StudyPage extends StatefulWidget {
  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  final pk = Get.arguments;

  List<dynamic> studyPosts = []; // Store the fetched study posts here
  void initState() {
    super.initState();
    _fetchStudyPosts();
  }

  Future<void> _fetchStudyPosts() async {
    final String baseUrl = '${Global.baseUrl}/home/study/list/$pk/';

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
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final result =
                  await Get.to(() => AddStudyPostPage(), arguments: pk);
              if (result == true) {
                // AddStudyPostPage에서 true를 반환하면 데이터를 다시 불러옴
                await _fetchStudyPosts();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
            itemCount: studyPosts.length,
            itemBuilder: (context, index) {
              final post = studyPosts[index];

              return InkWell(
                onTap: () async {
                  final result = await Get.to(() => StudyDetailPage(
                        studyPost: post,
                      ));
                  if (result == true) {
                    // AddStudyPostPage에서 true를 반환하면 데이터를 다시 불러옴
                    await _fetchStudyPosts();
                  }
                },
                child: ListTile(
                  title: Text(post['study_content']),
                  subtitle: Text(post['recruit_state']),
                  // You can customize the ListTile further if needed
                ),
              );
            },
          )),
        ],
      ),
    );
  }
}
