import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'baseUrl.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: API_URL));
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

  Future<Map<String, dynamic>?> getCurrentUser() async {
  String? token = await _secureStorage.read(key: 'access_token');
  if (token == null) return null;

  try {
    Response response = await _dio.get('/current-user', options: Options(
      headers: {'Authorization': 'Bearer $token'},
    ));
    return response.data as Map<String, dynamic>;
  } catch (e) {
    return null;
  }
}

  Future<String> updateUser(String name, String address, String phone) async {
    String? token = await _secureStorage.read(key: 'access_token');
    if (token == null) {
      return "User not logged in!";
    }

    try {
      Response response = await _dio.put('/update-user', data: {
        "name": name,
        "address": address,
        "phone": phone,
      }, options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ));

      if (response.statusCode == 200) {
        return "User updated successfully!";
      } else {
        return "Failed to update user.";
      }
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
