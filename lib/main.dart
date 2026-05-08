import 'package:flutter/material.dart';
import 'TablaProcesosApp.dart';
import 'Botones.dart';
import 'PilaProcesos.dart';
import 'dart:math';


void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) => const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PantallaPrincipal(),
  );
}

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});
  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  final List<Map<String, dynamic>> historialProcesos = [];
  final List<Map<String, dynamic>> procesosActivos = [];
  final Random _random = Random();
  Key _memoriaKey = UniqueKey();
  Opciones _opcionSeleccionada = Opciones.primerAjuste;

  int _horaAMinutos(String horaStr) {
    try {
      if (!horaStr.contains(':')) return 0;
      List<String> partes = horaStr.split(':');
      return (int.tryParse(partes[0]) ?? 0) * 60 + (int.tryParse(partes[1]) ?? 0);
    } catch (e) {
      return 0;
    }
  }

  String _minutosAHora(int minutosTotales) {
    int horas = minutosTotales ~/ 60;
    int minutos = minutosTotales % 60;
    return "${horas.toString().padLeft(2, '0')}:${minutos.toString().padLeft(2, '0')}";
  }

  void agregarProceso(String nombre, String tamano, String duracion, String llegada) {
    int nuevoTamano = int.tryParse(tamano) ?? 0;
    int duracionMin = int.tryParse(duracion) ?? 0;
    
    int tiempoLlegadaMin = _horaAMinutos(llegada);
    int tiempoAtencionMin = tiempoLlegadaMin + duracionMin;
    int tiempoSalidaAdicional = _random.nextInt(11);
    int tiempoSalidaMin = tiempoAtencionMin + tiempoSalidaAdicional;
    int tiempoEsperaMin = duracionMin;

    Map<String, dynamic> procesoCompleto = {
      "nombre": nombre,
      "tamano": tamano,
      "duracion": duracion,
      "llegada": llegada,
      "atencion": _minutosAHora(tiempoAtencionMin),
      "salida": _minutosAHora(tiempoSalidaMin),
      "espera": "${tiempoEsperaMin} min",
      "estado": "Activo",
    };

    int memoriaOcupada = procesosActivos.fold(0, (sum, p) => sum + (int.tryParse(p['tamano'].toString()) ?? 0));
    
    if (memoriaOcupada + nuevoTamano > 100) {
      setState(() => historialProcesos.add({...procesoCompleto, "estado": "En Espera"}));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ '$nombre' en espera (memoria llena)"), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() {
      historialProcesos.add(procesoCompleto);
      procesosActivos.add(procesoCompleto);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ '$nombre' en memoria"), backgroundColor: Colors.green),
    );
  }

  void eliminarProceso(String nombre, String salida) {
    final procesoActivo = procesosActivos.firstWhere(
      (p) => p['nombre'] == nombre && p['salida'] == salida,
      orElse: () => {},
    );
    
    if (procesoActivo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Proceso no en memoria"), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      final indexHistorial = historialProcesos.indexWhere((p) => p['nombre'] == nombre && p['salida'] == salida);
      if (indexHistorial != -1) historialProcesos[indexHistorial]['estado'] = 'Eliminado';
      procesosActivos.removeWhere((p) => p['nombre'] == nombre && p['salida'] == salida);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("🗑️ '$nombre' eliminado"), backgroundColor: Colors.red),
    );
  }

  void reiniciarPrograma() {
    setState(() {
      procesosActivos.clear();
      _opcionSeleccionada = Opciones.primerAjuste;
      _memoriaKey = UniqueKey();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("🔄 Memoria reiniciada"), backgroundColor: Colors.orange),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      appBar: AppBar(
        title: const Text("📊 Simulación Memoria"),
        backgroundColor: Colors.blueGrey[800],
        foregroundColor: Colors.white,
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: reiniciarPrograma)],
      ),
      body: Row(
        children: [
          Expanded(flex: 2, child: BotonesAccion(
            onAgregar: agregarProceso,
            onEliminar: eliminarProceso,
            onCambioOpcion: (op) => setState(() => _opcionSeleccionada = op),
            onReinicio: reiniciarPrograma,
          )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: VisualMemoria(key: _memoriaKey, procesos: procesosActivos, opcion: _opcionSeleccionada),
          ),
          Expanded(flex: 3, child: TablaProceso(procesos: historialProcesos)),
        ],
      ),
    );
  }
}