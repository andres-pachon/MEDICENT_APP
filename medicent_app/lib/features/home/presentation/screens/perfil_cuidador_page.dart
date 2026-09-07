import 'package:flutter/material.dart';
import 'home_page.dart';
import '../../../auth/presentation/screens/login_page.dart';
import '../../../auth/presentation/screens/landing_page.dart';

class PerfilCuidadorPage extends StatelessWidget {
  const PerfilCuidadorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color navDarkBlue = const Color(0xFF1B3B5A);
    final Color bgColor = const Color(0xFFF4F8FA);
    final Color btnTeal = const Color(0xFF1E7B7D);

    Widget _buildInfoRow(String title, String value) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
        ),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 16, color: Colors.black87),
            children: [
              TextSpan(text: '$title: ', style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: value),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: navDarkBlue,
        elevation: 0,
        title: const Text('MEDICENT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        actions: [
          TextButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage())), child: const Text('Dashboard', style: TextStyle(color: Colors.white))),
          TextButton(onPressed: () {}, child: const Text('Tratamiento', style: TextStyle(color: Colors.white))),
          TextButton(onPressed: () {}, child: const Text('Biomarcadores', style: TextStyle(color: Colors.white))),
          TextButton(onPressed: () {}, child: const Text('Registrarse', style: TextStyle(color: Colors.white))),
          TextButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage())), child: const Text('Iniciar sesión', style: TextStyle(color: Colors.white))),
          const SizedBox(width: 20),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Título
          Padding(
            padding: const EdgeInsets.only(left: 24.0, top: 20.0),
            child: Text(
              'Mi Perfil de Cuidador',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Avatar Circle
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: btnTeal,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
                        ],
                      ),
                      child: const Icon(Icons.person, size: 60, color: Color(0xFF6B21A8)), // Color púrpura del ícono como en la imagen
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Info Rows
                  _buildInfoRow('Nombre', 'Carlos Mendoza'),
                  _buildInfoRow('Experiencia', '5 años en enfermería geriátrica'),
                  _buildInfoRow('Teléfono', '315 987 6543'),
                  _buildInfoRow('Estado', 'Disponible'),

                  const SizedBox(height: 30),
                  
                  // Botón Editar
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: btnTeal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {
                          // Acción de editar
                        },
                        child: const Text('Editar Perfil', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
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
                TextButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage())), child: const Text('Dashboard', style: TextStyle(color: Colors.white, fontSize: 14))),
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