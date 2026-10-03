import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MedicamentoProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  final String baseUrl = 'http://127.0.0.1:5000/api';

  List<dynamic> medicamentos = [];
  bool isLoading = false;
  String? errorMessage;

  // 1. Obtener medicamentos desde Flask (Workbench)
  Future<void> cargarMedicamentos() async {
    isLoading = true;
    notifyListeners();

    try {
      final token = await _storage.read(key: 'jwt_token');
      final response = await http.get(
        Uri.parse('$baseUrl/medicamentos'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        medicamentos = jsonDecode(response.body);
      } else {
        errorMessage = 'Error al cargar medicamentos';
      }
    } catch (e) {
      errorMessage = 'Error de conexión';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 2. Registrar un nuevo medicamento (Va directo a Workbench)
  Future<bool> agregarMedicamento({
    required String nombre,
    required double concentracion,
    required int frecuenciaDiaria,
    required String fechaVencimiento,
    required int idTratamiento,
    required int idTipoMedicamento,
    required int idViaAdministracion,
    required int idStock,
  }) async {
    try {
      final token = await _storage.read(key: 'jwt_token');
      
      final response = await http.post(
        Uri.parse('$baseUrl/medicamentos'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'nombre': nombre,
          'concentracion': concentracion,
          'frecuenciaDiaria': frecuenciaDiaria,
          'fechaVencimiento': fechaVencimiento,
          'idTratamiento': idTratamiento,
          'idTipoMedicamento': idTipoMedicamento,
          'idViaAdministracion': idViaAdministracion,
          'idStock': idStock,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        await cargarMedicamentos(); // Recarga la lista automáticamente
        return true;
      }
      return false;
    } catch (e) {
      print("Error al agregar medicamento: $e");
      return false;
    }
  }
}