import 'package:flutter/material.dart';
import 'home_page.dart';
import 'registrar_toma_page.dart';
import '../../../auth/presentation/screens/login_page.dart';
import '../../../auth/presentation/screens/landing_page.dart';

// VARIABLE GLOBAL: Almacena los medicamentos para que otras vistas puedan leerlos
List<Map<String, dynamic>> medicamentosGlobales = [];

class TratamientoPage extends StatefulWidget {
  const TratamientoPage({super.key});

  @override
  State<TratamientoPage> createState() => _TratamientoPageState();
}

class _TratamientoPageState extends State<TratamientoPage> {
  final Color navDarkBlue = const Color(0xFF1B3B5A);
  final Color bgColor = const Color(0xFFF4F8FA);

  void _mostrarFormularioAgregar() {
    final formKey = GlobalKey<FormState>();
    final nombreController = TextEditingController();
    final dosisController = TextEditingController();
    final duracionController = TextEditingController();
    
    String viaAdmin = 'Oral';
    String frecuencia = 'Diario';
    TimeOfDay? horaToma;
    
    // Lista para manejar los días seleccionados
    final List<String> diasSemana = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    List<String> diasSeleccionados = [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              title: Text(
                'Agregar Medicamento',
                textAlign: TextAlign.center,
                style: TextStyle(color: navDarkBlue, fontWeight: FontWeight.bold, fontSize: 24),
              ),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 400,
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildLabel('Nombre del medicamento'),
                        TextFormField(
                          controller: nombreController,
                          decoration: const InputDecoration(hintText: 'Ej: Ibuprofeno', border: OutlineInputBorder()),
                          validator: (value) => value!.isEmpty ? 'Requerido' : null,
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('Dosis'),
                        TextFormField(
                          controller: dosisController,
                          decoration: const InputDecoration(hintText: 'Ej: 500mg, 10ml', border: OutlineInputBorder()),
                          validator: (value) => value!.isEmpty ? 'Requerido' : null,
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('Vía de administración'),
                        DropdownButtonFormField<String>(
                          value: viaAdmin,
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                          items: ['Oral', 'Intravenosa', 'Tópica', 'Inhalatoria']
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (val) => setStateDialog(() => viaAdmin = val!),
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('Hora de toma'),
                        InkWell(
                          onTap: () async {
                            final TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (picked != null) {
                              setStateDialog(() => horaToma = picked);
                            }
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(border: OutlineInputBorder()),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(horaToma == null ? '--:-- ----' : horaToma!.format(context)),
                                const Icon(Icons.access_time, size: 20),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('Duración del tratamiento'),
                        TextFormField(
                          controller: duracionController,
                          decoration: const InputDecoration(hintText: 'Ej: 1 mes, 3 semanas', border: OutlineInputBorder()),
                          validator: (value) => value!.isEmpty ? 'Requerido' : null,
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('Frecuencia'),
                        DropdownButtonFormField<String>(
                          value: frecuencia,
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                          items: ['Diario', 'Días específicos', 'Cada 8 horas', 'Cada 12 horas']
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (val) => setStateDialog(() {
                            frecuencia = val!;
                            if (frecuencia != 'Días específicos') diasSeleccionados.clear();
                          }),
                        ),
                        
                        // Aparece solo si selecciona "Días específicos"
                        if (frecuencia == 'Días específicos') ...[
                          const SizedBox(height: 16),
                          _buildLabel('Selecciona los días'),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: diasSemana.map((dia) {
                              final isSelected = diasSeleccionados.contains(dia);
                              return FilterChip(
                                label: Text(dia, style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
                                selected: isSelected,
                                selectedColor: navDarkBlue,
                                checkmarkColor: Colors.white,
                                onSelected: (bool selected) {
                                  setStateDialog(() {
                                    if (selected) {
                                      diasSeleccionados.add(dia);
                                    } else {
                                      diasSeleccionados.remove(dia);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
              actionsPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: navDarkBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // Guardar en la variable global
                      setState(() {
                        medicamentosGlobales.add({
                          'medicamento': nombreController.text,
                          'dosis': dosisController.text,
                          'frecuencia': frecuencia == 'Días específicos' && diasSeleccionados.isNotEmpty 
                                        ? diasSeleccionados.join(', ') 
                                        : frecuencia,
                        });
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Agregar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(color: navDarkBlue, fontWeight: FontWeight.bold, fontSize: 16),
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
            onPressed: () {},
            child: const Text('Tratamiento', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
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
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.account_circle, size: 40, color: Colors.black),
                          SizedBox(width: 12),
                          Text('Admin Admin', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 30),

                      const Text('Tratamiento', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text('Medicamentos registrados', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.black54)),
                      const SizedBox(height: 30),

                      // Tabla conectada a medicamentosGlobales
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: medicamentosGlobales.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.all(24.0),
                                child: Center(child: Text('No hay medicamentos registrados.', style: TextStyle(color: Colors.grey))),
                              )
                            : DataTable(
                                headingRowColor: MaterialStateProperty.all(navDarkBlue),
                                columns: const [
                                  DataColumn(label: Expanded(child: Text('Medicamento', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center))),
                                  DataColumn(label: Expanded(child: Text('Dosis', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center))),
                                  DataColumn(label: Expanded(child: Text('Frecuencia diaria', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center))),
                                ],
                                rows: medicamentosGlobales.map((t) {
                                  return DataRow(cells: [
                                    DataCell(Center(child: Text(t['medicamento']))),
                                    DataCell(Center(child: Text(t['dosis']))),
                                    DataCell(Center(child: Text(t['frecuencia']))),
                                  ]);
                                }).toList(),
                              ),
                      ),
                      const SizedBox(height: 20),

                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          icon: const Icon(Icons.add_circle_outline),
                          label: const Text('Agregar Medicamento', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          onPressed: _mostrarFormularioAgregar,
                        ),
                      ),
                    ],
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