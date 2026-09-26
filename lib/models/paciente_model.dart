import 'package:pastillero_inteligente/models/medicamento_model.dart';

class PacienteModel {
  final String id;
  final String nombre;
  final int edad;
  final String telefono;
  final String diagnostico;
  final String idPastillero;
  final List<MedicamentoModel> listaMedicamentos;

  // Contacto de emergencia
  final String contactoNombre;
  final String contactoTelefono;
  final String contactoParentesco;

  PacienteModel({
    required this.id,
    required this.nombre,
    required this.edad,
    required this.telefono,
    required this.diagnostico,
    required this.idPastillero,
    List<MedicamentoModel>? listaMedicamentos,
    this.contactoNombre = '',
    this.contactoTelefono = '',
    this.contactoParentesco = '',
  }) : listaMedicamentos = listaMedicamentos ?? [];

  factory PacienteModel.fromJson(Map<String, dynamic> json) {
    return PacienteModel(
      id: json['id'].toString(),
      nombre: json['nombre'] ?? '',
      edad: json['edad'] ?? 0,
      telefono: json['telefono'] ?? '',
      diagnostico: json['diagnostico'] ?? '',
      idPastillero: json['id_pastillero'] ?? '',
      contactoNombre: json['contacto_nombre'] ?? '',
      contactoTelefono: json['contacto_telefono'] ?? '',
      contactoParentesco: json['contacto_parentesco'] ?? '',
      listaMedicamentos: (json['medicamentos'] as List<dynamic>?)
              ?.map((m) => MedicamentoModel.fromJson(m))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'edad': edad,
      'telefono': telefono,
      'diagnostico': diagnostico,
      'id_pastillero': idPastillero,
      'contacto_nombre': contactoNombre,
      'contacto_telefono': contactoTelefono,
      'contacto_parentesco': contactoParentesco,
      'medicamentos': listaMedicamentos.map((m) => m.toJson()).toList(),
    };
  }
}