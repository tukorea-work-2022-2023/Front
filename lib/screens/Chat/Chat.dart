import 'package:book/screens/Chat/Chatroom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:random_color/random_color.dart';

import '../../constant/constant.dart';

class ChatPage extends StatelessWidget {
  Future<String> getUserName(String uid) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final userData = userDoc.data() as Map<String, dynamic>;
    return userData['name'];
  }

  Future<Map<String, dynamic>> getLastMessageInfo(String chatroomId) async {
    final lastMessageSnapshot = await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(chatroomId)
        .collection('messages')
        .orderBy('date', descending: true)
        .limit(1)
        .get();

    if (lastMessageSnapshot.size > 0) {
      final lastMessageDoc = lastMessageSnapshot.docs[0];
      final lastMessageData = lastMessageDoc.data() as Map<String, dynamic>;
      final lastMessageDate = lastMessageData['date'] as Timestamp;
      final lastMessageContent = lastMessageData['content'] as String;

      return {
        'date': lastMessageDate,
        'content': lastMessageContent,
      };
    } else {
      return {
        'date': Timestamp(0, 0), // Default value for no messages
        'content': 'No messages yet.',
      };
    }
  }

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

          return ListView.separated(
            itemCount: chatrooms.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              final chatroomData =
                  chatrooms[index].data() as Map<String, dynamic>;
              final chatroomId = chatrooms[index].id;
              final product = chatroomData['product'];
              final date = chatroomData['date'].toDate();
              final who = List.from(chatroomData['who']);

              var currentUserUid = FirebaseAuth.instance.currentUser?.uid;

              var otherParticipants =
                  who.where((uid) => uid != currentUserUid).toList();

              return FutureBuilder<List<String>>(
                future: Future.wait(
                    otherParticipants.map((uid) => getUserName(uid))),
                builder: (context, nameSnapshot) {
                  if (nameSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (nameSnapshot.hasError) {
                    return Center(
                      child: Text('Error: ${nameSnapshot.error}'),
                    );
                  }

                  final participantNames = nameSnapshot.data;

                  return FutureBuilder<Map<String, dynamic>>(
                    future: getLastMessageInfo(chatroomId),
                    builder: (context, lastMessageInfoSnapshot) {
                      if (lastMessageInfoSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (lastMessageInfoSnapshot.hasError) {
                        return Center(
                          child:
                              Text('Error: ${lastMessageInfoSnapshot.error}'),
                        );
                      }

                      final lastMessageInfo = lastMessageInfoSnapshot.data;

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: RandomColor().randomColor(),
                          child: Icon(Icons.person),
                        ),
                        title: Text(
                          '${participantNames!.join(', ')}',
                          style: TextStyle(
                            fontSize: 22, // 원하는 크기로 수정
                            fontWeight: FontWeight.bold, // 볼드 스타일 적용
                          ),
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.only(top: 4), // 위쪽 간격 추가
                          child: Text(
                            '${lastMessageInfo!['content']}',
                            style: TextStyle(
                              fontSize: 16, // 원하는 크기로 수정
                            ),
                          ),
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(height: 10), // 위쪽 간격 추가
                            TimeAgoWidget(
                                dateTime: lastMessageInfo!['date'].toDate()),
                          ],
                        ),
                        onTap: () {
                          Get.to(() => ChatRoom(chatroomId: chatroomId));
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class TimeAgoWidget extends StatelessWidget {
  final DateTime dateTime;

  TimeAgoWidget({required this.dateTime});

  String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays >= 1) {
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } else if (difference.inHours >= 1) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}분 전';
    } else {
      return '방금 전';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(getTimeAgo(dateTime));
  }
}
