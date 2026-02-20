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
  // 📌 Lista que almacena los procesos
  final List<Map<String, dynamic>> procesos = [];

  // 📌 Método para agregar proceso
  void agregarProceso(Map<String, dynamic> proceso) {
    setState(() {
      procesos.add(proceso);
    });
  }

  // 📌 Método para eliminar proceso
  void eliminarProceso(String nombre) {
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
            child: Botones(// PASAMOS LOS MÉTODOS DE AGREGAR Y ELIMINAR
              onAgregar: agregarProceso,
              onEliminar: eliminarProceso,
            ),
          ),

          // 🔹 DERECHA → TABLA
          Expanded(
            flex: 3,
            child: TablaProcesosApp(// PASAMOS LA LISTA DE PROCESOS
              procesos: procesos,
            ),
          ),
        ],
      ),
    );
  }
}