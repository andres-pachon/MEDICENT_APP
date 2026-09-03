import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final String baseUrl = 'http://10.1.223.29:5000';
  final _storage = const FlutterSecureStorage();

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/login'),
        headers: {'Content-Type': 'application/json'},
        // 1. Revertido a 'email' tal como lo lee request.get_json() en Flask
        body: jsonEncode({'email': email, 'password': password}),
      );

      print('Status Code del servidor: ${response.statusCode}');
      print('Respuesta del servidor: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // 2. Corregido a 'accessToken' tal como lo responde jsonify en Flask
        final token = data['accessToken']; 
        
        await _storage.write(key: 'jwt_token', value: token);
        return true;
      }
      return false;
    } catch (e) {
      print('Error de conexión: $e');
      return false;
    }
  }

  Future<String?> getToken() async => await _storage.read(key: 'jwt_token');

  Future<void> logout() async => await _storage.delete(key: 'jwt_token');

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}