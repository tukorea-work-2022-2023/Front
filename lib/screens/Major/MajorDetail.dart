import 'package:flutter/material.dart';

class MajorDetail extends StatefulWidget {
  final dynamic book; // Book details passed from HomePage

  MajorDetail({required this.book});

  @override
  State<MajorDetail> createState() => _MajorDetailState();
}

class _MajorDetailState extends State<MajorDetail> {
  @override
  Widget build(BuildContext context) {
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
                  image: NetworkImage(widget.book['state_image']),
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
                      if (widget.book['profile']['image'] != null)
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(widget.book['profile']['image']),
                          radius: 24,
                        ),
                      if (widget.book['profile']['image'] == null)
                        CircleAvatar(
                          // 여기에 기본 아이콘 이미지 넣기
                          radius: 24,
                        ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.book['profile']['nickname']}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${widget.book['profile']['studentnumber']}학번',
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
                    widget.book['summary'],
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
                    widget.book['title'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '저자 : ${widget.book['writer']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '출판사 : ${widget.book['publisher']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '내용 : ${widget.book['content']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '원가 : ${widget.book['sell_price']}원',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '출간일 : ${widget.book['pub_date']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '태그 : ${widget.book['tags']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Divider(),
                  Text(
                    '등록일 : ${widget.book['created_at']}',
                    style: TextStyle(fontSize: 10),
                  ),
                  SizedBox(height: 7),
                  Text(
                    '조회수 : ${widget.book['hits']}',
                    style: TextStyle(fontSize: 10),
                  ),
                  // Divider(),
                  // Text(
                  //   '학과 : ${widget.book['category']}',
                  //   style: TextStyle(fontSize: 10),
                  // ),
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
                  onPressed: () {},
                  child: Text('스터디 참여'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    // Get.to(() => ChatScreen(
                    //       widget.board,
                    //     ));
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
