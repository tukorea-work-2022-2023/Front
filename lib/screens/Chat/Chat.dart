import 'package:book/screens/Chat/Chatroom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/constant.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _authentication = FirebaseAuth.instance;
    User? user = _authentication.currentUser;
    var myuid = user?.uid;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(appName),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('chatroom')
            .where('who', arrayContains: myuid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No chatrooms.'),
            );
          }

          final chatrooms = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chatrooms.length,
            itemBuilder: (context, index) {
              final chatroomData =
                  chatrooms[index].data() as Map<String, dynamic>;
              final chatroomId = chatrooms[index].id;
              final product = chatroomData['product'];
              final date = chatroomData['date']
                  .toDate(); // Convert Firestore Timestamp to DateTime
              final who = List.from(chatroomData['who']);

              return ListTile(
                title: Text(product),
                subtitle: Text(
                    'Date: $date\n참가자들: ${who.join(', ')}\n방번호$chatroomId'),
                onTap: () {
                  Get.to(ChatRoom(chatroomId: chatroomId));
                  // Handle chatroom item tap
                  // You can navigate to the chat screen or perform any other action
                },
              );
            },
          );
        },
      ),
    );
  }
}
