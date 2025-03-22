import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'baseUrl.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: AUTH_API_URL));

  Future<void> _storeUserDetails(Map<String, dynamic> userDetails) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', userDetails['name']);
    await prefs.setString('email', userDetails['email']);
    await prefs.setString('phone', userDetails['phone']);
    await prefs.setString('address', userDetails['address']);
    await prefs.setString('user_id', userDetails['user_id']);
  }

  Future<String> createAccountWithEmail(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    if (password != confirmPassword) {
      return "Passwords do not match!";
    }

    try {
      await _dio.post(
        '/register',
        data: {
          "name": name,
          "email": email,
          "password": password,
          "address": "",
          "phone": "",
        },
      );
      return "Account Created";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> loginWithEmail(String email, String password) async {
    try {
      Response response = await _dio.post(
        '/login',
        data: {"email": email, "password": password},
      );

      String token = response.data['access_token'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', token);

      Map<String, dynamic> userDetails = {
        'name': response.data['name'] ?? 'Unknown',
        'email': response.data['email'] ?? email,
        'phone': response.data['phone'] ?? '',
        'address': response.data['address'] ?? '',
        'user_id': response.data['user_id'] ?? '',
      };
      await _storeUserDetails(userDetails);

      return "Login Successful";
    } catch (e) {
      return e.toString();
    }
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    String? userId = prefs.getString('user_id');

    if (token == null || userId == null) return null;

    try {
      String? name = prefs.getString('name');
      String? email = prefs.getString('email');
      String? phone = prefs.getString('phone');
      String? address = prefs.getString('address');

      if (name == null || email == null) {
        return null;
      }

      return {
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'user_id': userId,
      };
    } catch (e) {
      return null;
    }
  }

  Future<String> updateUser(String name, String address, String phone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    String? userId = prefs.getString('user_id');
    if (token == null || userId == null) {
      return "User not logged in!";
    }

    try {
      Response response = await _dio.put(
        '/update-user',
        data: {"name": name, "address": address, "phone": phone},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> updatedUserDetails = {
          'name': name,
          'email': prefs.getString('email') ?? '',
          'phone': phone,
          'address': address,
          'user_id': userId,
        };
        await _storeUserDetails(updatedUserDetails);
        return "User updated successfully!";
      } else {
        return "Failed to update user.";
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('name');
    await prefs.remove('email');
    await prefs.remove('phone');
    await prefs.remove('address');
    await prefs.remove('user_id');
  }

  Future<String> resetPassword(String email) async {
    try {
      await _dio.post('/reset-password', data: {"email": email});
      return "Mail Sent";
    } catch (e) {
      return e.toString();
    }
  }
}
