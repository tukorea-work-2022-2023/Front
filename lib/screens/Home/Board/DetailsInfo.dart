import 'dart:convert';
import 'dart:io';

import 'package:book/screens/Home/Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../controller/user_controller.dart';
import '../../../global/global.dart';
import 'package:http/http.dart' as http;

import '../../ItBook.dart';

class AdditionalInfo extends StatefulWidget {
  final Map<String, dynamic> bookInfo;

  AdditionalInfo({required this.bookInfo});

  @override
  _AdditionalInfoState createState() => _AdditionalInfoState();
}

class _AdditionalInfoState extends State<AdditionalInfo> {
  String _selectedStatus = '최상';
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _tagInputController = TextEditingController();

  // PickedFile? _selectedImage;
  XFile? _selectedImage;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(_selectedImage!.path);
    final extractedHtml = widget.bookInfo['description'].split('<br/>')[1];
    final dateFormat = DateFormat('EEE, d MMM yyyy HH:mm:ss Z');
    final pubDate = dateFormat.parse(widget.bookInfo['pubdate']);
    final pubYear = DateFormat('yyyy').format(pubDate);
    return Scaffold(
      appBar: AppBar(
        title: Text('책 정보 입력'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('제목', widget.bookInfo['title']),
                      _buildInfoRow('저자', widget.bookInfo['author']),
                      _buildInfoRow('출판사', widget.bookInfo['publisher']),
                      SizedBox(height: 8),
                      Text(
                        '출판일',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        pubYear, // 연도만 출력
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 4),
                      _buildInfoRow('가격', widget.bookInfo['price']),
                      SizedBox(height: 8),
                      Text(
                        '책 내용',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Html(
                        data: extractedHtml,
                        style: {
                          'body': Style(fontSize: FontSize(16.0)),
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '도서 상태',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8), // 간격 조절
                      Row(
                        children: [
                          _buildRadioButton('최상'),
                          _buildRadioButton('상'),
                          _buildRadioButton('중간'),
                          _buildRadioButton('하'),
                          _buildRadioButton('최하'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '책에 대한 설명',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _descriptionController,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '태그 입력',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _tagInputController,
                        maxLines: 1,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          _pickImage(); // Call the function to pick an image
                        },
                        child: Text('이미지 선택'),
                        // style: ElevatedButton.styleFrom(
                        //   padding: EdgeInsets.symmetric(horizontal: 160),
                        // ),
                      ),
                      SizedBox(height: 16),

                      _selectedImage != null
                          ? Image.file(
                              File(_selectedImage!.path),
                              height: 200,
                            )
                          : SizedBox(), // Display the selected image or an empty space
                    ],
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: _saveInfo,
                  child: Text('저장'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 160), // 가로 길이 조절
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = pickedImage;
      });
    }
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value ?? '',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioButton(String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: value,
          groupValue: _selectedStatus,
          onChanged: (newValue) {
            setState(() {
              _selectedStatus = newValue!;
            });
          },
        ),
        Text(
          value,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  void _saveInfo() async {
    //firebase -------
    final _authentication = FirebaseAuth.instance;
    final CollectionReference board =
        FirebaseFirestore.instance.collection('board');
    User? user = _authentication.currentUser;
    //firebase -------

    String apiUrl = '${Global.baseUrl}/home/bookPost/';

    String title = widget.bookInfo['title'];
    String author = widget.bookInfo['author'];
    String publisher = widget.bookInfo['publisher'];
    String pubdate = widget.bookInfo['pubdate'];
    final dateFormat = DateFormat('EEE, d MMM yyyy HH:mm:ss Z');
    final pubDate = dateFormat.parse(pubdate);
    final pubYear = DateFormat('yyyy').format(pubDate);
    String content = widget.bookInfo['description'];
    List<String> contentParts = content.split('<br/>');
    if (contentParts.length > 1) {
      content = contentParts[1]; // Take the content after <br/>
    } else {
      content = ''; // Set content to an empty string if no <br/> tag found
    }
    String price = widget.bookInfo['price'];
    String tag = _tagInputController.text;
    String status = _selectedStatus;
    String summary = _descriptionController.text;

    String token = "${AuthService.accessToken}";

    //new
    Map<String, String> headers = {
      "Authorization": "Bearer $token",
    };
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.headers.addAll(headers);
    // Add JSON data part
    request.fields['title'] = title;
    request.fields['writer'] = author;
    request.fields['publisher'] = publisher;
    request.fields['pub_date'] = pubYear;
    request.fields['content'] = content;
    request.fields['sell_price'] = price;
    // request.fields['tags'] = tag;
    request.fields['tags'] = json.encode([tag]);
    request.fields['state'] = status;
    request.fields['summary'] = summary;
    // Add image part if selected
    if (_selectedImage != null) {
      request.files.add(http.MultipartFile(
        'state_image',
        File(_selectedImage!.path).readAsBytes().asStream(),
        File(_selectedImage!.path).lengthSync(),
        filename:
            'state_image.jpg', // Change this to the appropriate filename and extension
        contentType: MediaType(
            'image', 'jpeg'), // Change to the appropriate image format
      ));
    }
    try {
      final response = await request.send();

      if (response.statusCode == 201) {
        //firebase -------
        if (user != null) {
          var uid = user.uid;
          // board.doc(uid).set({'uid': uid, 'title': title});
          board.add({'uid': uid, 'title': title});
        }
        //firebase end ------

        // Successfully posted the data
        print('Data posted successfully');
        Get.offAll(() => ItBook());
        // You can handle further actions here, such as showing a success message or navigating to another screen.
      } else {
        // Failed to post the data
        print('Failed to post data. Status code: ${response.statusCode}');
        final responseString = await response.stream.bytesToString();
        print('Response body: $responseString');
      }
    } catch (error) {
      print('Error while posting data: $error');
    }
  }
}
