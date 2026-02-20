import 'package:flutter/material.dart';
import 'TablaProcesosApp.dart';
import 'Botones.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PantallaPrincipal(),
    );
  }
}

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  
  // 📌 Lista única y centralizada de procesos
  final List<Map<String, dynamic>> procesos = [];

  // 📌 Método para agregar proceso
  void agregarProceso(String nombre, String tamano, String llegada) {
    setState(() {
      procesos.add({
        "nombre": nombre,
        "tamano": tamano,
        "llegada": llegada,
        "salida": "-",
        "atencion": "-",
        "espera": "-"
      });
    });
  }

  // 📌 Método para eliminar proceso
  void eliminarProceso(String nombre) {
    final existe = procesos.any((p) => p['nombre'] == nombre);
    
    if (!existe) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Proceso no encontrado")),
      );
      return;
    }

    setState(() {
      procesos.removeWhere((p) => p['nombre'] == nombre);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      appBar: AppBar(
        title: const Text("Simulación de Procesos"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Row(
        children: [
          
          // 🔹 IZQUIERDA → BOTONES
          Expanded(
            flex: 2,
            child: BotonesAccion(
              onAgregar: agregarProceso,
              onEliminar: eliminarProceso,
            ),
          ),

          // 🔹 DERECHA → TABLA
          Expanded(
            flex: 3,
            child: TablaProceso(
              procesos: procesos,
            ),
          ),
        ],
      ),
    );
  }
}