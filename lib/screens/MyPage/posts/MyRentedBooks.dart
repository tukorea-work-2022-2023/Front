import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../controller/user_controller.dart';
import '../../../global/global.dart';

class MyRentedBooksPage extends StatefulWidget {
  @override
  _MyRentedBooksPageState createState() => _MyRentedBooksPageState();
}

class _MyRentedBooksPageState extends State<MyRentedBooksPage> {
  Future<Map<String, dynamic>> _fetchRentedBooks() async {
    final url = Uri.parse('${Global.baseUrl}/home/my_rent');
    final headers = {
      'Authorization': 'Bearer ${AuthService.accessToken}',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load rented books');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('대여한 도서 목록'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchRentedBooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('에러 발생: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              (snapshot.data!['rental_details'] as List).isEmpty) {
            return Center(child: Text('대여한 책이 없습니다.'));
          } else {
            final rentalDetails = snapshot.data!['rental_details'] as List;

            return ListView.builder(
              itemCount: rentalDetails.length,
              itemBuilder: (context, index) {
                final book = rentalDetails[index];

                return ListTile(
                  title: Text(book['book_title']),
                  subtitle: Text('대여 기간: ${book['rental_days']}일'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
