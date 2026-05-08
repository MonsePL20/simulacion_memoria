import 'package:flutter/material.dart';
import 'TablaProcesosApp.dart';  // ← CAMBIAR por 'tabla_procesos.dart'
import 'Botones.dart';
import 'PilaProcesos.dart';     // ← CAMBIAR por 'pila_procesos.dart'
import 'dart:math';

enum Opciones { primerAjuste, mejorAjuste } // ← AGREGADO

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
  
  // ✅ LISTA DE REGISTRO HISTÓRICO (NO se limpia nunca)
  final List<Map<String, dynamic>> historialProcesos = [];
  
  // Lista solo para memoria activa (se sincroniza con VisualMemoria)
  final List<Map<String, dynamic>> procesosActivos = [];
  
  final Random _random = Random();
  Key _memoriaKey = UniqueKey();
  Opciones _opcionSeleccionada = Opciones.primerAjuste;

  //Convertir HH:MM → minutos
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

  // minutos → HH:MM
  String _minutosAHora(int minutosTotales) {
    int horas = minutosTotales ~/ 60;
    int minutos = minutosTotales % 60;
    return "${horas.toString().padLeft(2, '0')}:${minutos.toString().padLeft(2, '0')}";
  }

  // ✅ AGREGAR PROCESO (CORREGIDO con 4 parámetros + HISTORIAL)
  void agregarProceso(String nombre, String tamano, String duracion, String llegada) {
    int nuevoTamano = int.tryParse(tamano) ?? 0;
    int duracionMin = int.tryParse(duracion) ?? 0; // ← ✅ USA DURACION
    
    int tiempoLlegadaMin = _horaAMinutos(llegada);
    int tiempoAtencionMin = tiempoLlegadaMin + duracionMin; // ← CÁLCULO CON DURACIÓN
    int tiempoSalidaAdicional = _calcularTiempoSalida();
    int tiempoSalidaMin = tiempoAtencionMin + tiempoSalidaAdicional;
    int tiempoEsperaMin = duracionMin; // ← TIEMPO ESPERA = DURACIÓN
    
    String horaLlegada = llegada; // ← MANTIENE FORMATO ORIGINAL
    String horaAtencion = _minutosAHora(tiempoAtencionMin);
    String horaSalida = _minutosAHora(tiempoSalidaMin);
    String tiempoEsperaStr = "${tiempoEsperaMin} min";

    // ✅ CREAR PROCESO COMPLETO
    Map<String, dynamic> procesoCompleto = {
      "nombre": nombre,
      "tamano": tamano,
      "duracion": duracion,  // ← ✅ NUEVO CAMPO
      "llegada": horaLlegada,
      "atencion": horaAtencion,
      "salida": horaSalida,
      "espera": tiempoEsperaStr,
      "estado": "Activo",    // ← NUEVO: seguimiento estado
    };

    // Verificar memoria disponible
    int memoriaOcupada = procesosActivos.fold(0, (sum, p) => sum + (int.tryParse(p['tamano'].toString()) ?? 0));
    
    if (memoriaOcupada + nuevoTamano > 100) {
      setState(() {
        // ✅ AGREGAR A HISTORIAL (PERMANENTE)
        historialProcesos.add({...procesoCompleto, "estado": "En Espera"});
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ '$nombre' en espera (memoria llena)"), backgroundColor: Colors.orange),
      );
      return;
    }

    // ✅ AGREGAR A AMBAS LISTAS
    setState(() {
      historialProcesos.add(procesoCompleto);      // ← REGISTRO PERMANENTE
      procesosActivos.add(procesoCompleto);        // ← MEMORIA ACTIVA
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ '$nombre' agregado a memoria"), backgroundColor: Colors.green),
    );
  }

  // ✅ ELIMINAR (solo de memoria activa, queda en historial)
  void eliminarProceso(String nombre, String salida) {
    final procesoActivo = procesosActivos.firstWhere(
      (p) => p['nombre'] == nombre && p['salida'] == salida,
      orElse: () => {},
    );
    
    if (procesoActivo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Proceso no encontrado en memoria"), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      // ✅ CAMBIAR ESTADO en historial
      final indexHistorial = historialProcesos.indexWhere((p) => p['nombre'] == nombre && p['salida'] == salida);
      if (indexHistorial != -1) {
        historialProcesos[indexHistorial]['estado'] = 'Eliminado';
      }
      
      // ✅ REMOVER solo de activos
      procesosActivos.removeWhere((p) => p['nombre'] == nombre && p['salida'] == salida);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("🗑️ '$nombre' eliminado de memoria"), backgroundColor: Colors.red),
    );
  }

  int _calcularTiempoSalida() => _random.nextInt(11);

  // ✅ REINICIO (limpia solo activos, historial queda)
  void reiniciarPrograma() {
    setState(() {
      procesosActivos.clear();
      _opcionSeleccionada = Opciones.primerAjuste;
      _memoriaKey = UniqueKey();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("🔄 Memoria reiniciada (Historial preservado)"),
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
        title: const Text("📊 Simulación de Procesos y Memoria"),
        backgroundColor: Colors.blueGrey[800],
        foregroundColor: Colors.white,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: reiniciarPrograma,
            tooltip: "Reiniciar Memoria",
          ),
        ],
      ),
      body: Row(
        children: [
          // 🎛️ BOTONES
          Expanded(flex: 2, child: BotonesAccion(
            onAgregar: agregarProceso,
            onEliminar: eliminarProceso,
            onCambioOpcion: (op) => setState(() => _opcionSeleccionada = op),
            onReinicio: reiniciarPrograma,
          )),

          // 🧠 MEMORIA (solo procesosActivos)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: VisualMemoria(
              key: _memoriaKey,
              procesos: procesosActivos,  // ← SOLO ACTIVOS
              opcion: _opcionSeleccionada,
            ),
          ),

          // 📋 TABLA HISTÓRICA (todos los procesos)
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  color: Colors.blue[700],
                  child: const Text(
                    "📋 HISTORIAL COMPLETO DE PROCESOS",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(child: TablaProceso(procesos: historialProcesos)), // ← HISTORIAL
              ],
            ),
          ),
        ],
      ),
    );
  }
}