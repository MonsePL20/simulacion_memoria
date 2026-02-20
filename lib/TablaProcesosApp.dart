import 'package:flutter/material.dart';

class TablaProceso extends StatelessWidget {
  
  final List<Map<String, dynamic>> procesos;

  const TablaProceso({
    super.key,
    required this.procesos,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // 🔹 TITULO
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

            // 🔹 TABLA
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  border: TableBorder.all(),
                  headingRowColor: WidgetStateProperty.all(Colors.grey[300]),
                  columns: const [
                    DataColumn(label: Text("Nombre", style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("Tamaño", style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("Llegada", style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("Salida", style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("Atención", style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("Espera", style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: procesos.isEmpty
                      ? [
                          const DataRow(cells: [
                            DataCell(Text("-", textAlign: TextAlign.center)),
                            DataCell(Text("-", textAlign: TextAlign.center)),
                            DataCell(Text("-", textAlign: TextAlign.center)),
                            DataCell(Text("-", textAlign: TextAlign.center)),
                            DataCell(Text("-", textAlign: TextAlign.center)),
                            DataCell(Text("-", textAlign: TextAlign.center)),
                          ])
                        ]
                      : procesos.map((p) {
                          return DataRow(cells: [
                            DataCell(Text(p["nombre"] ?? "-")),
                            DataCell(Text(p["tamano"] ?? "-")),
                            DataCell(Text(p["llegada"] ?? "-")),
                            DataCell(Text(p["salida"] ?? "-")),
                            DataCell(Text(p["atencion"] ?? "-")),
                            DataCell(Text(p["espera"] ?? "-")),
                          ]);
                        }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}