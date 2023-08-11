import 'package:flutter/material.dart';

import '../../constant/constant.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(appName),
      ),
      body: Center(
        child: Text('채팅 페이지'),
      ),
    );
  }
}
