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
  List<dynamic> books = []; // List to hold fetched books
  String selectedCategory = '전체'; // Default selected category is 'All'

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('${Global.baseUrl}/major/majorPost/'),
      headers: {
        'Authorization': 'Bearer ${AuthService.accessToken}'
      }, // Add your bearer token
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
        title: Text(appName),
        centerTitle: false,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
        ],
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: selectedCategory,
            onChanged: (String? newValue) {
              // Change the parameter type to String?
              if (newValue != null) {
                // Check for null before using the value
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
          Expanded(
            child: ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                if (selectedCategory == '전체' ||
                    books[index]['category'] == selectedCategory) {
                  return ListTile(
                    title: Text(books[index]['title']),
                    subtitle: Text(books[index]['writer']),
                    leading: Image.network(
                      books[index]['state_image'],
                      width: 70, // Adjust the width as needed
                      height: 120, // Adjust the height as needed
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      Get.to(() => MajorDetail(
                          book: books[index])); // Pass the book details
                    },
                  );
                }
                return SizedBox
                    .shrink(); // Hide items that don't match the selected category
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
