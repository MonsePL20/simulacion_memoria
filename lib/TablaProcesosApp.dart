import 'package:flutter/material.dart';
import 'Botones.dart';

class TablaProcesosLayout extends StatefulWidget {
  const TablaProcesosLayout({super.key});

  @override
  State<TablaProcesosLayout> createState() => _TablaProcesosLayoutState();
}

class _TablaProcesosLayoutState extends State<TablaProcesosLayout> {

  List<Map<String, String>> procesos = [];

  // AGREGAR
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

  // ELIMINAR CON VALIDACIÓN
  void eliminarProceso(String nombre) {
    final existe = procesos.any((p) => p["nombre"] == nombre);

    if (!existe) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Proceso no encontrado")),
      );
      return;
    }

    setState(() {
      procesos.removeWhere((p) => p["nombre"] == nombre);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Proceso eliminado correctamente")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        const SizedBox(width: 40),

        // 🔹 BOTONES IZQUIERDA
        BotonesAccion(
          alAgregar: agregarProceso,
          alEliminar: eliminarProceso,
        ),

        const SizedBox(width: 40),

        // 🔹 TABLA DERECHA
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  // TITULO
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    color: Colors.blueGrey[200],
                    child: const Center(
                      child: Text(
                        "TABLA DE PROCESOS",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      border: TableBorder.all(),
                      columns: const [
                        DataColumn(label: Text("Nombre")),
                        DataColumn(label: Text("Tamaño")),
                        DataColumn(label: Text("Llegada")),
                        DataColumn(label: Text("Salida")),
                        DataColumn(label: Text("Atención")),
                        DataColumn(label: Text("Espera")),
                      ],
                      rows: procesos.map((p) {
                        return DataRow(cells: [
                          DataCell(Text(p["nombre"]!)),
                          DataCell(Text(p["tamano"]!)),
                          DataCell(Text(p["llegada"]!)),
                          DataCell(Text(p["salida"]!)),
                          DataCell(Text(p["atencion"]!)),
                          DataCell(Text(p["espera"]!)),
                        ]);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}