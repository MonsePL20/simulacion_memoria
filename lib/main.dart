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
  
  //Lista única y centralizada de procesos
  final List<Map<String, dynamic>> procesos = [];
  
  // Random para los cálculos
  final Random _random = Random();

  // Key única para forzar rebuild de VisualMemoria
  Key _memoriaKey = UniqueKey();

  //Convertir HH:MM a minutos totales
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

  // Convertir minutos totales a HH:MM
  String _minutosAHora(int minutosTotales) {
    int horas = minutosTotales ~/ 60;
    int minutos = minutosTotales % 60;
    return "$horas:${minutos.toString().padLeft(2, '0')}";
  }

  // Función para calcular tiempo de atención (10% probabilidad de 1-10 min)
  int _calcularTiempoAtencion() {
    int probabilidad = _random.nextInt(100);
    if (probabilidad < 10) {
      return _random.nextInt(10) + 1;
    }
    return 0;
  }

  //Función para calcular tiempo de salida (0-10 minutos)
  int _calcularTiempoSalida() {
    return _random.nextInt(11);
  }

  Opciones _opcionSeleccionada = Opciones.primerAjuste;

  //Método para agregar proceso
  void agregarProceso(String nombre, String tamano, String llegada) {
    int nuevoTamano = int.tryParse(tamano) ?? 0;
    
    int tiempoLlegadaMin = _horaAMinutos(llegada);
    int tiempoAtencionAdicional = _calcularTiempoAtencion();
    int tiempoAtencionMin = tiempoLlegadaMin + tiempoAtencionAdicional;
    int tiempoSalidaAdicional = _calcularTiempoSalida();
    int tiempoSalidaMin = tiempoAtencionMin + tiempoSalidaAdicional;
    int tiempoEsperaMin = tiempoAtencionMin - tiempoLlegadaMin;
    
    String horaLlegada = _minutosAHora(tiempoLlegadaMin);
    String horaAtencion = _minutosAHora(tiempoAtencionMin);
    String horaSalida = _minutosAHora(tiempoSalidaMin);
    String tiempoEsperaStr = "$tiempoEsperaMin min";
    
    int ocupado = procesos.fold(0, (sum, p) => sum + (int.tryParse(p['tamano'].toString()) ?? 0));

    Map<String, dynamic> nuevoProceso = {
      "nombre": nombre,
      "tamano": tamano,
      "llegada": horaLlegada,
      "atencion": horaAtencion,
      "salida": horaSalida,
      "espera": tiempoEsperaStr,
    };

    if (ocupado + nuevoTamano > 100) {
      setState(() {
        procesos.add(nuevoProceso);
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Proceso '$nombre' en espera (memoria llena)"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }  
    
    setState(() {
      procesos.add(nuevoProceso);
    });
  }

  // Método para eliminar proceso
  void eliminarProceso(String nombre, String salida) {
    final existe = procesos.any((p) => p['nombre'] == nombre && p['salida'] == salida);
    
    if (!existe) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Proceso no encontrado"), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      procesos.removeWhere((p) => p['nombre'] == nombre && p['salida'] == salida);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ '$nombre' eliminado"), backgroundColor: Colors.green),
    );
  }

  // 🔥 REINICIO COMPLETO - FUNCIONA 100%
  void reiniciarPrograma() {
    setState(() {
      procesos.clear();
      _opcionSeleccionada = Opciones.primerAjuste;
      _memoriaKey = UniqueKey(); // ← Fuerza rebuild completo de VisualMemoria
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("🔄 ¡Reinicio completo! Memoria: 100MB libre"),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      appBar: AppBar(
        title: const Text("🎮 Simulación de Procesos"),
        backgroundColor: Colors.blueGrey[800],
        foregroundColor: Colors.white,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: reiniciarPrograma,
            tooltip: "Reiniciar Todo",
          ),
        ],
      ),
      body: Row(
        children: [
          // IZQUIERDA - BOTONES
          Expanded(
            flex: 2,
            child: BotonesAccion(
              onAgregar: agregarProceso,
              onEliminar: eliminarProceso,
              onCambioOpcion: (op) {
                setState(() {
                  _opcionSeleccionada = op;
                });
              },
              onReinicio: reiniciarPrograma,
            ),
          ),

          // CENTRO - MEMORIA (Key fuerza rebuild)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: VisualMemoria(
              key: _memoriaKey, // ✅ RECREA VisualMemoria en cada reinicio
              procesos: procesos,
              opcion: _opcionSeleccionada,
            ),
          ),

          // DERECHA - TABLA
          Expanded(
            flex: 3,
            child: TablaProceso(procesos: procesos),
          ),
        ],
      ),
    );
  }
}