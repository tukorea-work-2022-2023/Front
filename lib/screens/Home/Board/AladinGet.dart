import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../controller/user_controller.dart';
import '../../../global/global.dart';
import 'DetailsInfo.dart';

class SearchScreen extends StatefulWidget {
  final String isbn;

  SearchScreen({required this.isbn});
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Map<String, dynamic> bookInfo = {};

  @override
  void initState() {
    super.initState();

    // Initialize _searchController with widget.isbn or an empty string if it's null
    _searchController.text = widget.isbn;
  }

  void _performSearch() {
    setState(() {
      _searchQuery = _searchController.text;
      bookInfo = {};
    });

    // Replace with your server URL
    final url = Uri.parse(
        '${Global.baseUrl}/home/barcode_bookInfo?ItemId=$_searchQuery');
    final headers = {'Authorization': 'Bearer ${AuthService.accessToken}'};

    http.get(url, headers: headers).then((response) {
      if (response.statusCode == 200) {
        // Handle the successful response here
        String decodedResponse = utf8.decode(response.bodyBytes);
        setState(() {
          bookInfo = json.decode(decodedResponse)['message'];
        });
        print(decodedResponse);
      } else {
        // Handle error or non-200 status code
        print('Error: ${response.statusCode}');
      }
    }).catchError((error) {
      print('Error: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      '등록하실 책을 검색하세요.',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 122, 122, 122),
                          width: 1.0,
                        ),
                      ),
                      suffixIcon: IconButton(
                          icon: Icon(Icons.search), onPressed: _performSearch),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            if (_searchQuery.isNotEmpty)
              GestureDetector(
                onTap: () {
                  if (bookInfo.isNotEmpty) {
                    // 페이지로 이동하는 Get.to() 메서드 사용
                    Get.to(() => AdditionalInfo(bookInfo: bookInfo));
                  }
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.network(
                          bookInfo['cover'] ?? '', // Display cover image
                          height: 150,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Icon(
                                Icons.error); // 또는 원하는 에러 처리 방식을 선택하여 구현하십시오.
                          },
                          // fit: BoxFit.cover,
                        ),
                        SizedBox(height: 16),
                        Text(
                          bookInfo['title'] ?? '', // Display title
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          bookInfo['author'] ?? '', // Display author
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Text(
                          bookInfo['publisher'] ?? '', // Display publisher
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
