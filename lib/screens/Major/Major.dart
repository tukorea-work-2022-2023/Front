import 'package:flutter/material.dart';

import '../../constant/constant.dart';

class MajorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appName),
        centerTitle: false,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
        ],
      ),
      body: Center(
        child: Text('전공 페이지'),
      ),
    );
  }
}
