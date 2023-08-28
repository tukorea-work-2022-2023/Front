import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  final String chatroomId;

  ChatRoom({required this.chatroomId});

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
      });

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chatroom')
                  .doc(widget.chatroomId)
                  .collection('messages')
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text('');
                }

                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var message = snapshot.data!.docs[index];
                    var content = message['content'];
                    var uid = message['uid'];
                    var isMyMessage =
                        uid == FirebaseAuth.instance.currentUser?.uid;

                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      alignment: isMyMessage
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              isMyMessage ? Colors.blue : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          content,
                          style: TextStyle(
                            color: isMyMessage ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
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
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
