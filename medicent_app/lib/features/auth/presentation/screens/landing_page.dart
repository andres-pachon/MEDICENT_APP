import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';

// Colores base extraídos de tu diseño original
const Color navDarkBlue = Color(0xFF1B3B5A);
const Color btnTeal = Color(0xFF1E7B7D);
const Color bgColor = Color(0xFFF4F8FA);

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

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
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage()));
            },
            child: const Text('Registrarse', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
            },
            child: const Text('Iniciar sesión', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            _buildHeroBanner(),
            const SizedBox(height: 60),
            _buildFeaturesSection(),
            const SizedBox(height: 60),
            _buildSharedAccessBanner(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // 1. Banner Principal (Azul oscuro con bordes redondeados)
  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 1000), // Limita el ancho en pantallas grandes
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 40.0),
      decoration: BoxDecoration(
        color: navDarkBlue,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MEDICENT',
            style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'El lugar para cuidar de tu salud.\nRecuerda que tu salud es primero',
            style: TextStyle(color: Colors.white, fontSize: 18, height: 1.5),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black, // Color oscuro del botón original
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text('Comienza ahora', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // 2. Sección de los 3 íconos de beneficios
  Widget _buildFeaturesSection() {
    return Column(
      children: [
        const Text(
          '¿Qué encontrarás en Medicent?',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 50),
        Wrap(
          spacing: 40,
          runSpacing: 40,
          alignment: WrapAlignment.center,
          children: [
            _buildFeatureItem(
              icon: Icons.receipt_long_outlined,
              title: 'Gestión y control de tus\nmedicamentos',
              description: 'Solo necesitas la fórmula, la cual será escaneada\nextrayendo datos como nombre, dosis,\nfrecuencia, horario y duración del tratamiento.',
            ),
            _buildFeatureItem(
              icon: Icons.monitor_heart_outlined,
              title: 'Gestión de tus biomarcadores',
              description: 'Registra valores importantes de tu salud, como\npresión arterial, frecuencia cardíaca, nivel de\nglucosa, temperatura u otros indicadores.',
            ),
            _buildFeatureItem(
              icon: Icons.gpp_maybe_outlined,
              title: 'Validación de seguridad',
              description: 'Nuestras validaciones evitarán errores en dosis o\nen la combinación de medicamentos.',
            ),
          ],
        ),
      ],
    );
  }

  // Tarjeta individual para cada beneficio
  Widget _buildFeatureItem({required IconData icon, required String title, required String description}) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(icon, size: 70, color: Colors.black87),
          const SizedBox(height: 24),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
          ),
        ],
      ),
    );
  }

  // 3. Banner final de Acceso Compartido
  Widget _buildSharedAccessBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 40.0),
      color: navDarkBlue,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 40,
            children: [
              SizedBox(
                width: 600,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Acceso compartido con cuidadores y familiares',
                      style: TextStyle(color: Colors.white, fontSize: 28, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Autoriza a un familiar o cuidador para que acceda a tu información de medicación y seguimiento. De esta forma, podrán recibir notificaciones, verificar el cumplimiento del tratamiento y brindarte apoyo.',
                      style: TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text('Comenzar acceso compartido', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.favorite_border, size: 180, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  // 4. Pie de página (Footer)
  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      color: navDarkBlue,
      padding: const EdgeInsets.symmetric(vertical: 24),
      margin: const EdgeInsets.only(top: 2), // Una pequeña separación visual si es necesaria
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Inicio', style: TextStyle(color: Colors.white, fontSize: 14)),
          SizedBox(width: 32),
          Text('Dashboard', style: TextStyle(color: Colors.white, fontSize: 14)),
          SizedBox(width: 32),
          Text('Contacto', style: TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }
}