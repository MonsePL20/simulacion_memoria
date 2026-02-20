import 'package:flutter/material.dart';

class VisualMemoria extends StatefulWidget {
  final List<Map<String, dynamic>> procesos;

  const VisualMemoria({super.key, required this.procesos});

  @override
  State<VisualMemoria> createState() => _VisualMemoriaState();
}

class _VisualMemoriaState extends State<VisualMemoria> {
  
  final List<Color> _palette = [
    const Color.fromARGB(255, 66, 63, 63),
    Colors.deepPurpleAccent,
    const Color.fromARGB(255, 174, 255, 82),
    Colors.blue,
    Colors.purple,
    Colors.yellow,
    Colors.cyan,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
  ];

  //  Mapa de colores por nombre de proceso (PERSISTENTE)
  final Map<String, Color> _coloresAsignados = {};
  
  //  Índice para asignar siguiente color disponible
  int _indiceColor = 0;

  //  Obtener o asignar color a un proceso
  Color _obtenerColor(String nombre) {
    if (_coloresAsignados.containsKey(nombre)) {
      return _coloresAsignados[nombre]!;
    }
    
    Color nuevoColor = _palette[_indiceColor % _palette.length];
    _coloresAsignados[nombre] = nuevoColor;
    _indiceColor++;
    
    return nuevoColor;
  }

  @override
  Widget build(BuildContext context) {
    const int memoriaTotal = 100;
  
    // Calcular memoria ocupada (solo de procesos que caben)
    int memoriaOcupada = 0;
    final List<Map<String, dynamic>> procesosEnMemoria = [];
    
    for (var p in widget.procesos) {
      int tamano = int.tryParse(p['tamano'].toString()) ?? 0;
      if (memoriaOcupada + tamano <= memoriaTotal) {
        memoriaOcupada += tamano;
        procesosEnMemoria.add(p);
      }
    }

    //  Memoria libre
    int memoriaLibre = memoriaTotal - memoriaOcupada;

    return Column(
      children: [
        
        //  CONTADOR DE MEMORIA LIBRE
        Container(
          width: 400,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.blueGrey[800],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "MEMORIA",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: memoriaLibre > 30 ? Colors.green : (memoriaLibre > 10 ? Colors.green : Colors.green),
                  //color: memoriaLibre > 30 ? Colors.green : (memoriaLibre > 10 ? Colors.orange : Colors.red),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  "Libre: $memoriaLibre MB / $memoriaTotal MB",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        //  Contenedor de la memoria
        Container(
          height: 750,
          width: 400,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueGrey, width: 2),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Column(
              children: [
                
                //  Bloques de procesos en memoria
                ...procesosEnMemoria.asMap().entries.map((entry) {
                  var proceso = entry.value;
                  int flexValue = int.tryParse(proceso['tamano'].toString()) ?? 10;
                  Color colorProceso = _obtenerColor(proceso['nombre'] ?? "?");

                  return Expanded(
                    flex: flexValue,
                    child: Container(
                      width: double.infinity,
                      color: colorProceso,
                      child: Center(
                        child: Text(
                          "${proceso['nombre']}\n${proceso['tamano']}MB",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                }).toList(),

                //  Memoria libre
                if (memoriaLibre > 0)
                  Expanded(
                    flex: memoriaLibre,
                    child: Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Text(
                          "Libre\n${memoriaLibre}MB",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}