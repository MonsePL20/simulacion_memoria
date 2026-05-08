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

  // 🔥 PARSER FLEXIBLE
  int _horaAMinutos(String tiempoStr) {
    try {
      tiempoStr = tiempoStr.trim().replaceAll(' ', '');
      
      if (tiempoStr.contains(':')) {
        List<String> partes = tiempoStr.split(':');
        int horas = int.tryParse(partes[0]) ?? 0;
        String minsStr = partes.length > 1 ? partes[1] : '0';
        int minutos = int.tryParse(minsStr) ?? 0;
        return horas * 60 + minutos;
      }
      
      double numero = double.tryParse(tiempoStr) ?? 0;
      if (numero >= 1) {
        int horas = (numero ~/ 100).toInt();
        double decimales = numero % 100;
        int minutos = (decimales * 60 / 100).round();
        return horas * 60 + minutos;
      }
      
      return 0;
    } catch (e) {
      return 0;
    }
  }

  String _minutosAHora(int minutosTotales) {
    int horas = minutosTotales ~/ 60;
    int minutos = minutosTotales % 60;
    return "${horas.toString().padLeft(2, '0')}:${minutos.toString().padLeft(2, '0')}";
  }

  int _calcularTiempoEspera(int nuevoTamano) {
    int memoriaOcupada = procesosActivos.fold(0, (sum, p) => sum + (int.tryParse(p['tamano'].toString()) ?? 0));
    return (memoriaOcupada + nuevoTamano > 100) ? 1 : 0;
  }

  void agregarProceso(String nombre, String tamano, String duracion, String llegada) {
    int nuevoTamano = int.tryParse(tamano) ?? 0;
    int duracionMin = int.tryParse(duracion) ?? 0;
    
    int tiempoLlegadaMin = _horaAMinutos(llegada);
    int tiempoEsperaMin = _calcularTiempoEspera(nuevoTamano);
    
    int tiempoAtencionMin = tiempoLlegadaMin + tiempoEsperaMin;
    int tiempoSalidaMin = duracionMin + tiempoLlegadaMin + tiempoEsperaMin;

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
      if (context.mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⏳ '$nombre' en cola (espera ${tiempoEsperaMin}min mantenida)"), backgroundColor: Colors.orange),
        );
      return;
    }

    setState(() {
      historialProcesos.add(procesoCompleto);
      procesosActivos.add(procesoCompleto);
    });
    if (context.mounted)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ '$nombre' en memoria (espera ${tiempoEsperaMin}min)"), backgroundColor: Colors.green),
      );
  }

  void eliminarProceso(String nombre, String salida) {
    final procesoActivo = procesosActivos.firstWhere(
      (p) => p['nombre'] == nombre && p['salida'] == salida,
      orElse: () => {},
    );
    
    if (procesoActivo.isEmpty) {
      if (context.mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Proceso no en memoria"), backgroundColor: Colors.red),
        );
      return;
    }

    setState(() {
      // 1️⃣ Marcar eliminado (datos originales)
      final indexHistorial = historialProcesos.indexWhere((p) => p['nombre'] == nombre && p['salida'] == salida);
      if (indexHistorial != -1) historialProcesos[indexHistorial]['estado'] = 'Eliminado';
      
      // 2️⃣ Remover de activos
      procesosActivos.removeWhere((p) => p['nombre'] == nombre && p['salida'] == salida);
      
      // 🔥 3️⃣ MOVER PROCESO EN ESPERA (SIN CAMBIAR DATOS)
      _procesarColaEspera();
    });
    
    if (context.mounted)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("🗑️ Eliminado → Procesos espera entran (datos originales)"), backgroundColor: Colors.red),
      );
  }

  // ✅ MUEVE ESPERA → ACTIVO SIN CAMBIAR DATOS
  void _procesarColaEspera() {
    final procesosEnEspera = historialProcesos.where((p) => p['estado'] == 'En Espera').toList();
    
    for (var procesoEspera in procesosEnEspera) {
      int tamano = int.tryParse(procesoEspera['tamano'].toString()) ?? 0;
      int memoriaOcupada = procesosActivos.fold(0, (sum, p) => sum + (int.tryParse(p['tamano'].toString()) ?? 0));
      
      if (memoriaOcupada + tamano <= 100) {
        final index = historialProcesos.indexOf(procesoEspera);
        if (index != -1) {
          // 🔥 SOLO CAMBIA ESTADO - MANTIENE ESPERA=1min y todos los datos
          historialProcesos[index]['estado'] = 'Activo';
          procesosActivos.add(Map<String, dynamic>.from(historialProcesos[index])); // ← COPIA EXACTA
          if (context.mounted)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("🚀 '${procesoEspera['nombre']}' entra a memoria (espera ${procesoEspera['espera']} mantenida)"), backgroundColor: Colors.blue),
            );
          break;
        }
      }
    }
  }

  void reiniciarPrograma() {
    setState(() {
      procesosActivos.clear();
      historialProcesos.clear();
      _opcionSeleccionada = Opciones.primerAjuste;
      _memoriaKey = UniqueKey();
    });
    if (context.mounted)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("🔄 Reinicio completo"), backgroundColor: Colors.orange),
      );
  }

  @override
  Widget build(BuildContext context) {
    int memoriaOcupada = procesosActivos.fold(0, (sum, p) => sum + (int.tryParse(p['tamano'].toString()) ?? 0));
    int memoriaLibre = 100 - memoriaOcupada;
    
    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      appBar: AppBar(
        title: Text("📊 Memoria: ${memoriaLibre}MB | Input: 09:30 | 930 | 9.5"),
        backgroundColor: Colors.blueGrey[800],
        foregroundColor: Colors.white,
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: reiniciarPrograma)],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: BotonesAccion(
              onAgregar: agregarProceso,
              onEliminar: eliminarProceso,
              onCambioOpcion: (op) => setState(() => _opcionSeleccionada = op),
              onReinicio: reiniciarPrograma,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: VisualMemoria(
              key: _memoriaKey,
              procesos: procesosActivos,
              opcion: _opcionSeleccionada,
            ),
          ),
          Expanded(flex: 3, child: TablaProceso(procesos: historialProcesos)),
        ],
      ),
    );
  }
}