import 'package:flutter/material.dart';
import 'home_page.dart';
import 'perfil_cuidador_page.dart'; // <--- Nueva pantalla que crearemos ahora
import '../../../auth/presentation/screens/login_page.dart';
import '../../../auth/presentation/screens/landing_page.dart';

class CompletarPerfilPage extends StatefulWidget {
  const CompletarPerfilPage({super.key});

  @override
  State<CompletarPerfilPage> createState() => _CompletarPerfilPageState();
}

class _CompletarPerfilPageState extends State<CompletarPerfilPage> {
  // 0: Selección, 1: Datos Personales (Paciente), 2: Datos Médicos (Paciente), 3: Datos Profesionales (Cuidador)
  int _pasoActual = 0; 
  final _formKey = GlobalKey<FormState>();

  // Controladores Paciente (Pasos 1 y 2)
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _emergenciaController = TextEditingController();
  final TextEditingController _epsController = TextEditingController();
  final TextEditingController _alergiasController = TextEditingController();
  final TextEditingController _diagnosticoController = TextEditingController();

  // Controladores Cuidador (Paso 3)
  final TextEditingController _docCuidadorController = TextEditingController();
  final TextEditingController _expCuidadorController = TextEditingController();
  final TextEditingController _telCuidadorController = TextEditingController();

  final Color navDarkBlue = const Color(0xFF1B3B5A);
  final Color bgColor = const Color(0xFFF4F8FA);
  final Color btnTeal = const Color(0xFF1E7B7D);

  @override
  void dispose() {
    _telefonoController.dispose();
    _edadController.dispose();
    _emergenciaController.dispose();
    _epsController.dispose();
    _alergiasController.dispose();
    _diagnosticoController.dispose();
    _docCuidadorController.dispose();
    _expCuidadorController.dispose();
    _telCuidadorController.dispose();
    super.dispose();
  }

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

  Widget _buildTextField(TextEditingController controller, String hint, {TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black26),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: navDarkBlue, width: 2),
        ),
      ),
      validator: (value) => value == null || value.isEmpty ? 'Este campo es requerido' : null,
    );
  }

  // --- VISTA 0: SELECCIÓN DE PERFIL ---
  Widget _buildSeleccionPerfil() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Selecciona tu perfil', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Para darte la mejor experiencia, dinos quién eres:', style: TextStyle(fontSize: 16, color: Colors.black54)),
        const SizedBox(height: 30),
        
        // Tarjeta Paciente
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              const Text('Paciente', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'serif')),
              const SizedBox(height: 12),
              const Text('Busco registrar mis datos médicos, tratamientos y conectar con un cuidador.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: btnTeal,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => setState(() => _pasoActual = 1), // Avanza a Datos Paciente
                  child: const Text('Soy Paciente', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Tarjeta Cuidador
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              const Text('Cuidador', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'serif')),
              const SizedBox(height: 12),
              const Text('Ofrezco mis servicios para atender a personas en tratamiento.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: btnTeal,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => setState(() => _pasoActual = 3), // Avanza a Datos Cuidador
                  child: const Text('Soy Cuidador', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- VISTA 1: DATOS PERSONALES (PACIENTE) ---
  Widget _buildDatosPersonales() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text('Datos Personales del Paciente', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: navDarkBlue)),
          ),
          const SizedBox(height: 30),
          
          _buildLabel('TELÉFONO DE CONTACTO'),
          _buildTextField(_telefonoController, 'Ej: 3101234567', keyboardType: TextInputType.phone),

          _buildLabel('EDAD'),
          _buildTextField(_edadController, 'Ej: 45', keyboardType: TextInputType.number),

          _buildLabel('CONTACTO DE EMERGENCIA'),
          _buildTextField(_emergenciaController, 'Ej: Maria Perez'),

          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: btnTeal,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() => _pasoActual = 2); 
                }
              },
              child: const Text('Siguiente: Datos Médicos', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // --- VISTA 2: DATOS MÉDICOS (PACIENTE) ---
  Widget _buildDatosMedicos() {
    return Form(
      key: _formKey, 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text('Datos Médicos del Paciente', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: navDarkBlue)),
          ),
          const SizedBox(height: 30),
          
          _buildLabel('EPS / ENTIDAD DE SALUD'),
          _buildTextField(_epsController, 'Ej: Sanitas'),

          _buildLabel('ALERGIAS CONOCIDAS'),
          _buildTextField(_alergiasController, 'Ej: Ninguna, Penicilina...'),

          _buildLabel('DIAGNÓSTICO O CONDICIÓN PRINCIPAL'),
          _buildTextField(_diagnosticoController, 'Ej: Diabetes Tipo 2'),

          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: btnTeal,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registro completado con éxito'), backgroundColor: Colors.green));
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
                }
              },
              child: const Text('Finalizar Registro', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // --- VISTA 3: DATOS PROFESIONALES (CUIDADOR) ---
  Widget _buildDatosCuidador() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text('Datos Profesionales del Cuidador', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: navDarkBlue)),
          ),
          const SizedBox(height: 30),
          
          _buildLabel('DOCUMENTO DE IDENTIDAD'),
          _buildTextField(_docCuidadorController, 'Número de cédula', keyboardType: TextInputType.number),

          _buildLabel('AÑOS DE EXPERIENCIA'),
          _buildTextField(_expCuidadorController, 'Ej: 3', keyboardType: TextInputType.number),

          _buildLabel('TELÉFONO CELULAR'),
          _buildTextField(_telCuidadorController, 'Número de contacto', keyboardType: TextInputType.phone),

          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: btnTeal,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Perfil de Cuidador creado con éxito'), backgroundColor: Colors.green));
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PerfilCuidadorPage()));
                }
              },
              child: const Text('Crear Perfil de Cuidador', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: navDarkBlue,
        elevation: 0,
        title: const Text('MEDICENT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        actions: [
          TextButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage())), child: const Text('Registrarse', style: TextStyle(color: Colors.white))),
          TextButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage())), child: const Text('Iniciar sesión', style: TextStyle(color: Colors.white))),
          const SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: () {
                      if (_pasoActual == 0) return _buildSeleccionPerfil();
                      if (_pasoActual == 1) return _buildDatosPersonales();
                      if (_pasoActual == 2) return _buildDatosMedicos();
                      if (_pasoActual == 3) return _buildDatosCuidador();
                      return const SizedBox.shrink();
                    }(),
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
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                TextButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LandingPage())), child: const Text('Inicio', style: TextStyle(color: Colors.white, fontSize: 14))),
                const SizedBox(width: 24),
                TextButton(onPressed: () {}, child: const Text('Dashboard', style: TextStyle(color: Colors.white, fontSize: 14))),
                const SizedBox(width: 24),
                TextButton(onPressed: () {}, child: const Text('Contacto', style: TextStyle(color: Colors.white, fontSize: 14))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}