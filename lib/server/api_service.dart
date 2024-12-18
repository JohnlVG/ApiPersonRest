import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://localhost:5000/api/personas";

  Future<List<dynamic>> obtenerPersonas() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Error al obtener personas");
    }
  }

  Future<Map<String, dynamic>> crearPersona(Map<String, dynamic> persona) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(persona),
    );
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception("Error al crear persona");
    }
  }

  Future<Map<String, dynamic>> actualizarPersona(String id, Map<String, dynamic> persona) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(persona),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Error al actualizar persona");
    }
  }

  Future<void> eliminarPersona(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));
    if (response.statusCode != 200) {
      throw Exception("Error al eliminar persona");
    }
  }
}
