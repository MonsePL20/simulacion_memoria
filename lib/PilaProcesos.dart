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
  List<Map<String, dynamic>> memoria = [];
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
    memoria = [{"nombre": "Libre", "tamano": memoriaTotal, "libre": true}];
  }

  @override
  void didUpdateWidget(VisualMemoria oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sincronizarMemoria();
  }

  void _sincronizarMemoria(){
    // Liberar procesos eliminados
    for (var bloque in List.from(memoria)) {
      if (!(bloque["libre"] ?? false)) {
        bool sigueExistiendo = widget.procesos.any((p) => p["nombre"] == bloque["nombre"]);
        if (!sigueExistiendo) {
          setState(() {
            int index = memoria.indexOf(bloque);
            if (index != -1) {
              memoria[index] = {"nombre": "Libre", "tamano": bloque["tamano"], "libre": true};
            }
          });
        }
      }
    }

    // Colocar procesos en espera O de nuevos
    for (var p in widget.procesos) {
      bool yaEnMemoria = memoria.any((m) => m["nombre"] == p["nombre"] && !(m["libre"] ?? true));
      if (!yaEnMemoria) {
        int tam = int.tryParse(p["tamano"].toString()) ?? 0;
        if (widget.opcion == Opciones.primerAjuste) {
          _primerAjuste(p["nombre"], tam);
        } else {
          _mejorAjuste(p["nombre"], tam);
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
            memoria.insert(i + 1, {"nombre": "Libre", "tamano": restante, "libre": true});
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
        memoria[mejorIndex] = {"nombre": nombre, "tamano": tamano, "libre": false};
        if (restante > 0) {
          memoria.insert(mejorIndex + 1, {"nombre": "Libre", "tamano": restante, "libre": true});
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

    Color colorMemoria = memoriaLibre > 30 
        ? Colors.green 
        : (memoriaLibre > 15 ? Colors.orange : Colors.red);

    return Column(
      children: [
        // HEADER
        Container(
          width: 420, // ← ANCHO LIGERAMENTE MAYOR
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueGrey[800]!, Colors.blueGrey[900]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("MEMORIA", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: colorMemoria, borderRadius: BorderRadius.circular(20)),
                child: Text("Libre: ${memoriaLibre}MB / 100MB", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ],
          ),
        ),
        
        // MEMORIA CON FORMATO EXACTO "P2 / 5MB"
        Expanded(
          child: Container(
            width: 420, // ← ANCHO FIJO
            height: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueGrey[600]!, width: 3),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 5))],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Column(
                children: memoria.map((bloque) {
                  // FORMATO EXACTO: "P2 / 5MB" o "Libre / 75MB"
                  String nombreNumero = bloque["libre"] 
                      ? "Libre" 
                      : bloque["nombre"].toString().contains("P") 
                          ? "P${bloque["nombre"].toString().replaceAll(RegExp(r'[^0-9]'), '')}"
                          : bloque["nombre"].toString();
                  
                  String textoCompleto = "$nombreNumero / ${bloque["tamano"]}MB";
                  
                  return Expanded(
                    flex: bloque["tamano"],
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: bloque["libre"] ? Colors.grey[300]! : _obtenerColor(bloque["nombre"]),
                        border: Border(
                          bottom: BorderSide(color: Colors.black26, width: 1),
                          right: BorderSide(color: Colors.black26, width: 1),
                        ),
                      ),
                      child: Center(
                        child: FittedBox( // ← AJUSTA TEXTO para bloques pequeños
                          fit: BoxFit.scaleDown,
                          child: Text(
                            textoCompleto, // "P2 / 5MB"
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: bloque["libre"] ? Colors.black87 : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14, // ← TAMAÑO FIJO
                              letterSpacing: 0.5,
                            ),
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