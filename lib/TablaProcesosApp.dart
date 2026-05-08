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
      padding: const EdgeInsets.all(16),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // TITULO
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.blueGrey[200],
              child: const Center(
                child: Text(
                  "📋 TABLA DE PROCESOS",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // TABLA CON 8 COLUMNAS (AGREGADA ESTADO)
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowHeight: 50,
                    dataRowMinHeight: 40,
                    dataRowMaxHeight: 50,
                    columnSpacing: 15, // ← REDUCIDO para 8 columnas 
                    horizontalMargin: 10,
                    border: TableBorder.all(color: Colors.grey),
                    headingRowColor: WidgetStateProperty.all(Colors.grey[300]),
                    columns: const [
                      DataColumn(label: Text("Nombre", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                      DataColumn(label: Text("Tamaño", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                      DataColumn(label: Text("Duración", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                      DataColumn(label: Text("Llegada", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                      DataColumn(label: Text("Atención", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                      DataColumn(label: Text("Salida", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                      DataColumn(label: Text("Espera", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                      DataColumn(label: Text("Estado", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))), // ← NUEVA
                    ],
                    rows: procesos.isEmpty
                        ? [const DataRow(cells: [
                            DataCell(Text("-", textAlign: TextAlign.center)),
                            DataCell(Text("-", textAlign: TextAlign.center)),
                            DataCell(Text("-", textAlign: TextAlign.center)),
                            DataCell(Text("-", textAlign: TextAlign.center)),
                            DataCell(Text("-", textAlign: TextAlign.center)),
                            DataCell(Text("-", textAlign: TextAlign.center)),
                            DataCell(Text("-", textAlign: TextAlign.center)),
                            DataCell(Text("-", textAlign: TextAlign.center)), // ← NUEVA
                          ])]
                        : procesos.map((p) {
                            return DataRow(
                              cells: [
                                DataCell(SizedBox(width: 70, child: Text(p["nombre"] ?? "-", overflow: TextOverflow.ellipsis))),
                                DataCell(SizedBox(width: 60, child: Text("${p["tamano"]} MB", textAlign: TextAlign.center))),
                                DataCell(SizedBox(width: 70, child: Text(p["duracion"] ?? "-", textAlign: TextAlign.center))),
                                DataCell(SizedBox(width: 70, child: Text(p["llegada"] ?? "-", textAlign: TextAlign.center))),
                                DataCell(SizedBox(width: 70, child: Text(p["atencion"] ?? "-", textAlign: TextAlign.center))),
                                DataCell(SizedBox(width: 70, child: Text(p["salida"] ?? "-", textAlign: TextAlign.center))),
                                DataCell(SizedBox(width: 70, child: Text(p["espera"] ?? "-", textAlign: TextAlign.center))),
                                DataCell( // ← NUEVA COLUMNA ESTADO
                                  SizedBox(
                                    width: 80,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: p["estado"] == "Activo" ? Colors.green[100] :
                                               p["estado"] == "Eliminado" ? Colors.red[100] :
                                               Colors.orange[100],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        p["estado"] ?? "-",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: p["estado"] == "Activo" ? Colors.green[800] :
                                                 p["estado"] == "Eliminado" ? Colors.red[800] :
                                                 Colors.orange[800],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}