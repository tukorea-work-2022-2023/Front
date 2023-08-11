import 'package:flutter/material.dart';

import 'Chat/Chat.dart';
import 'Home/Home.dart';
import 'Lecture/Lecture.dart';
import 'Major/Major.dart';
import 'MyPage/MyPage.dart';

class ItBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNavigationWidget(),
    );
  }
}

class BottomNavigationWidget extends StatefulWidget {
  @override
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  int _currentIndex = 2;

  final List<Widget> _pages = [
    MajorPage(),
    LecturePage(),
    HomePage(),
    ChatPage(),
    MyPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('IT-Book'),
      // ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: '전공',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: '강의',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            label: '채팅',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '마이페이지',
          ),
        ],
      ),
    );
  }
}
