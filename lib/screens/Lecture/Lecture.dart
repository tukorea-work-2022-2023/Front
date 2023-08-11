import 'package:flutter/material.dart';

import '../../constant/constant.dart';

class LecturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(appName), // 이 페이지에 맞는 app bar 제목을 설정합니다.
      ),
      body: Center(
        child: Text('강의 페이지'),
      ),
    );
  }
}
