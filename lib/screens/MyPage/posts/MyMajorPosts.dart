import 'dart:convert';

import 'package:book/screens/Major/MajorBoard/MajorChoice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http; // Add this import
import 'package:intl/intl.dart';

import '../../../constant/constant.dart';
import '../../../controller/user_controller.dart';
import '../../../global/global.dart';
import '../../Major/MajorDetail.dart';

class MyMajorPosts extends StatefulWidget {
  @override
  _MyMajorPostsState createState() => _MyMajorPostsState();
}

class _MyMajorPostsState extends State<MyMajorPosts> {
  List<dynamic> books = [];
  String selectedCategory = '전체';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('${Global.baseUrl}/major/majorPost/'),
      headers: {
        'Authorization': 'Bearer ${AuthService.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      String decodedResponse = utf8.decode(response.bodyBytes);
      setState(() {
        books = json.decode(decodedResponse);
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final _authentication = FirebaseAuth.instance;
    User? user = _authentication.currentUser;
    var loginuid = user?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('major')
            .orderBy('createdAt')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              var document = snapshot.data?.docs[index];
              var title = document!['title'];
              var uid = document['uid'];

              if (uid != loginuid) {
                return Container();
              }

              var createdAtTimestamp = document['createdAt'];
              var createdAtDateTime = createdAtTimestamp.toDate();

              var dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
              var createdAtString = dateFormat.format(createdAtDateTime);

              bool isRenting = books[index]['rent_state'] == '대여중';

              print(document.id);
              return Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: InkWell(
                  onTap: () {
                    Map<String, dynamic> bookData = {
                      'book': books[index],
                      'title': document['title'],
                      'uid': document['uid'],
                      'documentId': document.id,
                    };
                    Get.to(() => MajorDetail(bookData: bookData));
                  },
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              '${books[index]['state_image']}',
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
                                    books[index]['title'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 18),
                                  Text(
                                    books[index]['writer'],
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
                      if (isRenting)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black54,
                            child: Center(
                              child: Text(
                                '대여중',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => MajorChoice());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
