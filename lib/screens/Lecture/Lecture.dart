import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../controller/user_controller.dart';
import '../../global/global.dart';

import 'package:url_launcher/url_launcher.dart';

class LecturePage extends StatefulWidget {
  @override
  _LecturePageState createState() => _LecturePageState();
}

class _LecturePageState extends State<LecturePage> {
  String selectedCategory = '언어'; // 초기 카테고리 설정
  String selectedKeyword = 'C언어'; // 초기 키워드 설정
  List<dynamic> videoList = [];

  Map<String, List<String>> keywordsByCategory = {
    '언어': ['C언어', '파이썬', '자바', 'SQL', '코틀린'],
    '프레임워크 & 라이브러리': [
      'Python Django',
      'Python Flask',
      'Vue.js',
      'Angular',
      'jQuery',
      '플러터',
      'React Native'
    ],
    '진로': ['프론트엔드', '백엔드', '앱개발', '정보보안', '보안관제'],
    '면접': ['개발자 면접', '모의해킹', 'IT 트렌드'],
  };

  Future<void> fetchVideoList(String keyword) async {
    final url =
        Uri.parse('${Global.baseUrl}/class/video_list?VideoName=$keyword');
    final headers = {
      'Authorization': 'Bearer ${AuthService.accessToken}',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        videoList = data['message'];
      });
    } else {
      // 오류 처리
      print('Failed to load video list');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchVideoList(selectedKeyword); // 초기 키워드로 비디오 리스트 불러오기
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video List'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          DropdownButtonFormField<String>(
            value: selectedCategory,
            items: ['언어', '프레임워크 & 라이브러리', '진로', '면접'].map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedCategory = newValue;
                  selectedKeyword = keywordsByCategory[newValue]![
                      0]; // 선택한 카테고리의 첫 번째 키워드로 설정
                  fetchVideoList(selectedKeyword); // 선택한 키워드로 비디오 리스트 다시 불러오기
                });
              }
            },
            decoration: InputDecoration(
              labelText: '카테고리', // 드롭다운 레이블 텍스트
              labelStyle: TextStyle(color: Colors.blue), // 레이블 텍스트 스타일
              border: OutlineInputBorder(), // 외곽선 스타일
            ),
          ),
          SizedBox(
            height: 15,
          ),
          DropdownButtonFormField<String>(
            value: selectedKeyword,
            items: keywordsByCategory[selectedCategory]!.map((String keyword) {
              return DropdownMenuItem<String>(
                value: keyword,
                child: Text(keyword),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedKeyword = newValue;
                  fetchVideoList(newValue); // 선택한 키워드로 비디오 리스트 다시 불러오기
                });
              }
            },
            decoration: InputDecoration(
              labelText: '키워드', // 드롭다운 레이블 텍스트
              labelStyle: TextStyle(color: Colors.blue), // 레이블 텍스트 스타일
              border: OutlineInputBorder(), // 외곽선 스타일
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: videoList.length,
              itemBuilder: (context, index) {
                final video = videoList[index];
                final title = video[0];
                final youtubeLink = video[1];
                final viewCount = video[2];

                String youtubeVideoUrl = youtubeLink;
                int startIndex =
                    youtubeVideoUrl.indexOf('v=') + 2; // "v=" 다음 문자부터 시작
                int endIndex = youtubeVideoUrl.indexOf('&'); // '&' 문자 이전까지

                String videoId =
                    youtubeVideoUrl.substring(startIndex, endIndex);

                final youtubeThumbnailUrl =
                    'https://img.youtube.com/vi/$videoId/default.jpg';

                return InkWell(
                  onTap: () async {
                    if (await canLaunch(youtubeLink)) {
                      await launch(youtubeLink);
                    } else {
                      print('Cannot launch $youtubeLink');
                    }
                  },
                  child: Card(
                    elevation: 2, // 그림자 효과
                    margin: EdgeInsets.symmetric(
                        vertical: 6, horizontal: 16), // 여백 조절
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          youtubeThumbnailUrl,
                          height: 130, // 이미지 높이
                          width: double.infinity, // 이미지 너비 최대화
                          fit: BoxFit.cover, // 이미지 크기 조절
                        ),
                        Padding(
                          padding: EdgeInsets.all(10), // 내부 패딩 추가
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontSize: 14, // 제목 폰트 크기
                                  fontWeight: FontWeight.bold, // 제목 굵게 표시
                                ),
                              ),
                              SizedBox(height: 8), // 공간 추가
                              Text(
                                '조회수: $viewCount',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(
                                      255, 111, 110, 110), // 조회수 텍스트 색상 설정
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
