import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../global/global.dart';
import '../BoardDetail.dart';

class SearchResult extends StatefulWidget {
  final String searchText;

  const SearchResult({required this.searchText, Key? key}) : super(key: key);

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  List<dynamic> books = [];
  String _searchResult = "";

  @override
  void initState() {
    super.initState();
    _fetchSearchResults();
  }

  Future<void> _fetchSearchResults() async {
    final response = await http.get(Uri.parse(
        '${Global.baseUrl}/home/bookSearch/?search=${widget.searchText}'));

    if (response.statusCode == 200) {
      // setState(() {
      //   _searchResult = response.body;
      // });
      String decodedResponse = utf8.decode(response.bodyBytes);
      setState(() {
        books = json.decode(decodedResponse);
      });
    } else {
      // Handle error case
      print('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final _authentication = FirebaseAuth.instance;
    User? user = _authentication.currentUser;
    var loginuid = user?.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Result'),
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
    );
  }
}
