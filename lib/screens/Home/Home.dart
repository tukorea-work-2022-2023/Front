import 'dart:convert';

import 'package:book/screens/Home/Search/Search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constant/constant.dart';
import '../../controller/user_controller.dart';
import '../../global/global.dart';
import 'Board/ChoicePage.dart';
import 'BoardDetail.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> books = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('${Global.baseUrl}/home/bookPost/'),
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
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => Search());
              },
              icon: Icon(Icons.search)),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('board')
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
              print('도서등록된 아이디' + uid);
              print('로그인한 사람 아이디' + loginuid!);

              if (uid == loginuid) {
                return Container();
              }

              var createdAtTimestamp = document['createdAt'];
              var createdAtDateTime = createdAtTimestamp.toDate();

              var dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
              var createdAtString = dateFormat.format(createdAtDateTime);
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
                    Get.to(() => BoardDetail(bookData: bookData));
                  },
                  child: Padding(
                    padding: EdgeInsets.all(6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          books[index]['state_image'],
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
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => ChoicePage());
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
