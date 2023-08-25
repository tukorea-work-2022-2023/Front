import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  final String chatroomId;

  ChatRoom({required this.chatroomId});
  // const ChatRoom({Key? key}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController _messageController = TextEditingController();

  void addMessage() {
    final _authentication = FirebaseAuth.instance;
    User? user = _authentication.currentUser;
    var uid = user?.uid;
    String messageText = _messageController.text;

    if (messageText.isNotEmpty) {
      CollectionReference messages = FirebaseFirestore.instance
          .collection('chatroom')
          .doc(widget.chatroomId)
          .collection('messages');

      messages.add({
        'content': messageText,
        'date': FieldValue.serverTimestamp(),
        'uid': uid,
        // 필요한 다른 필드들도 추가 가능
      });

      _messageController.clear(); // 메시지 입력 필드 비우기
    }
  }

  @override
  Widget build(BuildContext context) {
    // final _authentication = FirebaseAuth.instance;
    // User? user = _authentication.currentUser;
    // var uid = user?.uid;
    // CollectionReference messages = FirebaseFirestore.instance
    //     .collection('chatroom')
    //     .doc(widget.chatroomId)
    //     .collection('messages');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatroomId),
      ),
      body: Column(
        children: [
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: _messages.length,
          //     itemBuilder: (context, index) {
          //       return ListTile(
          //         title: Text(_messages[index]),
          //       );
          //     },
          //   ),
          // ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: addMessage,
                ),
              ],
            ),
          ),
          SizedBox(height: 30), // 일정한 간격을 두기 위한 공간 추가
        ],
      ),
    );
  }
}
