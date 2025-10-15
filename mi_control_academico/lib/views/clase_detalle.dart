import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/clase.dart';
import '../models/student.dart';

class ClassDetailScreen extends StatefulWidget {
  final Student student;
  final ClassInfo classInfo;

  const ClassDetailScreen({
    super.key,
    required this.student,
    required this.classInfo,
  });

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen> {
  late ClassInfo _currentClass;
  late List<TextEditingController> _gradeControllers;
  late double _finalAverage;

  @override
  void initState() {
    super.initState();
    _currentClass = widget.classInfo;
    _finalAverage = _currentClass.calculateFinalAverage();

    // Inicializa los controladores de texto con las notas existentes
    _gradeControllers = List.generate(
      _currentClass.partialGrades.length,
      (index) => TextEditingController(
        text: _currentClass.partialGrades[index]?.toString() ?? '',
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _gradeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Función para calcular y actualizar la nota
  void _calculateAndSaveGrade(int index, String value) {
    double? newGrade;
    if (value.isNotEmpty) {
      newGrade = double.tryParse(value);
      if (newGrade == null || newGrade < 0 || newGrade > 100) {
        // Manejo de error o simplemente no se actualiza si el valor no es válido
        // Podrías mostrar un Toast/Snackbar aquí.
        return; 
      }
    }

    setState(() {
      // 1. Actualiza el modelo ClassInfo
      _currentClass = _currentClass.updateGrade(index, newGrade);
      
      // 2. Recalcula el promedio
      _finalAverage = _currentClass.calculateFinalAverage();
    });
  }

  // Función para guardar los cambios y volver a la pantalla anterior
  void _saveChanges() {
    // 1. Actualiza el modelo Student con la clase modificada
    final updatedStudent = widget.student.updateClass(_currentClass);
    
    // 2. Retorna el estudiante actualizado a la pantalla anterior (HomeScreen)
    Navigator.pop(context, updatedStudent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentClass.name,
          style: GoogleFonts.robotoCondensed(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveChanges,
            tooltip: 'Guardar Cambios',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información de la Clase
            Text(
              'Docente: ${_currentClass.teacher}',
              style: GoogleFonts.lato(fontSize: 18),
            ),
            Text(
              'Código: ${_currentClass.code}',
              style: GoogleFonts.lato(fontSize: 16, color: Colors.grey[600]),
            ),
            const Divider(height: 30),

            // Ingreso de Notas por Parcial
            Text(
              'Ingreso de Notas Parciales (0-100):',
              style: GoogleFonts.robotoSlab(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            ...List.generate(
              _currentClass.partialGrades.length,
              (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TextField(
                    controller: _gradeControllers[index],
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Nota Parcial ${index + 1}',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          _gradeControllers[index].clear();
                          _calculateAndSaveGrade(index, '');
                        },
                      ),
                    ),
                    onChanged: (value) => _calculateAndSaveGrade(index, value),
                    onSubmitted: (value) => _calculateAndSaveGrade(index, value),
                  ),
                );
              },
            ),

            const Divider(height: 30),

            // Promedio Final
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Promedio Final:',
                  style: GoogleFonts.openSans(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _finalAverage.toStringAsFixed(1),
                  style: GoogleFonts.openSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: _finalAverage >= 60.0 ? Colors.green[700] : Colors.red[700],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}