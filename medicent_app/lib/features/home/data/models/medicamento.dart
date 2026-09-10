class Medicamento {
  final String medicamento;
  final String dosis;
  final String frecuencia;

  Medicamento({
    required this.medicamento,
    required this.dosis,
    required this.frecuencia,
  });

  factory Medicamento.fromMap(Map<String, dynamic> map) {
    return Medicamento(
      medicamento: map['medicamento'] as String,
      dosis: map['dosis'] as String,
      frecuencia: map['frecuencia'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'medicamento': medicamento,
      'dosis': dosis,
      'frecuencia': frecuencia,
    };
  }
}