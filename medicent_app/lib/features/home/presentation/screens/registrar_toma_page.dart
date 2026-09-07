import 'package:flutter/material.dart';
// IMPORTANTE: Ajusta estas rutas según la ubicación exacta de tus archivos
import 'home_page.dart';
import 'tratamiento_page.dart'; // <--- Importamos la página de tratamiento para leer la variable global
import '../../../auth/presentation/screens/login_page.dart';
import '../../../auth/presentation/screens/register_page.dart';
import '../../../auth/presentation/screens/landing_page.dart';

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
      appBar: AppBar(
        backgroundColor: navDarkBlue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'MEDICENT',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        actions: [
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
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RegisterPage())),
            child: const Text('Registrarse', style: TextStyle(color: Colors.white))
          ),
          TextButton(
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage())),
            child: const Text('Iniciar sesión', style: TextStyle(color: Colors.white))
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: [
          // Área principal (Formulario)
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
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

                        // Fila: Medicamento conectada a la variable global
                        Row(
                          children: [
                            const SizedBox(
                              width: 100,
                              child: Text('Medicamento', style: TextStyle(fontSize: 16)),
                            ),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  border: OutlineInputBorder(),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                value: _selectedMedicamento,
                                hint: Text(medicamentosGlobales.isEmpty ? 'Primero agrega un tratamiento' : 'Seleccionar medicamento...'),
                                items: medicamentosGlobales.map((med) {
                                  return DropdownMenuItem<String>(
                                    value: med['medicamento'],
                                    child: Text(med['medicamento']),
                                  );
                                }).toList(),
                                onChanged: medicamentosGlobales.isEmpty ? null : (String? newValue) {
                                  setState(() {
                                    _selectedMedicamento = newValue;
                                  });
                                },
                                validator: (value) => value == null ? 'Seleccione un medicamento' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Fila: Dosis
                        Row(
                          children: [
                            const SizedBox(
                              width: 100,
                              child: Text('Dosis *', style: TextStyle(fontSize: 16)),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _dosisController,
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  hintText: 'Ej: 500 mg, 1.5 ml, 2 tabletas',
                                  border: OutlineInputBorder(),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                validator: (value) => value!.isEmpty ? 'Ingrese la dosis' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Fila dividida: Hora de Toma | Nota
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
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Nota (opcional)', style: TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _notaController,
                                    maxLines: 3,
                                    decoration: const InputDecoration(
                                      hintText: 'Escribe una nota opcional...',
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

                        // Botón Confirmar
                        Center(
                          child: SizedBox(
                            width: 250,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // 1. Recolectar los datos ingresados
                                  Map<String, dynamic> nuevaToma = {
                                    'medicamento': _selectedMedicamento,
                                    'dosis': _dosisController.text,
                                    'hora': _selectedTime != null ? _selectedTime!.format(context) : 'Sin hora',
                                    'nota': _notaController.text,
                                  };

                                  // 2. Mostrar el mensaje flotante de éxito
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Toma registrada exitosamente',
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                      backgroundColor: Colors.green,
                                      behavior: SnackBarBehavior.floating,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                  
                                  // 3. Regresar a la pantalla anterior ENVIANDO los datos
                                  Navigator.pop(context, nuevaToma);
                                }
                              },
                              child: const Text(
                                'Confirmar Toma',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
          ),
          
          // Footer
          Container(
            width: double.infinity,
            color: navDarkBlue,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LandingPage())), 
                  child: const Text('Inicio', style: TextStyle(color: Colors.white, fontSize: 16))
                ),
                const SizedBox(width: 24),
                TextButton(
                  onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage())), 
                  child: const Text('Dashboard', style: TextStyle(color: Colors.white, fontSize: 16))
                ),
                const SizedBox(width: 24),
                TextButton(
                  onPressed: () {}, 
                  child: const Text('Contacto', style: TextStyle(color: Colors.white, fontSize: 16))
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}