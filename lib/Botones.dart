import 'package:flutter/material.dart';

class BotonesAccion extends StatelessWidget {

  final Function(String, String, String) onAgregar;
  final Function(String) onEliminar;

  const BotonesAccion({
    super.key,
    required this.onAgregar,
    required this.onEliminar,
  });

  // 📌 Dialogo para AGREGAR proceso
  void dialogoAgregar(BuildContext context) {
    final nombreCtrl = TextEditingController();
    final tamanoCtrl = TextEditingController();
    final llegadaCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Agregar Proceso"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreCtrl,
              decoration: const InputDecoration(labelText: "Nombre del Proceso"),
            ),
            const SizedBox(height: 10),// Espacio entre campos
            TextField(
              controller: tamanoCtrl,
              decoration: const InputDecoration(labelText: "Tamaño (KB)"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),// Espacio entre campos
            TextField(
              controller: llegadaCtrl,
              decoration: const InputDecoration(labelText: "Tiempo de Llegada"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              if (nombreCtrl.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("El nombre es obligatorio")),
                );
                return;
              }
              onAgregar(nombreCtrl.text, tamanoCtrl.text, llegadaCtrl.text);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Proceso agregado correctamente")),
              );
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  // 📌 Dialogo para ELIMINAR proceso (CON CONFIRMACIÓN)
  void dialogoEliminar(BuildContext context) {
    final nombreCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Eliminar Proceso"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreCtrl,
              decoration: const InputDecoration(labelText: "Nombre del Proceso"),
            ),
            const SizedBox(height: 10),
            const Text(
              "¿Está seguro de eliminar este proceso?",
              style: TextStyle(color: Colors.red, fontSize: 12),// Advertencia
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              if (nombreCtrl.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Ingrese el nombre")),
                );
                return;
              }
              onEliminar(nombreCtrl.text);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Proceso eliminado correctamente")),
              );
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
        
        // 🔹 Botón LLEGADA (Agregar)
        ElevatedButton.icon(
          onPressed: () => dialogoAgregar(context),
          icon: const Icon(Icons.add),
          label: const Text("Llegada"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 75),// Tamaño grande
          ),
        ),
        
        const SizedBox(height: 50),// Espacio entre botones
        
        // 🔹 Botón SALIDA (Eliminar con confirmación)
        ElevatedButton.icon(
          onPressed: () => dialogoEliminar(context),
          icon: const Icon(Icons.delete),
          label: const Text("Salida"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 75),// Tamaño grande
          ),
        ),
      ],
    );
  }
}