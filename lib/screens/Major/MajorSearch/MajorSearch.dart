import 'package:flutter/material.dart';

import 'MajorSearchResult.dart';

class MajorSearch extends StatefulWidget {
  const MajorSearch({Key? key}) : super(key: key);

  @override
  State<MajorSearch> createState() => _MajorSearchState();
}

class _MajorSearchState extends State<MajorSearch> {
  TextEditingController _searchController = TextEditingController();

  void _printEnteredText() {
    print("Entered text: ${_searchController.text}");
    String searchText = _searchController.text;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MajorSearchResult(searchText: searchText),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: TextField(
              controller: _searchController,
              onSubmitted: (value) {
                _printEnteredText();
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                  },
                ),
                hintText: '검색어를 입력해주세요',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Text(
            '   최근 검색어',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
