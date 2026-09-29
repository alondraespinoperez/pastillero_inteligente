import 'package:flutter/material.dart';

import 'package:pastillero_inteligente/models/medicamento_model.dart';
import 'package:pastillero_inteligente/models/paciente_model.dart';
import 'package:pastillero_inteligente/services/pastillero_service.dart';

class PacienteProvider extends ChangeNotifier {
  final PastilleroService _service = PastilleroService();

  List<PacienteModel> _pacientes = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<PacienteModel> get pacientes => _pacientes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool idPastilleroExiste(String idPastillero, {String? excluirId}) {
    return _pacientes.any((p) =>
        p.idPastillero.toUpperCase() == idPastillero.toUpperCase() &&
        p.id != excluirId);
  }

  // ─── Cargar todos los pacientes del médico autenticado ──────────
  Future<void> cargarPacientes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _pacientes = await _service.getPacientes();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── Crear paciente ─────────────────────────────────────────────
  Future<bool> crearPaciente(Map<String, dynamic> data) async {
    if (idPastilleroExiste(data['id_pastillero'] as String)) {
      _errorMessage =
          'El ID ${data['id_pastillero']} ya esta asignado a otro paciente';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final nuevo = await _service.createPaciente(data);
      _pacientes.add(nuevo);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── Actualizar paciente ────────────────────────────────────────
  Future<bool> actualizarPaciente(
      String pacienteId, Map<String, dynamic> data) async {
    if (idPastilleroExiste(data['id_pastillero'] as String,
        excluirId: pacienteId)) {
      _errorMessage =
          'El ID ${data['id_pastillero']} ya esta asignado a otro paciente';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final actualizado = await _service.updatePaciente(pacienteId, data);
      final index = _pacientes.indexWhere((p) => p.id == pacienteId);
      if (index != -1) {
        _pacientes[index] = actualizado;
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── Eliminar paciente ──────────────────────────────────────────
  Future<bool> eliminarPaciente(String pacienteId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.deletePaciente(pacienteId);
      _pacientes.removeWhere((p) => p.id == pacienteId);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── Agregar medicamento a un paciente ──────────────────────────
  Future<bool> agregarMedicamento(
      String pacienteId, Map<String, dynamic> data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final med = await _service.addMedicamento(pacienteId, data);
      final index = _pacientes.indexWhere((p) => p.id == pacienteId);
      if (index != -1) {
        _pacientes[index].listaMedicamentos.add(med);
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── Eliminar medicamento ───────────────────────────────────────
  Future<bool> eliminarMedicamento(
      String pacienteId, String medicamentoId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.deleteMedicamento(pacienteId, medicamentoId);
      final pIndex = _pacientes.indexWhere((p) => p.id == pacienteId);
      if (pIndex != -1) {
        _pacientes[pIndex]
            .listaMedicamentos
            .removeWhere((m) => m.id == medicamentoId);
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── Marcar medicamento como completado/pendiente ───────────────
  Future<void> toggleCompletado(
      String pacienteId, String medicamentoId) async {
    final pIndex = _pacientes.indexWhere((p) => p.id == pacienteId);
    if (pIndex == -1) return;

    final mIndex = _pacientes[pIndex]
        .listaMedicamentos
        .indexWhere((m) => m.id == medicamentoId);
    if (mIndex == -1) return;

    // Optimistic update: cambiar localmente primero
    final anterior =
        _pacientes[pIndex].listaMedicamentos[mIndex].estaCompletado;
    _pacientes[pIndex].listaMedicamentos[mIndex].estaCompletado = !anterior;
    notifyListeners();

    try {
      await _service.toggleMedicamento(medicamentoId);
    } catch (e) {
      // Si falla, revertir el cambio local
      _pacientes[pIndex].listaMedicamentos[mIndex].estaCompletado = anterior;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    }
  }
}