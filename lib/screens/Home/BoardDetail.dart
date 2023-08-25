import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                    '$Title',
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
              // UserController userController = UserController();
              // String token = await userController.getToken();
              // final response = await http.get(
              //   Uri.parse(
              //       'http://192.168.0.4:8000/home/like/${widget.board.id}/'),
              //   headers: {'Authorization': 'token $token'},
              // );
              // String message = '';
              // print(response.body);

              // if (response.statusCode == 200 &&
              //     response.body == {"status": "ok"}) {
              //   message = '관심목록에 추가됐어요.';
              // } else {
              //   message = '관심목록에서 제거됐어요.';
              // }
              // final snackBar = SnackBar(
              //   content: Text(message),
              //   duration: const Duration(seconds: 1),
              // );
              // ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                ElevatedButton(
                  onPressed: () {
                    // Get.to(() => ChatScreen(
                    //       widget.board,
                    //     ));
                    if (user != null) {
                      var myuid = user.uid;
                      print('로그인한사람 : ' + myuid);
                      print('게시글 주인 : ' + uid);
                      var chatdata = {
                        'product': title,
                        'date': DateTime.now(),
                        'who': [myuid, uid]
                      };
                      print(chatdata);
                      chatroom.add(chatdata);
                      //저 두 uid가 있는 채팅방은 채팅방으로 이동시켜야 함. 또 생성하면 안 됨
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
