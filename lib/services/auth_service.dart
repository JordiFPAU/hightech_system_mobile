import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../models/usuario.dart';

class AuthService {
  static const String _tokenKey = 'token';
  static const String _usuarioKey = 'usuario';

  // Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.authUrl}/usuarios/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await guardarSesion(data['token'], data['usuario']);
      return data;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['error'] ?? 'Error al iniciar sesión');
    }
  }

  // Guardar sesión
  Future<void> guardarSesion(String token, Map<String, dynamic> usuarioJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_usuarioKey, jsonEncode(usuarioJson));
  }

  // Obtener token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Obtener usuario actual
  Future<Usuario?> getUsuarioActual() async {
    final prefs = await SharedPreferences.getInstance();
    final usuarioJson = prefs.getString(_usuarioKey);
    if (usuarioJson == null) return null;
    return Usuario.fromJson(jsonDecode(usuarioJson));
  }

  // Cerrar sesión
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_usuarioKey);
  }

  // Verificar si hay sesión activa
  Future<bool> estaAutenticado() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}