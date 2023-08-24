import 'dart:convert';

import 'package:book/controller/user_controller.dart';
import 'package:book/screens/ItBook.dart';
import 'package:book/screens/User/register.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;

import '../../global/global.dart';
import '../../main.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _authentication = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _loginUser() async {
    final String email = emailController.text;
    final String password = passwordController.text;

    // Create a map with the user credentials
    Map<String, String> credentials = {
      'email': email,
      'password': password,
    };
    final newUser = await _authentication.signInWithEmailAndPassword(
        email: email, password: password);

    // Convert the credentials map to a JSON string
    String jsonData = jsonEncode(credentials);

    // Set the request headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    // Send the POST request
    final response = await http.post(
      Uri.parse('${Global.baseUrl}/account/login/'),
      headers: headers,
      body: jsonData,
    );
    print(response.statusCode);
    // Check the response
    if (response.statusCode == 200) {
      // Login successful
      String decodedResponse = utf8.decode(response.bodyBytes);
      print('Login successful! Response: ${decodedResponse}');
      await AuthService.login(decodedResponse);
      Get.offAll(() => ItBook());
      // You can add navigation logic here to redirect to another page after successful login
    } else {
      // Login failed
      String decodedResponse = utf8.decode(response.bodyBytes);
      print('Login failed. Error: $decodedResponse');
      print('Login failed. Error: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text("Don't have an account?"),
                TextButton(
                    onPressed: () {
                      Get.to(() => Register());
                    },
                    child: Text('Register'))
              ],
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loginUser,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
