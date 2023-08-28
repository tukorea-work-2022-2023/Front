import 'package:book/screens/Home/Board/AladinGet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:get/get.dart';

class ChoicePage extends StatefulWidget {
  const ChoicePage({super.key});

  @override
  State<ChoicePage> createState() => _ChoicePageState();
}

class _ChoicePageState extends State<ChoicePage> {
  String _scanBarcode = '';

  void initState() {
    super.initState();
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      title: Text(
        "책 등록",
      ),
      actions: [],
    );
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException catch (e) {
      print("Error scanning barcode: $e");
      barcodeScanRes = 'Failed to scan barcode: $e';
    }
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
    //새로 추가한 isbn넘기기
    Get.to(() => SearchScreen(isbn: _scanBarcode));
  }

  Widget _bookaddWidget() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '책 등록할 방법을 골라주세요',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(40),
                ),
                onPressed: () => scanBarcodeNormal(),
                child: Text('카메라로 바코드 스캔')),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(40),
                ),
                onPressed: () {
                  Get.to(() => SearchScreen(
                        isbn: '',
                      ));
                },
                child: Text('ISBN 으로 검색')),
            // ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       minimumSize: Size.fromHeight(40),
            //     ),
            //     onPressed: () {},
            //     child: Text('수동으로 정보 입력')),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: _bookaddWidget(),
    );
  }
}
