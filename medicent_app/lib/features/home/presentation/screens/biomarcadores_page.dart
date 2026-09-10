import 'package:flutter/material.dart';
import '../../data/models/biomarcador.dart';
import '../../data/services/biomarcador_service.dart';

const Color navDarkBlue = Color(0xFF1B3B5A);
const Color btnTeal = Color(0xFF1E7B7D);
const Color bgColor = Color(0xFFF4F8FA);
const Color buenoColor = Color(0xFF16A34A);
const Color alertaColor = Color(0xFFDC2626);

const mesesEs = [
  'enero',
  'febrero',
  'marzo',
  'abril',
  'mayo',
  'junio',
  'julio',
  'agosto',
  'septiembre',
  'octubre',
  'noviembre',
  'diciembre',
];

class BiomarcadoresPage extends StatefulWidget {
  const BiomarcadoresPage({super.key});

  @override
  State<BiomarcadoresPage> createState() => _BiomarcadoresPageState();
}

class _BiomarcadoresPageState extends State<BiomarcadoresPage> {
  final _service = BiomarcadorService();
  List<Biomarcador> _hoy = [];
  List<Biomarcador> _mes = [];
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final resultados = await Future.wait([
        _service.getBiomarcadoresHoy(),
        _service.getBiomarcadores(),
      ]);
      if (!mounted) return;
      setState(() {
        _hoy = resultados[0];
        _mes = resultados[1];
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _cargando = false;
        _error = 'No se pudo conectar al servidor. ¿Está corriendo el backend?';
      });
    }
  }

  String? get _estadoPaciente {
    if (_hoy.isEmpty) return null;
    final hayAlerta = _hoy.any((b) {
      final t = tipoPorId(b.tipo);
      if (t == null) return b.esAlerta;
      return b.valor < t.min || b.valor > t.max;
    });
    return hayAlerta ? 'ALERTA' : 'BUENO';
  }

  Future<void> _abrirRegistro() async {
    final guardado = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _RegistroBiomarcadorSheet(),
    );
    if (guardado == true) {
      await _cargarDatos();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ahora = DateTime.now();
    final mesTitulo = '${mesesEs[ahora.month - 1]} ${ahora.year}';

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: navDarkBlue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'MEDICENT',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: RefreshIndicator(
        color: btnTeal,
        onRefresh: _cargarDatos,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          children: [
            const Text(
              'Biomarcadores',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _abrirRegistro,
                icon: const Icon(Icons.add, size: 20),
                label: const Text(
                  'Registrar Nuevo Biomarcador',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: navDarkBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildHoyCard(),
            const SizedBox(height: 20),
            _buildMesCard(mesTitulo, ahora),
          ],
        ),
      ),
    );
  }

  Widget _buildHoyCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Biomarcadores hoy',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          if (_estadoPaciente != null) ...[
            const SizedBox(height: 10),
            Text.rich(
              TextSpan(
                text: 'Estado del paciente: ',
                style: const TextStyle(fontSize: 15, color: Colors.black87),
                children: [
                  TextSpan(
                    text: _estadoPaciente,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _estadoPaciente == 'BUENO' ? buenoColor : alertaColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          if (_cargando)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator(color: btnTeal)),
            )
          else if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  Text(_error!, style: const TextStyle(color: Colors.black54), textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  TextButton(onPressed: _cargarDatos, child: const Text('Reintentar')),
                ],
              ),
            )
          else if (_hoy.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text(
                  'No hay mediciones registradas hoy.',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            )
          else
            ..._hoy.map((b) => _MedicionCard(biomarcador: b)),
        ],
      ),
    );
  }

  Widget _buildMesCard(String mesTitulo, DateTime ahora) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Biomarcadores en el mes',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            mesTitulo[0].toUpperCase() + mesTitulo.substring(1),
            style: const TextStyle(fontSize: 16, color: navDarkBlue, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          _CalendarioMes(
            fecha: ahora,
            mediciones: _mes,
            onDiaTap: _mostrarDia,
          ),
        ],
      ),
    );
  }

  void _mostrarDia(DateTime dia, List<Biomarcador> mediciones) {
    final fecha =
        '${dia.day.toString().padLeft(2, '0')}/${dia.month.toString().padLeft(2, '0')}/${dia.year}';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Mediciones del $fecha'),
        content: mediciones.isEmpty
            ? const Text('Sin mediciones este día.')
            : SizedBox(
                width: 320,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: mediciones
                      .map(
                        (b) => ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text(b.nombre, style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text('${b.valor} ${b.unidad} · ${b.hora}'),
                          trailing: Text(
                            b.esAlerta ? 'ALERTA' : 'BUENO',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: b.esAlerta ? alertaColor : buenoColor,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cerrar')),
        ],
      ),
    );
  }
}

class _MedicionCard extends StatelessWidget {
  final Biomarcador biomarcador;
  const _MedicionCard({required this.biomarcador});

  @override
  Widget build(BuildContext context) {
    final t = tipoPorId(biomarcador.tipo);
    final alerta = biomarcador.esAlerta ||
        (t != null && (biomarcador.valor < t.min || biomarcador.valor > t.max));

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border(
          left: BorderSide(color: alerta ? alertaColor : navDarkBlue, width: 5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(biomarcador.nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 4),
          Text.rich(
            TextSpan(
              text: '${_fmt(biomarcador.valor)}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: navDarkBlue),
              children: [
                TextSpan(
                  text: ' ${biomarcador.unidad}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(' ${biomarcador.hora}', style: const TextStyle(color: Colors.black54, fontSize: 13)),
          if (t != null)
            Text(
              'Rango: ${t.min}–${t.max} ${t.unidad}',
              style: const TextStyle(fontSize: 12, color: Colors.black45),
            ),
          if (alerta)
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text('Peligro fuera del rango normal', style: TextStyle(color: alertaColor, fontWeight: FontWeight.w600)),
            ),
          if (biomarcador.notas.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(biomarcador.notas, style: const TextStyle(fontSize: 13, color: Colors.black87)),
            ),
        ],
      ),
    );
  }

  String _fmt(double v) => v % 1 == 0 ? v.toInt().toString() : v.toString();
}

class _CalendarioMes extends StatelessWidget {
  final DateTime fecha;
  final List<Biomarcador> mediciones;
  final void Function(DateTime dia, List<Biomarcador> mediciones) onDiaTap;

  const _CalendarioMes({
    required this.fecha,
    required this.mediciones,
    required this.onDiaTap,
  });

  @override
  Widget build(BuildContext context) {
    final year = fecha.year;
    final month = fecha.month;
    final totalDias = DateTime(year, month + 1, 0).day;
    final primerWeekday = DateTime(year, month, 1).weekday;
    final celdasVacias = primerWeekday - 1;

    final porFecha = <String, List<Biomarcador>>{};
    for (final b in mediciones) {
      porFecha.putIfAbsent(b.fecha, () => []).add(b);
    }

    final diasSemana = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

    return Column(
      children: [
        Row(
          children: diasSemana
              .map(
                (d) => Expanded(
                  child: Center(
                    child: Text(d, style: const TextStyle(fontWeight: FontWeight.bold, color: navDarkBlue, fontSize: 12)),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: celdasVacias + totalDias,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
          ),
          itemBuilder: (context, index) {
            if (index < celdasVacias) return const SizedBox.shrink();
            final dia = index - celdasVacias + 1;
            final fechaIso =
                '$year-${month.toString().padLeft(2, '0')}-${dia.toString().padLeft(2, '0')}';
            final lista = porFecha[fechaIso] ?? [];
            final hayAlerta = lista.any((b) => b.esAlerta);
            final hayDatos = lista.isNotEmpty;

            Color bg = Colors.white;
            Color fg = Colors.black87;
            if (hayDatos) {
              bg = hayAlerta ? const Color(0xFFFECACA) : const Color(0xFFBBF7D0);
              fg = hayAlerta ? alertaColor : const Color(0xFF166534);
            }

            return InkWell(
              onTap: () => onDiaTap(DateTime(year, month, dia), lista),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('$dia', style: TextStyle(fontWeight: FontWeight.w600, color: fg, fontSize: 13)),
                    if (hayDatos)
                      Text(hayAlerta ? 'alert' : 'bien', style: const TextStyle(fontSize: 10)),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _RegistroBiomarcadorSheet extends StatefulWidget {
  const _RegistroBiomarcadorSheet();

  @override
  State<_RegistroBiomarcadorSheet> createState() => _RegistroBiomarcadorSheetState();
}

class _RegistroBiomarcadorSheetState extends State<_RegistroBiomarcadorSheet> {
  final _service = BiomarcadorService();
  final _valorController = TextEditingController();
  final _notasController = TextEditingController();
  String? _tipoId;
  DateTime _fechaHora = DateTime.now();
  String? _error;
  bool _guardando = false;

  @override
  void dispose() {
    _valorController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  TipoBiomarcador? get _tipo => _tipoId == null ? null : tipoPorId(_tipoId!);

  String get _fechaHoraTexto {
    final f = _fechaHora;
    return '${f.day.toString().padLeft(2, '0')}/${f.month.toString().padLeft(2, '0')}/${f.year}  '
        '${f.hour.toString().padLeft(2, '0')}:${f.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _pickFechaHora() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fechaHora,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: btnTeal, onPrimary: Colors.white),
          ),
          child: child!,
        );
      },
    );
    if (fecha == null || !mounted) return;
    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_fechaHora),
    );
    if (!mounted) return;
    setState(() {
      _fechaHora = DateTime(
        fecha.year,
        fecha.month,
        fecha.day,
        hora?.hour ?? _fechaHora.hour,
        hora?.minute ?? _fechaHora.minute,
      );
    });
  }

  Future<void> _guardar() async {
    setState(() => _error = null);
    if (_tipoId == null) {
      setState(() => _error = 'Selecciona un tipo de biomarcador.');
      return;
    }
    final valor = double.tryParse(_valorController.text.replaceAll(',', '.'));
    if (valor == null) {
      setState(() => _error = 'Ingresa un valor.');
      return;
    }

    final tipo = _tipo!;
    final bio = Biomarcador(
      tipo: tipo.id,
      nombre: tipo.label,
      valor: valor,
      unidad: tipo.unidad,
      fecha:
          '${_fechaHora.year}-${_fechaHora.month.toString().padLeft(2, '0')}-${_fechaHora.day.toString().padLeft(2, '0')}',
      hora:
          '${_fechaHora.hour.toString().padLeft(2, '0')}:${_fechaHora.minute.toString().padLeft(2, '0')}',
      estado: Biomarcador.calcularEstado(tipo.id, valor),
      notas: _notasController.text.trim(),
    );

    setState(() => _guardando = true);
    try {
      await _service.crearBiomarcador(bio);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _guardando = false;
        _error = 'Error al guardar el biomarcador.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const Center(
                child: Text(
                  'Registrar Nuevo Biomarcador',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: navDarkBlue),
                ),
              ),
              const SizedBox(height: 20),
              _label('Tipo de Biomarcador'),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: _box(),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _tipoId,
                    hint: const Text('Seleccionar...'),
                    isExpanded: true,
                    items: tiposBiomarcador
                        .map(
                          (t) => DropdownMenuItem(
                            value: t.id,
                            child: Text('${t.label} (${t.unidad})'),
                          ),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => _tipoId = val),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _label('Valor'),
              TextField(
                controller: _valorController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: _inputDecoration('Ejemplo: 72'),
              ),
              const SizedBox(height: 14),
              _label('Fecha y Hora'),
              InkWell(
                onTap: _pickFechaHora,
                child: InputDecorator(
                  decoration: _inputDecoration(''),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month_outlined, size: 20, color: Colors.black54),
                      const SizedBox(width: 8),
                      Text(_fechaHoraTexto),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _label('Notas (opcional)'),
              TextField(
                controller: _notasController,
                maxLines: 3,
                decoration: _inputDecoration('Observaciones...'),
              ),
              if (_tipo != null) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFA7F3D0)),
                  ),
                  child: Text(
                    ' Rango normal: ${_tipo!.min} – ${_tipo!.max} ${_tipo!.unidad}',
                    style: const TextStyle(color: Color(0xFF065F46), fontSize: 14),
                  ),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 10),
                Text(_error!, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ],
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _guardando ? null : () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black54,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _guardando ? null : _guardar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: navDarkBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      child: _guardando
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text('Guardar Medición', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, color: navDarkBlue, fontSize: 13),
      ),
    );
  }

  BoxDecoration _box() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE2E8F0)),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black26, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: btnTeal, width: 1.5),
      ),
    );
  }
}