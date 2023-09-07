import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../controller/user_controller.dart';
import '../../global/global.dart';

class StudyEditPage extends StatefulWidget {
  final dynamic studyPost;

  StudyEditPage({required this.studyPost});

  @override
  _StudyEditPageState createState() => _StudyEditPageState();
}

class _StudyEditPageState extends State<StudyEditPage> {
  final TextEditingController headcountController = TextEditingController();
  String? selectedRecruitState;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers and selectedRecruitState with studyPost data
    headcountController.text = widget.studyPost['headcount'].toString();
    selectedRecruitState = widget.studyPost['recruit_state'];
  }

  Future<void> updateStudyPost() async {
    final studyPostPk = widget.studyPost['pk'];
    final accessToken =
        AuthService.accessToken; // Replace with your access token

    final url = Uri.parse('${Global.baseUrl}/home/study/$studyPostPk/');

    final response = await http.patch(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken',
      },
      body: {
        'headcount': headcountController.text,
        'recruit_state': selectedRecruitState!,
      },
    );

    if (response.statusCode == 200) {
      // Study post updated successfully
      // You can handle success here, e.g., navigate back to the previous page
      Navigator.of(context).pop(true);
    } else {
      // Study post update failed
      // Handle the error, e.g., show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('게시물 수정에 실패했습니다.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시물 수정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: headcountController,
                decoration: InputDecoration(labelText: '인원'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedRecruitState,
                items: ['모집중', '모집완료']
                    .map((state) => DropdownMenuItem<String>(
                          value: state,
                          child: Text(state),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedRecruitState = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: '모집 상태',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed:
                    updateStudyPost, // Call the updateStudyPost function on button press
                child: Text('저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
