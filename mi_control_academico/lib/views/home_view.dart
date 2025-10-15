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

  @override
  Widget build(BuildContext context) {
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
              // Encabezado con Nombre y Foto
              Row(
                children: [
                  CircleAvatar(
  radius: 40,
  // AHORA se usa NetworkImage para cargar desde una URL
  backgroundImage: NetworkImage(_student.profileImageUrl), 
  backgroundColor: Colors.grey[200],
),
                  const SizedBox(width: 16),
                  Text(
                    _student.name,
                    style: GoogleFonts.openSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const Divider(height: 32),
              
              // Listado de Clases
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
                        // Navega a la pantalla de detalle y espera la actualización
                        final updatedStudent = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClassDetailScreen(
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