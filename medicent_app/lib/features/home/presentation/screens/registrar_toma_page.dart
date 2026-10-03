import 'package:flutter/material.dart';
import 'package:medicent_app/features/auth/presentation/providers/medicamento_provider.dart';
import 'package:medicent_app/features/auth/presentation/providers/toma_provider.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'tratamiento_page.dart'; 
import '../../../auth/presentation/screens/register_page.dart';


class RegistrarTomaPage extends StatefulWidget {
  const RegistrarTomaPage({super.key});

  @override
  State<RegistrarTomaPage> createState() => _RegistrarTomaPageState();
}

class _RegistrarTomaPageState extends State<RegistrarTomaPage> {
  final _formKey = GlobalKey<FormState>();
  
  String? _selectedMedicamento;
  final TextEditingController _dosisController = TextEditingController();
  final TextEditingController _notaController = TextEditingController();
  TimeOfDay? _selectedTime;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MedicamentoProvider>(context, listen: false).cargarMedicamentos();
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  void dispose() {
    _dosisController.dispose();
    _notaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color navDarkBlue = const Color(0xFF1B3B5A);
    final Color bgColor = const Color(0xFFF4F8FA);

    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: true, 
      appBar: AppBar(
        backgroundColor: navDarkBlue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'MEDICENT',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        actions: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.55),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage())),
                    child: const Text('Dashboard', style: TextStyle(color: Colors.white))
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TratamientoPage())),
                    child: const Text('Tratamiento', style: TextStyle(color: Colors.white))
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Biomarcadores', style: TextStyle(color: Colors.white))
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Registrar Toma', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RegisterPage())),
                    child: const Text('Registrarse', style: TextStyle(color: Colors.white))
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - kToolbarHeight - MediaQuery.of(context).padding.top,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                              child: Text(
                                'Registrar Toma',
                                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 40),

                            Row(
                              children: [
                                // 👇 CORRECCIÓN UI: Reducimos el ancho a 85
                                const SizedBox(
                                  width: 85,
                                  child: Text('Medicamento', style: TextStyle(fontSize: 16)),
                                ),
                                Expanded(
                                  child: Consumer<MedicamentoProvider>(
                                    builder: (context, medProvider, child) {
                                      final listaMedicamentos = medProvider.medicamentos;

                                      return DropdownButtonFormField<String>(
                                        // 👇 CORRECCIÓN UI: Evita el desbordamiento si el nombre es muy largo
                                        isExpanded: true,
                                        decoration: const InputDecoration(
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                          border: OutlineInputBorder(),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
                                        value: _selectedMedicamento,
                                        hint: Text(listaMedicamentos.isEmpty ? 'Agrega un tratamiento primero' : 'Seleccionar...'),
                                        items: listaMedicamentos.map((med) {
                                          final nombreMed = med['nombre'].toString();
                                          return DropdownMenuItem<String>(
                                            value: nombreMed,
                                            child: Text(nombreMed),
                                          );
                                        }).toList(),
                                        onChanged: listaMedicamentos.isEmpty ? null : (String? newValue) {
                                          setState(() {
                                            _selectedMedicamento = newValue;
                                          });
                                        },
                                        validator: (value) => value == null ? 'Requerido' : null,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            Row(
                              children: [
                                const SizedBox(
                                  width: 85,
                                  child: Text('Dosis *', style: TextStyle(fontSize: 16)),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: _dosisController,
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                      hintText: 'Ej: 500 mg, 1.5 ml',
                                      border: OutlineInputBorder(),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    validator: (value) => value!.isEmpty ? 'Requerido' : null,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Hora de toma', style: TextStyle(fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 8),
                                      InkWell(
                                        onTap: () => _selectTime(context),
                                        child: InputDecorator(
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                            border: OutlineInputBorder(),
                                            filled: true,
                                            fillColor: Colors.white,
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                _selectedTime == null ? '--:--' : _selectedTime!.format(context),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: _selectedTime == null ? Colors.grey : Colors.black,
                                                ),
                                              ),
                                              const Icon(Icons.access_time, size: 20),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Nota (opcional)', style: TextStyle(fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: _notaController,
                                        maxLines: 1,
                                        decoration: const InputDecoration(
                                          hintText: 'Escribe...',
                                          border: OutlineInputBorder(),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),

                            Center(
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 18),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  onPressed: _isLoading ? null : () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() => _isLoading = true);

                                      final now = DateTime.now();
                                      final fechaFormateada = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
                                      
                                      final horaFormateada = _selectedTime != null 
                                          ? "${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}" 
                                          : "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
                                      
                                      final tomaProvider = Provider.of<TomaProvider>(context, listen: false);
                                      
                                      bool exito = await tomaProvider.registrarToma(
                                        idPaciente: 1, 
                                        idMedicamento: 1, 
                                        fecha: fechaFormateada,
                                        hora: horaFormateada,
                                        dosis: _dosisController.text.trim(),
                                        nota: _notaController.text.trim(),
                                        estado: 'Programada',
                                      );

                                      setState(() => _isLoading = false);

                                      if (mounted) {
                                        if (exito) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Toma guardada en Workbench exitosamente', style: TextStyle(color: Colors.white)),
                                              backgroundColor: Colors.green,
                                              behavior: SnackBarBehavior.floating,
                                            ),
                                          );
                                          Navigator.pop(context);
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Error al guardar la toma en el servidor', style: TextStyle(color: Colors.white)),
                                              backgroundColor: Colors.red,
                                              behavior: SnackBarBehavior.floating,
                                            ),
                                          );
                                        }
                                      }
                                    }
                                  },
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                        )
                                      : const Text('Confirmar Toma', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}