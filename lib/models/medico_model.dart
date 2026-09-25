class MedicoModel {
  final String id;
  final String nombre;
  final String especialidad;
  final String cedula;
  final String correo;

  MedicoModel({
    required this.id,
    required this.nombre,
    required this.especialidad,
    required this.cedula,
    required this.correo,
  });

  factory MedicoModel.fromJson(Map<String, dynamic> json) {
    return MedicoModel(
      id: json['id'].toString(),
      nombre: json['nombre'] ?? '',
      especialidad: json['especialidad'] ?? '',
      cedula: json['cedula'] ?? '',
      correo: json['correo'] ?? '',
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'nombre' : nombre,
      'especialidad' : especialidad,
      'cedula' : cedula,
      'correo' : correo, 
    };
  }
}