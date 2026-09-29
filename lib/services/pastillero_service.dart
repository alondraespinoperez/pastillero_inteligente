import 'package:dio/dio.dart';

import 'package:pastillero_inteligente/models/medicamento_model.dart';
import 'package:pastillero_inteligente/models/paciente_model.dart';
import 'package:pastillero_inteligente/services/api_client.dart';

class PastilleroService {
  final ApiClient _apiClient = ApiClient();

  // ─── Autenticación ─────────────────────────────────────────────
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiClient.dio.post('/login', data: {
        'email': email,
        'password': password,
      });
      return response.data;
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] ?? 'Error de inicio de sesion';
      throw Exception(message);
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.post('/register', data: data);
      return response.data;
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Error al registrar';
      throw Exception(message);
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.dio.post('/logout');
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] ?? 'Error al cerrar sesion';
      throw Exception(message);
    }
  }

  Future<Map<String, dynamic>> me() async {
    try {
      final response = await _apiClient.dio.get('/me');
      return response.data;
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Error al obtener perfil';
      throw Exception(message);
    }
  }

  // ─── Pacientes ─────────────────────────────────────────────────
  Future<List<PacienteModel>> getPacientes() async {
    try {
      final response = await _apiClient.dio.get('/pacientes');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => PacienteModel.fromJson(json)).toList();
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] ?? 'Error al obtener pacientes';
      throw Exception(message);
    }
  }

  Future<PacienteModel> createPaciente(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.post('/pacientes', data: data);
      return PacienteModel.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] ?? 'Error al crear paciente';
      throw Exception(message);
    }
  }

  Future<PacienteModel> updatePaciente(
      String pacienteId, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio
          .put('/pacientes/$pacienteId', data: data);
      return PacienteModel.fromJson(response.data['data'] ?? response.data);
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] ?? 'Error al actualizar paciente';
      throw Exception(message);
    }
  }

  Future<void> deletePaciente(String pacienteId) async {
    try {
      await _apiClient.dio.delete('/pacientes/$pacienteId');
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] ?? 'Error al eliminar paciente';
      throw Exception(message);
    }
  }

  // ─── Medicamentos ──────────────────────────────────────────────
  Future<MedicamentoModel> addMedicamento(
      String pacienteId, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio
          .post('/pacientes/$pacienteId/medicamentos', data: data);
      return MedicamentoModel.fromJson(
          response.data['data'] ?? response.data);
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] ?? 'Error al agregar medicamento';
      throw Exception(message);
    }
  }

  Future<MedicamentoModel> updateMedicamento(
      String medicamentoId, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio
          .put('/medicamentos/$medicamentoId', data: data);
      return MedicamentoModel.fromJson(
          response.data['data'] ?? response.data);
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] ?? 'Error al actualizar medicamento';
      throw Exception(message);
    }
  }

  Future<void> deleteMedicamento(
      String pacienteId, String medicamentoId) async {
    try {
      await _apiClient.dio.delete('/medicamentos/$medicamentoId');
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] ?? 'Error al eliminar medicamento';
      throw Exception(message);
    }
  }

  Future<MedicamentoModel> toggleMedicamento(String medicamentoId) async {
    try {
      final response = await _apiClient.dio
          .patch('/medicamentos/$medicamentoId/toggle');
      return MedicamentoModel.fromJson(
          response.data['data'] ?? response.data);
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] ?? 'Error al cambiar estado';
      throw Exception(message);
    }
  }
}