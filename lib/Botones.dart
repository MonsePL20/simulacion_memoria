import 'package:flutter/material.dart';

class BotonesAccion extends StatelessWidget {

  final Function(String, String, String) alAgregar;
  final Function(String) alEliminar;

  const BotonesAccion({
    super.key,
    required this.alAgregar,
    required this.alEliminar,
  });

  // LLEGADA
  void dialogoLlegada(BuildContext context) {
    final nombreCtrl = TextEditingController();
    final tamanoCtrl = TextEditingController();
    final llegadaCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Agregar Proceso"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nombreCtrl, decoration: const InputDecoration(labelText: "Nombre")),
            TextField(controller: tamanoCtrl, decoration: const InputDecoration(labelText: "Tamaño")),
            TextField(controller: llegadaCtrl, decoration: const InputDecoration(labelText: "Tiempo Llegada")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () {
              if (nombreCtrl.text.isEmpty) return;
              alAgregar(nombreCtrl.text, tamanoCtrl.text, llegadaCtrl.text);
              Navigator.pop(context);
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  // SALIDA
  void dialogoSalida(BuildContext context) {
    final nombreCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Eliminar Proceso"),
        content: TextField(
          controller: nombreCtrl,
          decoration: const InputDecoration(labelText: "Nombre del Proceso"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () {
              alEliminar(nombreCtrl.text);
              Navigator.pop(context);
            },
            child: const Text("Confirmar"),
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
        ElevatedButton.icon(
          onPressed: () => dialogoLlegada(context),
          icon: const Icon(Icons.add),
          label: const Text("Llegada"),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () => dialogoSalida(context),
          icon: const Icon(Icons.delete),
          label: const Text("Salida"),
        ),
      ],
    );
  }
}