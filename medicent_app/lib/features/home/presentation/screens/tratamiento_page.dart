import 'package:flutter/material.dart';
import 'package:medicent_app/features/auth/presentation/providers/medicamento_provider.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'registrar_toma_page.dart';
import '../../../auth/presentation/screens/login_page.dart';
import '../../../auth/presentation/screens/register_page.dart';


class TratamientoPage extends StatefulWidget {
  const TratamientoPage({super.key});

  @override
  State<TratamientoPage> createState() => _TratamientoPageState();
}

class _TratamientoPageState extends State<TratamientoPage> {
  final Color navDarkBlue = const Color(0xFF1B3B5A);
  final Color bgColor = const Color(0xFFF4F8FA);

  @override
  void initState() {
    super.initState();
    // Apenas carga la pantalla, consultamos los medicamentos desde MySQL Workbench
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MedicamentoProvider>(context, listen: false).cargarMedicamentos();
    });
  }

  void _mostrarModalAgregar(BuildContext context) {
    final TextEditingController _nombreController = TextEditingController();
    final TextEditingController _dosisController = TextEditingController();
    final TextEditingController _frecuenciaController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Registrar Medicamento'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre del Medicamento (ej. prueba)'),
                ),
                TextField(
                  controller: _dosisController,
                  decoration: const InputDecoration(labelText: 'Dosis/Concentración (ej. 500 o 1)'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _frecuenciaController,
                  decoration: const InputDecoration(labelText: 'Frecuencia diaria (ej. 8)'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: navDarkBlue, foregroundColor: Colors.white),
              onPressed: () async {
                final nombre = _nombreController.text.trim();
                final concentracion = double.tryParse(_dosisController.text) ?? 1.0;
                final frecuencia = int.tryParse(_frecuenciaController.text) ?? 1;

                if (nombre.isNotEmpty) {
                  final medProvider = Provider.of<MedicamentoProvider>(context, listen: false);
                  
                  bool exito = await medProvider.agregarMedicamento(
                    nombre: nombre,
                    concentracion: concentracion,
                    frecuenciaDiaria: frecuencia,
                    fechaVencimiento: '2026-12-31', 
                    idTratamiento: 1, 
                    idTipoMedicamento: 1,
                    idViaAdministracion: 1,
                    idStock: 1,
                  );

                  if (mounted) {
                    Navigator.pop(context);
                    if (exito) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('¡Guardado en Workbench exitosamente!'), backgroundColor: Colors.green),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Error al guardar en el servidor'), backgroundColor: Colors.red),
                      );
                    }
                  }
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.55),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage())),
                    child: const Text('Dashboard', style: TextStyle(color: Colors.white)),
                  ),
                  TextButton(
                    onPressed: () {}, // ⚠️ BOTÓN VACÍO: Ya estamos en Tratamiento
                    child: const Text('Tratamiento', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RegistrarTomaPage())),
                    child: const Text('Registrar Toma', style: TextStyle(color: Colors.white)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RegisterPage())),
                    child: const Text('Registrarse', style: TextStyle(color: Colors.white)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage())),
                    child: const Text('Iniciar sesión', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Tratamiento',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'Medicamentos registrados en la base de datos',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 30),

              Expanded(
                child: Consumer<MedicamentoProvider>(
                  builder: (context, medProvider, child) {
                    if (medProvider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final lista = medProvider.medicamentos;

                    if (lista.isEmpty) {
                      return const Center(
                        child: Text('No hay medicamentos registrados en el sistema.'),
                      );
                    }

                    return ListView.builder(
                      itemCount: lista.length,
                      itemBuilder: (context, index) {
                        final item = lista[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: const Icon(Icons.medication, color: Color(0xFF1B3B5A)),
                            title: Text(item['nombre']?.toString() ?? 'Sin nombre', style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('Dosis: ${item['concentracion']} | Frecuencia: Cada ${item['frecuenciaDiaria']}h'),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => _mostrarModalAgregar(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar Medicamento', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}