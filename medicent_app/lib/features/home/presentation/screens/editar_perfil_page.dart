import 'package:flutter/material.dart';
import 'home_page.dart';
import 'tratamiento_page.dart';
import '../../../auth/presentation/screens/login_page.dart';
import '../../../auth/presentation/screens/landing_page.dart';

class EditarPerfilPage extends StatefulWidget {
  const EditarPerfilPage({super.key});

  @override
  State<EditarPerfilPage> createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<EditarPerfilPage> {
  final _formKey = GlobalKey<FormState>();

  // Controladores con los datos simulados de tu maqueta
  final TextEditingController _nombreController = TextEditingController(text: 'Admin Admin');
  final TextEditingController _correoController = TextEditingController(text: 'adminmedicent@gmail.com');
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _emergenciaController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    _telefonoController.dispose();
    _edadController.dispose();
    _emergenciaController.dispose();
    super.dispose();
  }

  // Widget reutilizable para los títulos de los inputs
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF4A5568),
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  // Widget reutilizable para los campos de texto con soporte de solo lectura
  Widget _buildTextField(TextEditingController controller, {String? hint, TextInputType? keyboardType, bool readOnly = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      style: TextStyle(color: readOnly ? Colors.black54 : Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black38),
        filled: true,
        fillColor: readOnly ? const Color(0xFFF1F5F9) : Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: readOnly ? Colors.transparent : const Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: readOnly ? Colors.transparent : const Color(0xFF1B3B5A), width: 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color navDarkBlue = const Color(0xFF1B3B5A);
    final Color bgColor = const Color(0xFFF4F8FA);
    final Color btnTeal = const Color(0xFF1E7B7D);

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
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage())),
            child: const Text('Cerrar sesión', style: TextStyle(color: Colors.white))
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: [
          // Área principal (Formulario de Perfil)
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Editar Perfil',
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 20),

                        _buildLabel('NOMBRE COMPLETO'),
                        _buildTextField(_nombreController, readOnly: true),

                        _buildLabel('CORREO ELECTRÓNICO'),
                        _buildTextField(_correoController, keyboardType: TextInputType.emailAddress),

                        _buildLabel('TELÉFONO DE CONTACTO'),
                        _buildTextField(_telefonoController, keyboardType: TextInputType.phone),

                        _buildLabel('EDAD'),
                        _buildTextField(_edadController, keyboardType: TextInputType.number), // <--- Le quitamos el readOnly

                        _buildLabel('CONTACTO DE EMERGENCIA'),
                        _buildTextField(_emergenciaController, hint: 'Ej: Maria Perez - 3123456789', readOnly: true),

                        const SizedBox(height: 40),

                        // Botón Guardar Cambios
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: btnTeal,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Perfil actualizado exitosamente', style: TextStyle(fontWeight: FontWeight.bold)),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              Navigator.pop(context); // Regresa al Dashboard
                            },
                            child: const Text(
                              'Guardar Cambios',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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