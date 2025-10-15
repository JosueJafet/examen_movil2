class ClassInfo {
  final String name;
  final String teacher;
  final String code;
  final List<double?> partialGrades; // Lista de notas parciales (puede ser null inicialmente)

  ClassInfo({
    required this.name,
    required this.teacher,
    required this.code,
    this.partialGrades = const [null, null, null], // Ejemplo: 3 parciales
  });

  // Método para calcular el promedio final
  double calculateFinalAverage() {
    int validGradesCount = 0;
    double total = 0.0;

    for (var grade in partialGrades) {
      if (grade != null) {
        total += grade;
        validGradesCount++;
      }
    }

    if (validGradesCount == 0) return 0.0;

    return total / validGradesCount;
  }

  // Método para actualizar una nota parcial
  ClassInfo updateGrade(int partialIndex, double? newGrade) {
    if (partialIndex < 0 || partialIndex >= partialGrades.length) {
      return this; // Retorna sin cambios si el índice es inválido
    }

    final newGrades = List<double?>.from(partialGrades);
    newGrades[partialIndex] = newGrade;

    return ClassInfo(
      name: name,
      teacher: teacher,
      code: code,
      partialGrades: newGrades,
    );
  }
}