import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://192.168.8.200:8000/auth'));

  Future<String> createAccountWithEmail(
      String name, String email, String password) async {
    try {
      Response response = await _dio.post('/register', data: {
        "name": name,
        "email": email,
        "password": password,
      });
      return "Account Created";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> loginWithEmail(String email, String password) async {
    try {
      Response response = await _dio.post('/login', data: {
        "email": email,
        "password": password,
      });
      String token = response.data['access_token'];
      // Save token locally for future use
      return "Login Successful";
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future logout() async {
    try {
      await _dio.post('/logout');
      // Clear any stored authentication data
    } catch (e) {
      return e.toString();
    }
  }

  Future resetPassword(String email) async {
    try {
      await _dio.post('/reset-password', data: {"email": email});
      return "Mail Sent";
    } catch (e) {
      return e.toString();
    }
  }

  // Future<bool> isLoggedIn() async {
  //   // Check if the user has a stored JWT token (this is an example)
  //   String? token = await getStoredToken();  // Replace with your token storage logic
  //   return token != null;
  // }
}
