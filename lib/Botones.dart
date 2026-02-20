import 'package:flutter/material.dart';

class BotonesAccion extends StatelessWidget {
  // Avisar que se agrega informacion
  final Function(String nombre, String tamano, String llegada) alAgregar;
  final Function(String nombre, String salida) alSalir;

  const BotonesAccion({
    super.key, 
    required this.alAgregar, 
    required this.alSalir
  });

  // --- LLEGADA ---
  void _mostrarDialogoLlegada(BuildContext context) {
    final nombreCtrl = TextEditingController();
    final tamanoCtrl = TextEditingController();
    final llegadaCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Llegada'),
        content: Column(
          mainAxisSize: MainAxisSize.min, // ventana pequeña
          children: [
            TextField(controller: nombreCtrl, decoration: const InputDecoration(labelText: 'Nombre del Proceso: ')),
            TextField(controller: tamanoCtrl, decoration: const InputDecoration(labelText: 'Tamaño: ')),
            TextField(controller: llegadaCtrl, decoration: const InputDecoration(labelText: 'Tiempo de Llegada: '), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              // Envia los datos a la función principal
              alAgregar(nombreCtrl.text, tamanoCtrl.text, llegadaCtrl.text);
              Navigator.pop(context);
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  // --- SALIDA ---
  void _mostrarDialogoSalida(BuildContext context) {
    final nombreCtrl = TextEditingController();
    final salidaCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Salida'),
        content: Column(
          mainAxisSize: MainAxisSize.min,// ventana pequeña
          children: [
            TextField(controller: nombreCtrl, decoration: const InputDecoration(labelText: 'Nombre del Proceso: ')),
            TextField(controller: salidaCtrl, decoration: const InputDecoration(labelText: 'Tiempo de Salida: '), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              alSalir(nombreCtrl.text, salidaCtrl.text);
              Navigator.pop(context);
            },
            child: const Text('Salida'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Boton de llegada
        ElevatedButton.icon(
          onPressed: () => _mostrarDialogoLlegada(context),
          icon: const Icon(Icons.download),
          label: const Text('Llegada'),
        ),
        const SizedBox(height: 20),
        // Boton de salida
        ElevatedButton.icon(
          onPressed: () => _mostrarDialogoSalida(context),
          icon: const Icon(Icons.upload),
          label: const Text('Salida'),
        ),
      ],
    );
  }
}