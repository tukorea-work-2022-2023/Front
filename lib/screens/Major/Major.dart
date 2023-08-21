import 'dart:convert';

import 'package:book/screens/Major/MajorBoard/MajorChoice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http; // Add this import

import '../../constant/constant.dart';
import '../../controller/user_controller.dart';
import '../../global/global.dart';
import 'MajorDetail.dart';

class MajorPage extends StatefulWidget {
  @override
  _MajorPageState createState() => _MajorPageState();
}

class _MajorPageState extends State<MajorPage> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: selectedCategory,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                }
              },
              items: ['전체', '컴퓨터공학', '소프트웨어 공학', '게임공학', 'IT경영']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                if (selectedCategory == '전체' ||
                    books[index]['category'] == selectedCategory) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 16.0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => MajorDetail(
                              book: books[index],
                            ));
                      },
                      child: Card(
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Row(
                            children: [
                              Image.network(
                                books[index]['state_image'],
                                width: 70,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      books[index]['title'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      books[index]['writer'],
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ),
        ],
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
