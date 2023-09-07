import 'dart:convert';

import 'package:book/screens/Home/Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

import '../../controller/user_controller.dart';
import '../../global/global.dart';
import '../Chat/Chatroom.dart';
import '../ItBook.dart';
import '../Study/StudyPage.dart';

class BoardDetail extends StatefulWidget {
  final Map<String, dynamic> bookData;

  BoardDetail({required this.bookData});

  @override
  State<BoardDetail> createState() => _BoardDetailState();
}

class _BoardDetailState extends State<BoardDetail> {
  String _selectedRentState = '대여 가능'; // 기본값 설정
  late String title;
  late String uid;
  late String documentId;
  late String summary;
  late String stateImage;
  late String proImg;
  late String proNick;
  late String proNum;

  late String writer;
  late String publisher;
  late String content;
  late int sellPrice;
  late String pubDate;
  // late String tags;
  late String createdAt;
  late int hits;
  late int pk;

  @override
  void initState() {
    super.initState();
    uid = widget.bookData['uid'];
    documentId = widget.bookData['documentId'];

    var book = widget.bookData['book'];
    var pro = widget.bookData['book']['profile'];

    title = book['title'];
    summary = book['summary'];
    stateImage = book['state_image'];

    writer = book['writer'];
    publisher = book['publisher'];
    content = book['content'];
    sellPrice = book['sell_price'];
    pubDate = book['pub_date'];
    // tags = book['tags'];
    createdAt = book['created_at'];
    hits = book['hits'];
    pk = book['pk'];

    proImg = pro['image'];
    proNick = pro['nickname'];
    proNum = pro['studentnumber'];
  }

  Future<void> _updateRentState() async {
    final url = Uri.parse('${Global.baseUrl}/home/bookPost/$pk/');
    final headers = {
      'Authorization': 'Bearer ${AuthService.accessToken}',
      'Content-Type': 'application/json',
    };
    final Map<String, String> body = {'rent_state': _selectedRentState};

    try {
      final response = await http.patch(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        // 수정이 성공적으로 완료되었을 때의 동작을 구현해주세요.
        print('수정 성공');
        Get.offAll(() => ItBook());
      } else {
        print('수정 실패');
        String decodedResponse = utf8.decode(response.bodyBytes);
        print(decodedResponse);
        // 수정 실패 시의 동작을 구현해주세요.
      }
    } catch (e) {
      print('수정 실패');
      // 예외 처리를 구현해주세요.
    }
  }

  //수정 창
  Future<void> _showEditDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('대여 상태 수정'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RadioListTile<String>(
                    title: Text('대여 가능'),
                    value: '대여 가능',
                    groupValue: _selectedRentState,
                    onChanged: (value) {
                      setState(() {
                        _selectedRentState = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('대여중'),
                    value: '대여중',
                    groupValue: _selectedRentState,
                    onChanged: (value) {
                      setState(() {
                        _selectedRentState = value!;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 취소 버튼
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                _updateRentState(); // 수정 버튼
              },
              child: Text('수정'),
            ),
          ],
        );
      },
    );
  }

  //삭제 창
  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    // 삭제 확인 알림창을 표시하는 함수
    bool deleteConfirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('게시물 삭제'),
          content: Text('게시물을 삭제하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // 취소 버튼을 누르면 false 반환
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // 삭제 버튼을 누르면 true 반환
              },
              child: Text('삭제'),
            ),
          ],
        );
      },
    );

    if (deleteConfirmed) {
      // 사용자가 삭제를 확인하면
      final String apiUrl = '${Global.baseUrl}/home/bookPost/$pk/';
      final String token = '${AuthService.accessToken}'; // 여기에 토큰을 넣어주세요

      try {
        final response = await http.delete(
          Uri.parse(apiUrl),
          headers: {'Authorization': 'Bearer $token'}, // 토큰을 헤더에 추가
        );

        if (response.statusCode == 204) {
          final CollectionReference boardCollection =
              FirebaseFirestore.instance.collection('board');

          await boardCollection.doc(documentId).delete();
          // 성공적으로 삭제되었을 경우
          // 필요한 처리를 수행하세요.
          print('delete success');

          // Navigator.pop(context); // 상세 화면을 닫음
          Get.offAll(() => ItBook());
        } else {
          // 삭제 실패
          // 에러 처리를 수행하세요.
        }
      } catch (e) {
        // 네트워크 에러 또는 기타 예외 처리
      }
    }
  }

  //대여창
  Future<void> _showRentDialog(BuildContext context) async {
    String selectedRentalDays = '7'; // Default value
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('대여 기간 선택'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RadioListTile<String>(
                    title: Text('7일'),
                    value: '7',
                    groupValue: selectedRentalDays,
                    onChanged: (value) {
                      setState(() {
                        selectedRentalDays = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('15일'),
                    value: '15',
                    groupValue: selectedRentalDays,
                    onChanged: (value) {
                      setState(() {
                        selectedRentalDays = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('30일'),
                    value: '30',
                    groupValue: selectedRentalDays,
                    onChanged: (value) {
                      setState(() {
                        selectedRentalDays = value!;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 취소 버튼
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                _performRental(selectedRentalDays); // 대여 버튼
              },
              child: Text('대여'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performRental(String rentalDays) async {
    // rentalDays를 int로 변환
    int? rentalDaysInt = int.tryParse(rentalDays);

    if (rentalDaysInt == null) {
      // rentalDays를 정수로 변환할 수 없는 경우 에러 처리
      print('Invalid rental days: $rentalDays');
      return;
    }

    final url = Uri.parse('${Global.baseUrl}/home/create_rental/$pk/rent/');
    final headers = {
      'Authorization': 'Bearer ${AuthService.accessToken}',
      'Content-Type': 'application/json',
    };
    final Map<String, dynamic> body = {'rental_days': rentalDaysInt};

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        // 대여 성공 시의 동작을 구현해주세요.
        print('대여 성공');
        Navigator.pop(context); // Close the dialog
        Get.offAll(() => ItBook());
      } else {
        print('대여 실패');

        // 대여 실패 시의 동작
      }
    } catch (e) {
      // 네트워크 에러 또는 기타 예외 처리
    }
  }

  @override
  Widget build(BuildContext context) {
    final _authentication = FirebaseAuth.instance;
    User? user = _authentication.currentUser;
    var myuid = user?.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text('상세보기'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // 사용자가 선택한 메뉴에 따른 동작을 수행하는 코드를 여기에 추가하세요.
              if (value == '수정') {
                _showEditDialog(context);
                // 수정 동작 실행
              } else if (value == '삭제') {
                _showDeleteConfirmationDialog(context);
              } else if (value == '대여') {
                _showRentDialog(context);
                // 대여 동작 실행
              }
            },
            itemBuilder: (BuildContext context) {
              List<PopupMenuEntry<String>> menuItems = [];

              // Check if the current user is the same as the author of the post

              bool isSameUser = myuid == uid;

              // Add the '수정' and '삭제' menu items for the author and other users
              if (isSameUser) {
                menuItems.add(
                  PopupMenuItem<String>(
                    value: '수정',
                    child: Text('수정'),
                  ),
                );
                menuItems.add(
                  PopupMenuItem<String>(
                    value: '삭제',
                    child: Text('삭제'),
                  ),
                );
              }

              // Add the '대여' menu item only for other users
              if (!isSameUser) {
                menuItems.add(
                  PopupMenuItem<String>(
                    value: '대여',
                    child: Text('대여'),
                  ),
                );
              }

              return menuItems;
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(stateImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (proImg != null)
                        CircleAvatar(
                          backgroundImage: NetworkImage(proImg),
                          radius: 24,
                        ),
                      if (proImg == null)
                        CircleAvatar(
                          // 여기에 기본 아이콘 이미지 넣기
                          radius: 24,
                        ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$proNick',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '$proNum학번',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Divider(),
                  SizedBox(height: 15),
                  Text(
                    '$summary',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 15),
                  Divider(),
                  SizedBox(height: 10),
                  Text(
                    '책 소개',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '$title',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '저자 : $writer',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '출판사 : $publisher',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '내용 : $content',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '원가 : $sellPrice원',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '출간일 : $pubDate년',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  // Text(
                  //   '태그 : $tags',
                  //   style: TextStyle(fontSize: 16),
                  // ),
                  Divider(),
                  Text(
                    '등록일 : $createdAt',
                    style: TextStyle(fontSize: 10),
                  ),
                  SizedBox(height: 7),
                  Text(
                    '조회수 : $hits',
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomBarWidget(),
    );
  }

  bool _isLiked = false;
  void _toggleLike() async {
    setState(() {
      _isLiked = !_isLiked;
    });

    String accessToken = "${AuthService.accessToken}";
    String likeUrl = "${Global.baseUrl}/home/like/$pk/";

    Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken',
    };

    try {
      final response = await http.get(Uri.parse(likeUrl), headers: headers);
      String decodedResponse = utf8.decode(response.bodyBytes);
      print(decodedResponse);
      if (response.statusCode == 200) {
        // Successful request, do any additional handling if needed
        print('success');
      } else {
        // Handle error response
        print('Request failed with status: ${response.statusCode}');
        // Revert the like status if the request fails
        setState(() {
          _isLiked = !_isLiked;
        });
      }
    } catch (error) {
      // Handle exceptions
      print('Error sending request: $error');
      // Revert the like status if there's an exception
      setState(() {
        _isLiked = !_isLiked;
      });
    }
  }

  Widget _bottomBarWidget() {
    //firebase -------
    final _authentication = FirebaseAuth.instance;
    User? user = _authentication.currentUser;
    final CollectionReference chatroom =
        FirebaseFirestore.instance.collection('chatroom');

    //firebase -------

    bool isSameUser = user?.uid == uid; // Check if myuid and uid are the same
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
      height: 90,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // if (!isSameUser)
          GestureDetector(
            onTap:
                _toggleLike, // Call the method to toggle like and send the request
            child: Icon(
              _isLiked ? Icons.favorite : Icons.favorite_border,
              color: _isLiked ? Colors.blue : null,
              size: 27,
            ),
          ),
          // if (!isSameUser)
          Container(
            margin: const EdgeInsets.only(left: 15, right: 10),
            height: 40,
            width: 1,
            color: Colors.grey.withOpacity(0.3),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => StudyPage(), arguments: pk);
                  },
                  child: Text('스터디 참여'),
                ),
                SizedBox(width: 16),
                // if (!isSameUser)
                ElevatedButton(
                  onPressed: () async {
                    if (user != null) {
                      var myuid = user.uid;

                      if (myuid == uid) {
                        // Show a dialog if the user is trying to chat with themselves
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('알림'),
                              content: Text('본인의 게시물에는 채팅할 수 없습니다.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('확인'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // Create a consistent user list for searching chat rooms
                        var userPair = [myuid, uid];
                        userPair.sort(); // Sort the list

                        // Check if a chat room between the users already exists
                        final querySnapshot = await FirebaseFirestore.instance
                            .collection('chatroom')
                            .where('who', isEqualTo: userPair)
                            .get();

                        if (querySnapshot.docs.isNotEmpty) {
                          // Existing chat room found
                          var chatroomId = querySnapshot.docs.first.id;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChatRoom(chatroomId: chatroomId),
                            ),
                          );
                        } else {
                          // Create a new chat room
                          var chatdata = {
                            'product': title,
                            'date': DateTime.now(),
                            'who': userPair,
                          };

                          var newChatRef = await chatroom.add(chatdata);
                          var newChatroomId = newChatRef.id;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChatRoom(chatroomId: newChatroomId),
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: Text('채팅하기'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
