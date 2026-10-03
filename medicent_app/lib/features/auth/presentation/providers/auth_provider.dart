import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  final String baseUrl = 'http://127.0.0.1:5000/api';

  String? _token;
  String? nombreUsuario; 
  String? errorMessage; 
  
  bool get isAuthenticated => _token != null;

  Future<void> checkAuthStatus() async {
    _token = await _storage.read(key: 'jwt_token');
    notifyListeners();
  }

  Future<bool> login(String correo, String password) async {
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
        final tokenRecibido = data['access_token'] ?? data['token'];
        
        print("🔑 Token recibido del servidor: $tokenRecibido"); 

        if (tokenRecibido != null) {
          _token = tokenRecibido;
          await _storage.write(key: 'jwt_token', value: _token);
        }

        if (data['usuario'] != null && data['usuario']['nombre'] != null) {
          nombreUsuario = data['usuario']['nombre'];
        }

        notifyListeners(); 
        return true;
      } else {
        errorMessage = data['message'] ?? data['error'] ?? 'Error al iniciar sesión';
        notifyListeners();
        return false;
      }
    } catch (e) {
      errorMessage = 'Error de conexión con el servidor.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String nombre,
    required String apellido,
    required String documento,
    required String correo,
    required String telefono,
    required String fechaNacimiento,
    required String password,
    required int idTipoDocumento,
  }) async {
    errorMessage = null;
    notifyListeners();

    try {
      final cuerpoJson = jsonEncode({
        'nombre': nombre,
        'apellido': apellido,
        'documento': documento,
        'correo': correo,
        'telefono': telefono,
        'fechaNacimiento': fechaNacimiento,
        'password': password,
        'idTipoDocumento': idTipoDocumento,
      });

      print("🚀 ENVIANDO REGISTRO A FLASK: $cuerpoJson");

      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: cuerpoJson,
      );

      print("📥 RESPUESTA DE REGISTRO FLASK: ${response.statusCode} - ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return true;
      } else {
        errorMessage = data['error'] ?? data['message'] ?? 'Error al registrar usuario';
        notifyListeners();
        return false;
      }
    } catch (e) {
      print("❌ ERROR DE RED EN REGISTRO: $e");
      errorMessage = 'Error de conexión con el servidor.';
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _token = null;
    nombreUsuario = null;
    errorMessage = null;
    await _storage.delete(key: 'jwt_token');
    notifyListeners();
  }
}