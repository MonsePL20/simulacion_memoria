import 'package:flutter/material.dart';
import 'TablaProcesosApp.dart';
import 'Botones.dart';
import 'PilaProcesos.dart';
import 'dart:math';

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
  
  // 📌 Random para los cálculos
  final Random _random = Random();

  // 📌 Convertir HH:MM a minutos totales
  int _horaAMinutos(String horaStr) {
    try {
      if (!horaStr.contains(':')) return 0;
      List<String> partes = horaStr.split(':');
      int horas = int.tryParse(partes[0]) ?? 0;
      int minutos = int.tryParse(partes[1]) ?? 0;
      return horas * 60 + minutos;
    } catch (e) {
      return 0;
    }
  }

  // 📌 Convertir minutos totales a HH:MM
  String _minutosAHora(int minutosTotales) {
    int horas = minutosTotales ~/ 60;
    int minutos = minutosTotales % 60;
    return "$horas:${minutos.toString().padLeft(2, '0')}";
  }

  // 📌 Función para calcular tiempo de atención (10% probabilidad de 1-10 min)
  int _calcularTiempoAtencion() {
    int probabilidad = _random.nextInt(100); // 0-99
    if (probabilidad < 10) { // 10% de probabilidad
      return _random.nextInt(10) + 1; // 1-10 minutos
    }
    return 0;
  }

  // 📌 Función para calcular tiempo de salida (0-10 minutos)
  int _calcularTiempoSalida() {
    return _random.nextInt(11); // 0-10 minutos
  }

  // 📌 Método para agregar proceso
  void agregarProceso(String nombre, String tamano, String llegada) {
    int nuevoTamano = int.tryParse(tamano) ?? 0;
    
    // 📌 Convertir hora de llegada a minutos
    int tiempoLlegadaMin = _horaAMinutos(llegada);
    
    // 📌 Calcular tiempo de atención (10% probabilidad de 1-10 min)
    int tiempoAtencionAdicional = _calcularTiempoAtencion();
    int tiempoAtencionMin = tiempoLlegadaMin + tiempoAtencionAdicional;
    
    // 📌 Calcular tiempo de salida (0-10 min después de atención)
    int tiempoSalidaAdicional = _calcularTiempoSalida();
    int tiempoSalidaMin = tiempoAtencionMin + tiempoSalidaAdicional;
    
    // 📌 Calcular tiempo de espera (diferencia en minutos)
    int tiempoEsperaMin = tiempoAtencionMin - tiempoLlegadaMin;
    
    // 📌 Convertir a formato HH:MM
    String horaLlegada = _minutosAHora(tiempoLlegadaMin);
    String horaAtencion = _minutosAHora(tiempoAtencionMin);
    String horaSalida = _minutosAHora(tiempoSalidaMin);
    String tiempoEsperaStr = "$tiempoEsperaMin min";
    
    // Calcular ocupación actual
    int ocupado = procesos.fold(0, (sum, p) => sum + (int.tryParse(p['tamano'].toString()) ?? 0));

    // 📌 Crear proceso con todos los datos
    Map<String, dynamic> nuevoProceso = {
      "nombre": nombre,
      "tamano": tamano,
      "llegada": horaLlegada,
      "atencion": horaAtencion,
      "salida": horaSalida,
      "espera": tiempoEsperaStr,
    };

    // 📌 Si no cabe en memoria, guardar en tabla (proceso en espera)
    if (ocupado + nuevoTamano > 100) {
      setState(() {
        procesos.add(nuevoProceso);
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Proceso '$nombre' agregado a tabla (memoria llena)"),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
      
      return;
    }

    // 📌 Si cabe, agregar normalmente
    setState(() {
      procesos.add(nuevoProceso);
    });
  }

  // 📌 Método para eliminar proceso (CON VALIDACIÓN)
  void eliminarProceso(String nombre, String salida) {
    // 📌 Buscar proceso por nombre Y tiempo de salida
    final existe = procesos.any((p) => 
      p['nombre'] == nombre && p['salida'] == salida
    );
    
    if (!existe) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Proceso no encontrado - Verifique nombre y tiempo de salida"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      procesos.removeWhere((p) => 
        p['nombre'] == nombre && p['salida'] == salida
      );
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Proceso '$nombre' eliminado correctamente"),
        backgroundColor: Colors.green,
      ),
    );
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

          // 🔹 CENTRO → MEMORIA
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: VisualMemoria(procesos: procesos),
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