import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Chat/Chatroom.dart';
import '../Study/StudyPage.dart';

class BoardDetail extends StatefulWidget {
  // final dynamic book; // Book details passed from HomePage

  // BoardDetail({required this.book});

  final Map<String, dynamic> bookData;

  BoardDetail({required this.bookData});

  @override
  State<BoardDetail> createState() => _BoardDetailState();
}

class _BoardDetailState extends State<BoardDetail> {
  late String title;
  late String uid;
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

  @override
  void initState() {
    super.initState();
    uid = widget.bookData['uid'];
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

    proImg = pro['image'];
    proNick = pro['nickname'];
    proNum = pro['studentnumber'];
  }

  @override
  Widget build(BuildContext context) {
    print('detail : ' + uid);
    return Scaffold(
      appBar: AppBar(
        title: Text('상세보기'),
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
          GestureDetector(
            onTap: () async {
              setState(() {
                _isLiked = !_isLiked;
              });
            },
            child: Icon(
              _isLiked ? Icons.favorite : Icons.favorite_border,
              color: _isLiked ? Colors.blue : null,
              size: 27,
            ),
          ),
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
                    Get.to(() => StudyPage());
                  },
                  child: Text('스터디 참여'),
                ),
                SizedBox(width: 16),
                if (!isSameUser)
                  ElevatedButton(
                    onPressed: () async {
                      if (user != null) {
                        var myuid = user.uid;
                        print('로그인한사람 : ' + myuid);
                        print('게시글 주인 : ' + uid);

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
                          print(chatdata);
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
