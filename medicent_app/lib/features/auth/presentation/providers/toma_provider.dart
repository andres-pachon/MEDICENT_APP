import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TomaProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  final String baseUrl = 'http://127.0.0.1:5000/api';

  List<dynamic> tomas = [];
  bool isLoading = false;

  // 👇 NUEVA FUNCIÓN: Traer las tomas desde Flask
  Future<void> cargarTomas() async {
    isLoading = true;
    notifyListeners();

    try {
      final token = await _storage.read(key: 'jwt_token');
      final response = await http.get(
        Uri.parse('$baseUrl/tomas'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        tomas = jsonDecode(response.body);
      } else {
        print("❌ Error al cargar tomas: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error de red al cargar tomas: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Tu función actual para guardar...
  Future<bool> registrarToma({
    required int idPaciente,
    required int idMedicamento,
    required String fecha,
    required String hora,
    required String dosis,
    required String nota,
    required String estado,
  }) async {
    try {
      final token = await _storage.read(key: 'jwt_token');
      final cuerpoJson = jsonEncode({
        'idPaciente': idPaciente,
        'idMedicamento': idMedicamento,
        'fecha': fecha,
        'hora': hora,
        'dosis': dosis,
        'nota': nota,
        'estado': estado,
      });

      final response = await http.post(
        Uri.parse('$baseUrl/tomas'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: cuerpoJson,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // 👇 AL GUARDAR CON ÉXITO, ACTUALIZAMOS LA LISTA AUTOMÁTICAMENTE
        await cargarTomas(); 
        return true;
      }
      return false;
    } catch (e) {
      print("❌ Error al registrar toma: $e");
      return false;
    }
  }
}