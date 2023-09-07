import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/user_controller.dart';
import '../../global/global.dart';
import 'package:http/http.dart' as http;

import 'StudyEdit.dart';

class StudyDetailPage extends StatelessWidget {
  final dynamic studyPost;

  StudyDetailPage({required this.studyPost});

  @override
  Widget build(BuildContext context) {
    final studyContent = studyPost['study_content'];
    final recruitState = studyPost['recruit_state'];
    final headCount = studyPost['headcount'];
    final studyPeriod = studyPost['study_period'];

    final nickname = studyPost['profile']['nickname'];
    final studentNumber = studyPost['profile']['studentnumber'];
    final major = studyPost['profile']['major'];
    final profileImage = studyPost['profile']['image'];

    final pk = studyPost['pk'];
    // 수정 로직을 수행하는 함수
    void handleEdit() {
      // 수정 로직을 여기에 추가
      Get.to(StudyEditPage(studyPost: studyPost));
    }

    // 삭제 로직을 수행하는 함수
    Future<void> handleDelete() async {
      final studyPostPk = studyPost['pk']; // 게시물의 PK 가져오기
      final accessToken = "${AuthService.accessToken}"; // 여기에 액세스 토큰 값을 넣어주세요

      final url = Uri.parse('${Global.baseUrl}/home/study/$studyPostPk/');

      final response = await http.delete(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 204) {
        // 삭제 성공
        // 삭제 후 필요한 작업을 수행하세요
        Get.back(result: true); // Go back to the previous page
      } else {
        // 삭제 실패
        throw Exception('게시물 삭제에 실패했습니다.');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('게시물 상세 정보'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                handleEdit();
              } else if (value == 'delete') {
                handleDelete();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'edit',
                  child: Text('수정'),
                ),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Text('삭제'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Card(
        elevation: 4, // Shadow effect
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        margin: EdgeInsets.all(16), // Margin around the card
        child: Padding(
          padding: EdgeInsets.all(16), // Padding around text
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Left-align text
            children: [
              SizedBox(height: 10),
              Text(
                studyContent,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold), // Larger and bold text
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '모집 상태:',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '$recruitState',
                    style: TextStyle(
                      fontSize: 16,
                      color: recruitState == '모집중' ? Colors.green : Colors.blue,
                      fontWeight: FontWeight.bold, // Bold text
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '인원:',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '$headCount 명',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '기간:',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '$studyPeriod 주',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 30), // Increased spacing
              Divider(
                // Add a horizontal line
                color: Color.fromARGB(
                    255, 189, 189, 189), // Customize the color of the divider
                thickness: 1, // Customize the thickness of the divider
              ),

              SizedBox(height: 17), // Increased spacing
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        NetworkImage(profileImage), // Profile image
                    radius: 24, // Adjust the size of the profile image
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nickname,
                        style: TextStyle(
                          fontSize: 18, // Larger font size
                          fontWeight: FontWeight.bold, // Bold text
                        ),
                      ),
                      Text(
                        '$studentNumber 학번',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        major,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
