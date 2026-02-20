import 'package:flutter/material.dart';

class VisualMemoria extends StatelessWidget {
  final List<Map<String, dynamic>> procesos;

  const VisualMemoria({super.key, required this.procesos});

  @override
  Widget build(BuildContext context) {
    // Paleta de colores para los procesos
    List<Color> palette = [Colors.red, Colors.blue, Colors.green, Colors.orange, Colors.purple];
    const int memoriaTotal = 100; // Tope de 100 KB
  
    // Espacio que ocupan los procesos actuales
    int memoriaOcupada = procesos.fold(0, (sum, p) {
      return sum + (int.tryParse(p['tamano'].toString()) ?? 0);
    });

    // Espacio libre 
    int memoriaLibre = (memoriaTotal - memoriaOcupada).clamp(0, 100);

    return Container(
      height: 400, // Alto
      width: 120,  // Ancho 
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          children: [
            // Bloques de procesos
            ...procesos.asMap().entries.map((entry) {
              int idx = entry.key;
              var proceso = entry.value;
              
              // Tamaño
              int flexValue = int.tryParse(proceso['tamano'].toString()) ?? 10;

              return Expanded(
                flex: flexValue,
                child: Container(
                  width: double.infinity,
                  color: palette[idx % palette.length],
                  child: Center(
                    child: Text(
                      proceso['nombre'] ?? "?",
                    ),
                  ),
                ),
              );
            }).toList(),

            // Memoria libre
            if (memoriaLibre > 0)
            Expanded(
              flex: memoriaLibre, // Lo que sobra para llegar a 100
              child: Container(
                color: Colors.grey[300],
                child: Center(child: Text("Libre: ${memoriaLibre}KB")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}