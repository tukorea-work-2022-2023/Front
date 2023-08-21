import 'package:flutter/material.dart';

import '../../constant/constant.dart';

class LecturePage extends StatefulWidget {
  const LecturePage({Key? key}) : super(key: key);

  @override
  State<LecturePage> createState() => _LecturePageState();
}

class _LecturePageState extends State<LecturePage> {
  // final LecturePageController _controller =
  //     LectureController(repository: LectureRepository());
  List<dynamic> _videoList = [];
  String _selectedVideoName = '언어'; // 기본 선택값
  String _selectedVideoName1 = 'C언어'; // 기본 선택값
  List<String> _secondDropdownItems = ['C언어', '파이썬', '자바']; // 두 번째 드롭다운의 기본 리스트

  @override
  void initState() {
    super.initState();
    _fetchVideoList();
  }

  Future<void> _fetchVideoList() async {
    // final videoList = await _controller.fetchVideoList(_selectedVideoName1);
    setState(() {
      // _videoList = videoList;
    });
  }

  void _onFirstDropdownChanged(String? newValue) async {
    setState(() {
      _selectedVideoName = newValue ?? '';
    });
    await _fetchVideoList();
    _updateSecondDropdownItems();
    if (_secondDropdownItems.isNotEmpty) {
      setState(() {
        _selectedVideoName1 = _secondDropdownItems[0];
      });
    }
  }

  void _onSecondDropdownChanged(String? newValue) async {
    setState(() {
      _selectedVideoName1 = newValue ?? '';
    });
    await _fetchVideoList();
    _updateSecondDropdownItems();
  }

  void _updateSecondDropdownItems() {
    setState(() {
      _secondDropdownItems = _secondDropdownItems.toSet().toList();
      // 두 번째 드롭다운의 리스트를 첫 번째 드롭다운의 선택값에 따라 동적으로 변경
      if (_selectedVideoName == '언어') {
        _secondDropdownItems = ['C언어', '파이썬', '자바', 'SQL', '코틀린'];
      } else if (_selectedVideoName == '프레임워크 & 라이브러리') {
        _secondDropdownItems = [
          'Python Django',
          'Python Flask',
          'Vue.js',
          'Angular',
          'jQuery',
          '플러터',
          'React Native'
        ];
      } else if (_selectedVideoName == '진로') {
        _secondDropdownItems = [
          '프론트엔드',
          '백엔드',
          '앱개발',
          '정보보안',
          '보안관제',
          'IT 트렌드'
        ];
      } else if (_selectedVideoName == '면접') {
        _secondDropdownItems = [
          '개발자 면접',
          '모의해킹',
        ];
      } else {
        _secondDropdownItems = []; // 기본 선택값 이외의 경우에는 빈 리스트로 설정
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(appName), // 이 페이지에 맞는 app bar 제목을 설정합니다.
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(13),
              ),
              child: DropdownButton<String>(
                value: _selectedVideoName,
                onChanged: _onFirstDropdownChanged,
                items: [
                  DropdownMenuItem(
                    value: '언어',
                    child: Text('언어'),
                  ),
                  DropdownMenuItem(
                    value: '진로',
                    child: Text('진로'),
                  ),
                  DropdownMenuItem(
                    value: '면접',
                    child: Text('면접'),
                  ),
                  // Add more video names here
                ],
                style: TextStyle(
                  color: Colors.black, // Font color
                  fontSize: 17, // Font size on dropdown button
                ),
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 36,
                isExpanded: true,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(13),
              ),
              child: DropdownButton<String>(
                value: _selectedVideoName1,
                onChanged: _onSecondDropdownChanged,
                items: _secondDropdownItems.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                style: TextStyle(
                  color: Colors.black, // Font color
                  fontSize: 17, // Font size on dropdown button
                ),
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 36,
                isExpanded: true,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _videoList.length,
              itemBuilder: (context, index) {
                final video = _videoList[index];
                final title = video[0];
                final url = video[1];
                final views = video[2];
                final uploaded = video[3];

                return ListTile(
                  title: Text(title),
                  subtitle: Text('Views: $views - Uploaded: $uploaded'),
                  onTap: () {
                    // _controller.launchUrl(url);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
