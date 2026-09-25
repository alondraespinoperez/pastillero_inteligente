import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/pastillero_service.dart';

class AuthProvider extends ChangeNotifier {
  final PastilleroService _service = PastilleroService();
  final _storage = const FlutterSecureStorage();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _service.login(email, password);
      final token = data['token'] ?? data['access'];
      if (token != null) {
        await _storage.write(key: 'auth_token', value: token);
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

  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    _isAuthenticated = false;
    notifyListeners();
  }
}