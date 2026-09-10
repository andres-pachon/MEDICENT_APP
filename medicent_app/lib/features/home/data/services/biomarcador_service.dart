import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/biomarcador.dart';

class BiomarcadorService {
  final String baseUrl = 'http://127.0.0.1:5000/api';
  final _storage = const FlutterSecureStorage();

  Future<Map<String, String>> _headers() async {
    final token = await _storage.read(key: 'jwt_token');
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<Biomarcador>> getBiomarcadores() async {
    final response = await http.get(
      Uri.parse('$baseUrl/biomarcadores'),
      headers: await _headers(),
    );
    return _parseLista(response);
  }

  Future<List<Biomarcador>> getBiomarcadoresHoy() async {
    final hoy = DateTime.now();
    final fecha =
        '${hoy.year}-${hoy.month.toString().padLeft(2, '0')}-${hoy.day.toString().padLeft(2, '0')}';
    final response = await http.get(
      Uri.parse('$baseUrl/biomarcadores?fecha=$fecha'),
      headers: await _headers(),
    );
    return _parseLista(response);
  }

  Future<Biomarcador> crearBiomarcador(Biomarcador bio) async {
    final response = await http.post(
      Uri.parse('$baseUrl/biomarcadores'),
      headers: await _headers(),
      body: jsonEncode(bio.toJson()),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al guardar (${response.statusCode})');
    }
    if (response.body.isEmpty) return bio;
    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) {
      return Biomarcador.fromJson(decoded);
    }
    return bio;
  }

  List<Biomarcador> _parseLista(http.Response response) {
    if (response.statusCode != 200) {
      throw Exception('Error al cargar biomarcadores (${response.statusCode})');
    }
    if (response.body.isEmpty) return [];

    final decoded = jsonDecode(response.body);
    List<dynamic> lista;
    if (decoded is List) {
      lista = decoded;
    } else if (decoded is Map && decoded['biomarcadores'] is List) {
      lista = decoded['biomarcadores'] as List;
    } else if (decoded is Map && decoded['data'] is List) {
      lista = decoded['data'] as List;
    } else {
      return [];
    }

    return lista
        .whereType<Map>()
        .map((e) => Biomarcador.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}