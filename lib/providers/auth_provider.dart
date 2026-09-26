import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:pastillero_inteligente/services/pastillero_service.dart';

class AuthProvider extends ChangeNotifier {
  final PastilleroService _service = PastilleroService();
  final _storage = const FlutterSecureStorage();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;

  String? _nombreMedico;
  String? _especialidad;
  String? _cedula;
  String? _correo;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  String? get nombreMedico => _nombreMedico;
  String? get especialidad => _especialidad;
  String? get cedula => _cedula;
  String? get correo => _correo;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _service.login(email, password);
      final token = data['token'] ?? data['access'];
      if (token != null) {
        await _storage.write(key: 'auth_token', value: token);

        final user = data['user'];
        if (user is Map) {
          _nombreMedico = user['nombre'];
          _especialidad = user['especialidad'];
          _cedula = user['cedula'];
          _correo = user['correo'] ?? user['email'];
        } else {
          _nombreMedico = 'Doctor';
          _correo = email;
        }

        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _errorMessage = 'Token no recibido';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(Map<String, dynamic> data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.register(data);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void actualizarPerfilLocal({
    String? nombre,
    String? especialidad,
    String? cedula,
    String? correo,
  }) {
    if (nombre != null) _nombreMedico = nombre;
    if (especialidad != null) _especialidad = especialidad;
    if (cedula != null) _cedula = cedula;
    if (correo != null) _correo = correo;
    notifyListeners();
  }

  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    _isAuthenticated = false;
    _nombreMedico = null;
    _especialidad = null;
    _cedula = null;
    _correo = null;
    notifyListeners();
  }
}