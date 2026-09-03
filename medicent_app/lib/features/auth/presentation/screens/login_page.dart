import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'register_page.dart';
import '../../../../features/home/presentation/screens/home_page.dart';
// Definimos los colores constantes fuera de la clase para evitar fallos de memoria en la recarga
const Color navDarkBlue = Color(0xFF1B3B5A);
const Color btnTeal = Color(0xFF1E7B7D);
const Color bgColor = Color(0xFFF4F8FA);

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    final authProvider = context.read<AuthProvider>();
    
    // Capturamos el resultado booleano del inicio de sesión
    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    
    setState(() => _isLoading = false);

    // Si el inicio de sesión es exitoso, navegamos a la pantalla principal
    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

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
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage()));
            },
            child: const Text('Registrarse', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Iniciar sesión', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                        'Inicio de Sesión',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 24),
                      _buildInputLabel('CORREO'),
                      _buildTextField(
                        controller: _emailController,
                        hintText: 'ejemplo@gmail.com',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      _buildInputLabel('CONTRASEÑA'),
                      _buildTextField(
                        controller: _passwordController,
                        hintText: 'Ingrese la contraseña',
                        obscureText: true,
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () {},
                          child: const Text(
                            '¿Olvidaste tu contraseña?',
                            style: TextStyle(color: btnTeal, fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (authProvider.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            authProvider.errorMessage!,
                            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: btnTeal,
                            disabledBackgroundColor: btnTeal.withOpacity(0.5),
                            foregroundColor: Colors.white,
                            disabledForegroundColor: Colors.white70,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                )
                              : const Text('Ingresar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Text('¿No tienes cuenta? ', style: TextStyle(color: Colors.black87, fontSize: 14)),
                          InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage()));
                            },
                            child: const Text(
                              'Regístrate',
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
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black26, fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
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