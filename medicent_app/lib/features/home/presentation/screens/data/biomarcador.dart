class TipoBiomarcador {
  final String id;
  final String label;
  final String unidad;
  final double min;
  final double max;

  const TipoBiomarcador({
    required this.id,
    required this.label,
    required this.unidad,
    required this.min,
    required this.max,
  });
}

const tiposBiomarcador = <TipoBiomarcador>[
  TipoBiomarcador(id: 'fc', label: 'Frecuencia Cardíaca', unidad: 'lpm', min: 60, max: 100),
  TipoBiomarcador(id: 'spo2', label: 'Saturación de Oxígeno (SpO2)', unidad: '%', min: 95, max: 100),
  TipoBiomarcador(id: 'temp', label: 'Temperatura', unidad: '°C', min: 36.1, max: 37.2),
  TipoBiomarcador(id: 'glucosa', label: 'Glucosa', unidad: 'mg/dL', min: 70, max: 100),
];

TipoBiomarcador? tipoPorId(String id) {
  for (final t in tiposBiomarcador) {
    if (t.id == id) return t;
  }
  return null;
}

class Biomarcador {
  final String? id;
  final String tipo;
  final String nombre;
  final double valor;
  final String unidad;
  final String fecha;
  final String hora;
  final String estado;
  final String notas;

  const Biomarcador({
    this.id,
    required this.tipo,
    required this.nombre,
    required this.valor,
    required this.unidad,
    required this.fecha,
    required this.hora,
    required this.estado,
    this.notas = '',
  });

  bool get esAlerta => estado == 'alerta';

  factory Biomarcador.fromJson(Map<String, dynamic> json) {
    final valorRaw = json['valor'];
    final valor = valorRaw is num
        ? valorRaw.toDouble()
        : double.tryParse('${valorRaw ?? ''}') ?? 0;

    return Biomarcador(
      id: json['id']?.toString(),
      tipo: json['tipo']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      valor: valor,
      unidad: json['unidad']?.toString() ?? '',
      fecha: json['fecha']?.toString() ?? '',
      hora: json['hora']?.toString() ?? '',
      estado: json['estado']?.toString() ?? 'desconocido',
      notas: json['notas']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tipo': tipo,
      'nombre': nombre,
      'valor': valor,
      'unidad': unidad,
      'fecha': fecha,
      'hora': hora,
      'estado': estado,
      'notas': notas,
    };
  }

  static String calcularEstado(String tipo, double valor) {
    final t = tipoPorId(tipo);
    if (t == null) return 'desconocido';
    return (valor >= t.min && valor <= t.max) ? 'bueno' : 'alerta';
  }
}