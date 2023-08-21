import 'package:flutter/material.dart';
import 'package:iamport_flutter/iamport_payment.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    // IamportPayment.setProductionMode(false); // 개발 모드 설정
    // IamportPayment.setImpKey('YOUR_IMP_KEY'); // 발급받은 아임포트 API 키 설정
    TextEditingController amountController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('결제 테스트'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: '결제 금액'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // String amount = amountController.text;
                // if (amount.isEmpty) {
                //   // 금액이 입력되지 않았을 경우 에러 처리
                //   return;
                // }

                // String userCode = 'YOUR_USER_CODE'; // 아임포트에서 발급받은 가맹점 코드
                // String itemName = '테스트 상품'; // 상품명
                // String buyerName = '홍길동'; // 구매자 이름

                // Map<String, String> data = {
                //   'pg': 'html5_inicis', // 결제사
                //   'pay_method': 'card', // 결제 수단
                //   'merchant_uid': 'order1234', // 주문번호
                //   'amount': amount, // 결제 금액
                //   'name': itemName, // 상품명
                //   'buyer_name': buyerName, // 구매자 이름
                // };

                // IamportPayment.startPayment(data, userCode: userCode,
                //     callback: (Map<String, String> result) {
                //   // 결제 결과 처리
                //   print('결제 결과: $result');
                //   if (result['success'] == 'true') {
                //     print('결제 완료');
                //     // 결제 성공 처리
                //     // TODO: 결제 성공에 대한 로직 추가
                //   } else {
                //     // 결제 실패 처리
                //     // TODO: 결제 실패에 대한 로직 추가
                //   }
                // });
              },
              child: Text('결제하기'),
            ),
          ],
        ),
      ),
    );
  }
}
