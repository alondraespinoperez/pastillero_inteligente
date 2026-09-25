class MedicamentoModel {
  final String id;
  final String nombre;
  final String dosis;
  final String horaToma;
  final int numeroCompartimento;
  final String frecuencia;
  bool estaCompletado;

  MedicamentoModel({
    required this.id,
    required this.nombre,
    required this.dosis,
    required this.horaToma,
    required this.numeroCompartimento,
    required this.frecuencia,
    this.estaCompletado = false,
  });

  factory MedicamentoModel.fromJson(Map<String, dynamic> json) {
    return MedicamentoModel(
      id: json['id'].toString(),
      nombre: json['nombre'] ?? '',
      dosis: json['dosis'] ?? '',
      horaToma: json['hora_toma'] ?? '',
      numeroCompartimento: json['numero_compartimento'] ?? 1,
      frecuencia: json['frecuencia'] ?? '',
      estaCompletado: json['esta_completado'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'nombre' : nombre,
      'dosis' : dosis,
      'hora_toma' : horaToma,
      'numero_compartimento' : numeroCompartimento,
      'frecuencia' : frecuencia,
      'esta_completado' : estaCompletado,
    };
  }
}