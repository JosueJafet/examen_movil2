import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/student.dart';
import 'clase_detalle.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Estado para manejar la información del estudiante (inicialmente con datos mock)
  Student _student = Student.mockStudent();

  // Función para manejar la actualización de datos desde la pantalla de detalle
  void _updateStudentData(Student updatedStudent) {
    setState(() {
      _student = updatedStudent;
    });
  }

  // Helper para el color del rango
  Color _getRangoColor(String rango) {
    switch (rango) {
      case 'Sobresaliente':
        return Colors.green.shade700;
      case 'Aprobado':
        return Colors.blue.shade700;
      case 'Reprobado':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Cálculo del promedio general y rango
    final overallAverage = _student.calculateOverallAverage();
    final rango = _student.getRango(overallAverage);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registro de Notas',
          style: GoogleFonts.robotoCondensed(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Encabezado Centrado (Foto y Nombre)
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 70, // Más grande y centrado
                      // Carga desde URL de red
                      backgroundImage: NetworkImage(_student.profileImageUrl), 
                      backgroundColor: Colors.grey[200],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _student.name,
                      style: GoogleFonts.openSans(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    // 2. Promedio General y Rango
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blueAccent),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Promedio General: ${overallAverage.toStringAsFixed(1)}',
                            style: GoogleFonts.robotoSlab(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Rango: $rango',
                            style: GoogleFonts.lato(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: _getRangoColor(rango),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 32),
              
              // 3. Listado de Clases
              Text(
                'Clases Actuales:',
                style: GoogleFonts.robotoSlab(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _student.currentClasses.length,
                itemBuilder: (context, index) {
                  final classInfo = _student.currentClasses[index];
                  final average = classInfo.calculateFinalAverage();

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        classInfo.name,
                        style: GoogleFonts.lato(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text('Docente: ${classInfo.teacher}'),
                      trailing: Chip(
                        label: Text(
                          average.toStringAsFixed(1),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: average >= 60.0 ? Colors.green : Colors.red,
                          ),
                        ),
                        backgroundColor: average > 0.0 ? Colors.grey[100] : Colors.amber[50],
                      ),
                      onTap: () async {
                        // Navega a la pantalla de detalle usando 'clase_detalle.dart'
                        final updatedStudent = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClassDetailScreen( // Usando el nombre de tu archivo de importación
                              student: _student,
                              classInfo: classInfo,
                            ),
                          ),
                        );

                        // Si hay un resultado de actualización, actualiza el estado
                        if (updatedStudent is Student) {
                          _updateStudentData(updatedStudent);
                        }
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}