import 'package:flutter/material.dart';
import 'package:simulacion_memoria/Botones.dart';

class VisualMemoria extends StatefulWidget {
  final List<Map<String, dynamic>> procesos;
  final Opciones opcion;
  const VisualMemoria({
    super.key, 
    required this.procesos,
    required this.opcion,
    });

  @override
  State<VisualMemoria> createState() => _VisualMemoriaState();
}

class _VisualMemoriaState extends State<VisualMemoria> {
  List<Map<String , dynamic >> memoria = [];
  final int memoriaTotal = 100;
  
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
  
  @override
  void initState(){
    super.initState();
    //inicializacion con un solo bloque
    memoria = [
      {"nombre" : "Libre" , "tamano" : memoriaTotal, "libre" : true}
    ];
  }

  //Lista de procesos cambia
  @override
  void didUpdateWidget (VisualMemoria oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sincronizarMemoria();
  }

  void _sincronizarMemoria(){
    //si hay procesos nuevos en widget se intentan meter
    for (var p in widget.procesos){
      bool yaEnMemoria = memoria.any((m) => m["nombre"] == p["nombre"]);
      if (!yaEnMemoria){
        int tam = int.tryParse(p["tamano"].toString()) ?? 0;

        if (widget.opcion == Opciones.primerAjuste){
          _primerAjuste(p["nombre"],tam);
        }else{
          _mejorAjuste(p["nombre"],tam);
        }
        //_asignarEspacio(p["nombre"],int.tryParse(p["tamano"].toString()) ?? 0);
      }
    }
    //si un proceso fue eliminado se libera de memoria
    for (var bloque in memoria) {
      if (!(bloque["libre"] ?? false)) {
        bool sigueExistiendo = widget.procesos.any((p) => p["nombre"] == bloque["nombre"]);
        if (!sigueExistiendo) {
          setState(() {
            bloque["libre"] = true;
            bloque["nombre"] = "Libre";
          });
        }
      }
    }
  }

  void _primerAjuste(String nombre, int tamano) {
  for (int i = 0; i < memoria.length; i++) {
    if (memoria[i]["libre"] && memoria[i]["tamano"] >= tamano) {
      int restante = memoria[i]["tamano"] - tamano;

      setState(() {
        memoria[i] = {"nombre": nombre, "tamano": tamano, "libre": false};

        if (restante > 0) {
          memoria.insert(i + 1, {
            "nombre": "Libre",
            "tamano": restante,
            "libre": true
          });
        }
      });
      return;
    }
  }
}

void _mejorAjuste(String nombre, int tamano) {
  int mejorIndex = -1;
  int mejorTamano = 999999;

  for (int i = 0; i < memoria.length; i++) {
    if (memoria[i]["libre"] && memoria[i]["tamano"] >= tamano) {
      
      int espacio = memoria[i]["tamano"];

      if (espacio < mejorTamano) {
        mejorTamano = espacio;
        mejorIndex = i;
      }
    }
  }

  if (mejorIndex != -1) {
    int restante = memoria[mejorIndex]["tamano"] - tamano;

    setState(() {
      memoria[mejorIndex] = {
        "nombre": nombre,
        "tamano": tamano,
        "libre": false
      };

      if (restante > 0) {
        memoria.insert(mejorIndex + 1, {
          "nombre": "Libre",
          "tamano": restante,
          "libre": true
        });
      }
    });
  }
}

  Color _obtenerColor(String nombre) {
    int hash = nombre.hashCode;
    return _palette[hash.abs() % _palette.length];
  }

  @override
  Widget build(BuildContext context) {
    int memoriaLibre = memoria
    .where((b) => b["libre"])
    .fold(0, (sum, b) => sum + (b["tamano"] as int));

    return Column(
      children: [
        Container(
          width: 400,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.blueGrey[800],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("MEMORIA", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(15)),
                child: Text("Libre: $memoriaLibre MB / $memoriaTotal MB",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            width: 400,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueGrey, width: 2),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Column(
                children: memoria.map((bloque) {
                  return Expanded(
                    flex: bloque["tamano"],
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: bloque["libre"] ? Colors.grey[300] : _obtenerColor(bloque["nombre"]),
                        border: Border.all(color: Colors.black12, width: 0.5),
                      ),
                      child: Center(
                        child: Text(
                          "${bloque["nombre"]}\n${bloque["tamano"]}MB",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: bloque["libre"] ? Colors.black54 : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
    
      ],
    );
  }
}