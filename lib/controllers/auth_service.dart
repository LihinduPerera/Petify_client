import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://192.168.8.200:8000/auth'));
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<String> createAccountWithEmail(
      String name, String email, String password, String confirmPassword) async {
    if (password != confirmPassword) {
      return "Passwords do not match!";
    }
    
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
      await _secureStorage.write(key: 'access_token', value: token);
      return "Login Successful";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> getCurrentUser() async {
    String? token = await _secureStorage.read(key: 'access_token');
    if (token == null) return null;

    try {
      Response response = await _dio.get('/current-user', options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ));
      return response.data.toString();
    } catch (e) {
      return e.toString();
    }
  }

  Future logout() async {
    await _secureStorage.delete(key: 'access_token');
  }

  Future resetPassword(String email) async {
    try {
      await _dio.post('/reset-password', data: {"email": email});
      return "Mail Sent";
    } catch (e) {
      return e.toString();
    }
  }
}
