import 'clase.dart'; 

class Student {
  final String name;
  final String profileImageUrl; // ¡Ahora una URL de red!
  final List<ClassInfo> currentClasses;

  Student({
    required this.name,
    required this.profileImageUrl,
    required this.currentClasses,
  });

  // Datos de ejemplo para la aplicación
  static Student mockStudent() {
    return Student(
      name: 'Josue Jafet Ramos',
      // URL de red proporcionada por el usuario
      profileImageUrl: 'https://tse3.mm.bing.net/th/id/OIP.9xLo3UvzJ_kisyMiiVrNbAHaJl?cb=12&rs=1&pid=ImgDetMain&o=7&rm=3', 
      currentClasses: [
        ClassInfo(name: 'Programación Movil II', teacher: 'Ing. Ludwin Navarro', code: '1801', partialGrades: [90.0, 85.5, null]),
        ClassInfo(name: 'Gestion y estandares de tecnologias de la informacion', teacher: 'Ing. Thania', code: '9837', partialGrades: [78.0, null, null]),
        ClassInfo(name: 'Seminario de Hardware y Electricidad', teacher: 'Ing. Cristian', code: '2873'),
        ClassInfo(name: 'Gestion de la Calidad', teacher: 'Lic. Marta Giron', code: '8263'),
        ClassInfo(name: 'Etica Profesional', teacher: 'Lic. Alba', code: '2743'),
        ClassInfo(name: 'Portales Web II', teacher: 'Lic. David', code: '2773', partialGrades: [95.0, 92.0, 98.0]),
      ],
    );
  }

  // Método para actualizar una clase específica
  Student updateClass(ClassInfo updatedClass) {
    final newClasses = currentClasses.map((clase) {
      return clase.code == updatedClass.code ? updatedClass : clase;
    }).toList();

    return Student(
      name: name,
      profileImageUrl: profileImageUrl,
      currentClasses: newClasses,
    );
  }

  // NUEVO: Método para calcular el promedio general de todas las clases
  double calculateOverallAverage() {
    double totalGradesSum = 0.0;
    int totalValidGradesCount = 0;

    for (var classInfo in currentClasses) {
      for (var grade in classInfo.partialGrades) {
        if (grade != null) {
          totalGradesSum += grade;
          totalValidGradesCount++;
        }
      }
    }

    if (totalValidGradesCount == 0) return 0.0;

    return totalGradesSum / totalValidGradesCount;
  }
  
  // NUEVO: Método para obtener el rango basado en el promedio
  String getRango(double average) {
    if (average >= 90.0) {
      return 'Sobresaliente';
    } else if (average >= 60.0) {
      return 'Aprobado';
    } else {
      return 'Reprobado';
    }
  }
}

