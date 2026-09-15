import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  
  // URL de tu backend
  final String baseUrl = 'http://127.0.0.1:5000/api'; 

  String? _token;
  String? nombreUsuario; 
  String? errorMessage; 
  
  bool get isAuthenticated => _token != null;

  // 1. VERIFICAR SESIÓN INICIAL (La función que le faltaba a main.dart)
  Future<void> checkAuthStatus() async {
    _token = await _storage.read(key: 'jwt_token');
    notifyListeners();
  }

  // 2. INICIAR SESIÓN
  Future<bool> login(String correo, String password) async {
    // Limpiamos errores anteriores
    errorMessage = null; 
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'correo': correo,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Guardamos el token
        if (data.containsKey('token')) {
          _token = data['token'];
          await _storage.write(key: 'jwt_token', value: _token);
        }

        // Guardamos el nombre dinámico del usuario
        if (data['usuario'] != null && data['usuario']['nombre'] != null) {
          nombreUsuario = data['usuario']['nombre'];
        }

        notifyListeners(); 
        return true;
      } else {
        // Guardamos el error (ej: contraseña incorrecta)
        errorMessage = data['message'] ?? 'Error al iniciar sesión';
        notifyListeners();
        return false;
      }
    } catch (e) {
      errorMessage = 'Error de conexión con el servidor.';
      notifyListeners();
      return false;
    }
  }

  // 3. CERRAR SESIÓN
  Future<void> logout() async {
    _token = null;
    nombreUsuario = null;
    errorMessage = null;
    await _storage.delete(key: 'jwt_token');
    notifyListeners();
  }
}