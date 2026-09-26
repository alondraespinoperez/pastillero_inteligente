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

  void toggleCompletado(String pacienteId, String medicamentoId) {
    final pIndex = _pacientes.indexWhere((p) => p.id == pacienteId);
    if (pIndex == -1) return;

    final mIndex = _pacientes[pIndex]
        .listaMedicamentos
        .indexWhere((m) => m.id == medicamentoId);
    if (mIndex == -1) return;

    _pacientes[pIndex].listaMedicamentos[mIndex].estaCompletado =
        !_pacientes[pIndex].listaMedicamentos[mIndex].estaCompletado;
    notifyListeners();
  }

  /// SOLO para pruebas sin backend. Quitar al conectar API real.
  void cargarDemo() {
    _pacientes = [
      PacienteModel(
        id: 'P001',
        nombre: 'Maria Gonzalez',
        edad: 72,
        telefono: '+52 555 123 4567',
        diagnostico: 'Hipertension, Diabetes tipo 2',
        idPastillero: 'PILL-001',
        listaMedicamentos: [
          MedicamentoModel(
            id: 'M001',
            nombre: 'Losartan',
            dosis: '50 mg',
            horaToma: '08:00',
            numeroCompartimento: 1,
            frecuencia: 'Cada 24 horas',
          ),
          MedicamentoModel(
            id: 'M002',
            nombre: 'Metformina',
            dosis: '850 mg',
            horaToma: '14:00',
            numeroCompartimento: 2,
            frecuencia: 'Cada 12 horas',
            estaCompletado: true,
          ),
        ],
      ),
      PacienteModel(
        id: 'P002',
        nombre: 'Jose Ramirez',
        edad: 65,
        telefono: '+52 555 987 6543',
        diagnostico: 'Artritis reumatoide',
        idPastillero: 'PILL-002',
      ),
    ];
    notifyListeners();
  }
}