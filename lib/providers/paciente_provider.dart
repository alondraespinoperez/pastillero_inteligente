import 'package:flutter/material.dart';

import 'package:pastillero_inteligente/models/paciente_model.dart';
import 'package:pastillero_inteligente/models/medicamento_model.dart';
import 'package:pastillero_inteligente/services/pastillero_service.dart';

class PacienteProvider extends ChangeNotifier {
  final PastilleroService _service = PastilleroService();

  List<PacienteModel> _pacientes = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<PacienteModel> get pacientes => _pacientes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

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
}