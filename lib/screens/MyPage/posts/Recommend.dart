import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import '../../../controller/user_controller.dart';
import '../../../global/global.dart';
import '../../Home/BoardDetail.dart';

class Recommend extends StatefulWidget {
  @override
  _RecommendState createState() => _RecommendState();
}

class _RecommendState extends State<Recommend> {
  List<dynamic> data = [];

  @override
  void initState() {
    super.initState();
    fetchData().then((result) {
      setState(() {
        data = result;
      });
    });
  }

  Future<List<dynamic>> fetchData() async {
    final response = await http.get(
      Uri.parse('${Global.baseUrl}/setting/recommend'),
      headers: {
        'Authorization': 'Bearer ${AuthService.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> parsedData =
          json.decode(utf8.decode(response.bodyBytes));
      print(parsedData);

      return parsedData;
    } else {
      throw Exception('Failed to load data');
    }
  }

  // 게시물 상세 페이지로 이동하는 함수
  // void navigateToDetailPage(Map<String, dynamic> item) {
  //   // 상세 페이지로 이동하는 코드 추가
  //   // 예를 들어, Navigator.push를 사용하여 상세 페이지로 이동할 수 있습니다.
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => DetailPage(item: item), // 상세 페이지 위젯을 만들어야 합니다.
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('추천 게시물'),
        ),
        body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            // var document = snapshot.data?.docs[index];
            // var title = document!['title'];
            // var uid = document['uid'];

            // var createdAtTimestamp = document['createdAt'];
            // var createdAtDateTime = createdAtTimestamp.toDate();

            var dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
            // var createdAtString = dateFormat.format(createdAtDateTime);

            return Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: InkWell(
                onTap: () {
                  Map<String, dynamic> bookData = {
                    'book': data[index],
                    // 'title': document['title'],
                    // 'uid': document['uid'],
                    // 'documentId': document.id,
                  };
                  Get.to(() => BoardDetail(bookData: bookData));
                },
                child: Padding(
                  padding: EdgeInsets.all(6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        'http://192.168.161.103:8000' +
                            data[index]['state_image'],
                        width: 60,
                        height: 110,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 18),
                            Text(
                              data[index]['title'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 18),
                            Text(
                              data[index]['writer'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(255, 118, 118, 118),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}
