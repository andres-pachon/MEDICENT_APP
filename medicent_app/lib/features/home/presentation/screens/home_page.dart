import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'registrar_toma_page.dart';
import 'tratamiento_page.dart';
import 'editar_perfil_page.dart';
import 'biomarcadores_page.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Colores base de la marca Medicent
  final Color navDarkBlue = const Color(0xFF1B3B5A);
  final Color btnTeal = const Color(0xFF1E7B7D);
  final Color bgColor = const Color(0xFFF4F8FA);

  String _horaActual = '00:00';
  bool _isLoadingTomas = true;
  List<dynamic> _tomasHoy = [];
  Map<String, dynamic>? _proximaToma;

  @override
  void initState() {
    super.initState();
    _actualizarReloj();
    // Simulamos la carga del dashboard igual que en tu versión web
    _cargarDatosDashboard();
  }

  void _actualizarReloj() {
    final ahora = DateTime.now();
    final horas = ahora.hour.toString().padLeft(2, '0');
    final minutos = ahora.minute.toString().padLeft(2, '0');
    setState(() {
      _horaActual = '$horas:$minutos';
    });
  }

  Future<void> _cargarDatosDashboard() async {
    // Aquí puedes conectar tus servicios de API para tomas de hoy y próxima toma
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _isLoadingTomas = false;
      _tomasHoy = []; // Vacío por defecto tal como en tu maqueta
      _proximaToma = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();

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
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await authProvider.logout();
            },
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Bienvenida y Reloj en tiempo real
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.account_circle, size: 40, color: Color(0xFF1D3B5E)),
                          const SizedBox(width: 12),
                          Text(
                            'Bienvenido, usuario',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: navDarkBlue),
                          ),
                        ],
                      ),
                      Text(
                        _horaActual,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: navDarkBlue),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 2. Próxima toma o aviso vacío
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Center(
                    child: Text(
                      _proximaToma != null
                          ? 'Siguiente toma: ${_proximaToma!['medicamento']}'
                          : 'No tienes tomas pendientes registradas.',
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 3. Botones de acciones rápidas (Grid 2x2)
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.5,
                  children: [
                    _buildActionButton('Registrar Toma', () async {
                      // Esperamos el resultado de la pantalla de registro
                      final resultado = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegistrarTomaPage()),
                      );

                      // Si recibimos datos válidos, actualizamos la pantalla
                      if (resultado != null && resultado is Map<String, dynamic>) {
                        setState(() {
                          _tomasHoy.add(resultado);
                        });
                      }
                    }),
                    _buildActionButton('Ver Tratamiento', () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const TratamientoPage()));
                    }),
                    _buildActionButton('Biomarcadores', () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const BiomarcadoresPage()));
                    }),
                    _buildActionButton('Editar Perfil', () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const EditarPerfilPage()));
                    }),
                  ],
                ),
                const SizedBox(height: 24),

                // 4. Mascota y chat botón
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.pets, size: 48, color: Colors.orangeAccent),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('¡Habla conmigo!', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Icon(Icons.smart_toy, color: navDarkBlue, size: 32),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // 5. Sección de Medicamentos hoy
                const Text(
                  'Medicamentos hoy',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: _tomasHoy.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              'No se han registrado tomas el día de hoy.',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                        )
                      : Column(
                          children: _tomasHoy.map((toma) {
                            return Card(
                              elevation: 0,
                              color: const Color(0xFFF8FAFC),
                              margin: const EdgeInsets.only(bottom: 8.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.medication, color: Color(0xFF1E7B7D), size: 32),
                                title: Text(
                                  '${toma['medicamento']} - ${toma['dosis']}', 
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B3B5A))
                                ),
                                subtitle: Text(
                                  toma['nota'].toString().isNotEmpty ? toma['nota'] : 'Sin notas adicionales',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                trailing: Text(
                                  toma['hora'], 
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String title, VoidCallback onTap) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: navDarkBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onTap,
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}