import 'dart:convert';

class AuthService {
  static String? accessToken;
  static String? refreshToken;
  static int? userId;

  static Future<void> login(String response) async {
    Map<String, dynamic> responseData = jsonDecode(response);
    accessToken = responseData['access'];
    refreshToken = responseData['refresh'];
    userId = responseData['user_id'];
  }

  static bool isLoggedIn() {
    return accessToken != null;
  }

  static void logout() {
    accessToken = null;
    refreshToken = null;
    userId = null;
  }
}
