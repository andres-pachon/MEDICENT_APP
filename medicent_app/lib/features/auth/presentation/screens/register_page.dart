import 'package:flutter/material.dart';
// IMPORTANTE: Ajusta esta ruta si completador_perfil_page.dart está en otra carpeta
import '../../../home/presentation/screens/completar_perfil_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _documentoController = TextEditingController();
  final _fechaController = TextEditingController();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  final _confirmarController = TextEditingController();

  String _idTipoDocumento = '1';
  String? _errorMessage;
  bool _isLoading = false;

  final Color navDarkBlue = const Color(0xFF1B3B5A);
  final Color btnTeal = const Color(0xFF1E7B7D);
  final Color bgColor = const Color(0xFFF4F8FA);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: btnTeal, onPrimary: Colors.white, onSurface: Colors.black),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _fechaController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _handleSubmit() async {
    setState(() => _errorMessage = null);

    if (_contrasenaController.text != _confirmarController.text) {
      setState(() => _errorMessage = 'Las contraseñas no coinciden.');
      return;
    }
    if (_contrasenaController.text.length < 6) {
      setState(() => _errorMessage = 'La contraseña debe tener al menos 6 caracteres.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final Map<String, dynamic> formData = {
        "nombre": _nombreController.text.trim(),
        "apellido": _apellidoController.text.trim(),
        "correo": _correoController.text.trim(),
        "password": _contrasenaController.text,
        "idTipoDocumento": int.parse(_idTipoDocumento),
        "documento": _documentoController.text.trim(),
        "fechaNacimiento": _fechaController.text,
      };

      // Simulación de envío backend
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Registro exitoso! Por favor completa tu perfil.'), backgroundColor: Colors.green),
        );
        // REDIRECCIÓN A LA PANTALLA DE COMPLETAR PERFIL EN LUGAR DE CERRAR
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CompletarPerfilPage()),
        );
      }
    } catch (err) {
      setState(() => _errorMessage = 'No se pudo registrar. Verifica que el backend esté corriendo.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: navDarkBlue,
        elevation: 0,
        title: const Text(
          'MEDICENT',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Registrarse', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Iniciar sesión', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 450),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Registrarse',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 20),
                      _buildInputLabel('NOMBRE'),
                      _buildTextField(controller: _nombreController, hintText: 'Ingrese su nombre'),
                      const SizedBox(height: 14),
                      _buildInputLabel('APELLIDO'),
                      _buildTextField(controller: _apellidoController, hintText: 'Ingrese su apellido'),
                      const SizedBox(height: 14),
                      _buildInputLabel('TIPO DE DOCUMENTO'),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _idTipoDocumento,
                            isExpanded: true,
                            items: const [
                              DropdownMenuItem(value: '1', child: Text('Cédula de Ciudadanía')),
                              DropdownMenuItem(value: '2', child: Text('Tarjeta de Identidad')),
                              DropdownMenuItem(value: '3', child: Text('Cédula de Extranjería')),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _idTipoDocumento = val);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      _buildInputLabel('NÚMERO DE DOCUMENTO'),
                      _buildTextField(
                        controller: _documentoController,
                        hintText: 'Ingrese su documento',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 14),
                      _buildInputLabel('FECHA DE NACIMIENTO'),
                      _buildTextField(
                        controller: _fechaController,
                        hintText: 'dd/mm/aaaa',
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        suffixIcon: const Icon(Icons.calendar_month_outlined, size: 20, color: Colors.black54),
                      ),
                      const SizedBox(height: 14),
                      _buildInputLabel('CORREO'),
                      _buildTextField(
                        controller: _correoController,
                        hintText: 'Ingrese su correo',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 14),
                      _buildInputLabel('CONTRASEÑA'),
                      _buildTextField(
                        controller: _contrasenaController,
                        hintText: 'Mínimo 6 caracteres',
                        obscureText: true,
                      ),
                      const SizedBox(height: 14),
                      _buildInputLabel('CONFIRMAR CONTRASEÑA'),
                      _buildTextField(
                        controller: _confirmarController,
                        hintText: 'Repita la contraseña',
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: btnTeal,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                )
                              : const Text('Confirmar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Text('¿Ya tienes una cuenta? ', style: TextStyle(color: Colors.black87, fontSize: 14)),
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              'Inicia sesión',
                              style: TextStyle(color: btnTeal, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black26, fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      color: navDarkBlue,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Inicio', style: TextStyle(color: Colors.white, fontSize: 13)),
          SizedBox(width: 24),
          Text('Dashboard', style: TextStyle(color: Colors.white, fontSize: 13)),
          SizedBox(width: 24),
          Text('Contacto', style: TextStyle(color: Colors.white, fontSize: 13)),
        ],
      ),
    );
  }
}