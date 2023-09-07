import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iamport_flutter/iamport_payment.dart';
import 'package:iamport_flutter/model/payment_data.dart';

import '../../config2.dart';
import '../ItBook.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('보증금 결제'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: '결제금액',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    int amount = int.tryParse(amountController.text) ?? 0;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IamportPayment(
                          appBar: AppBar(
                            title: Text('아임포트 결제'),
                          ),
                          initialChild: Container(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/images/iamport-logo.png'),
                                  SizedBox(height: 15),
                                  Text(
                                    '잠시만 기다려주세요...',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          userCode: userCode,
                          data: PaymentData(
                            pg: 'kakaopay',
                            payMethod: 'card',
                            name: '아임포트 결제데이터 분석',
                            merchantUid:
                                'mid_${DateTime.now().millisecondsSinceEpoch}',
                            amount:
                                amount, // Use the dynamically entered amount
                            buyerName: '홍길동',
                            buyerTel: '01012345678',
                            buyerEmail: 'example@naver.com',
                            buyerAddr: '서울시 강남구 신사동 661-16',
                            buyerPostcode: '06018',
                            appScheme: 'example',
                            cardQuota: [2, 3],
                          ),
                          callback: (Map<String, String> result) {
                            Get.to(() => ItBook());
                          },
                        ),
                      ),
                    );
                  },
                  child: Text('결제하기'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }
}
