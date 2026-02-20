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

            const SizedBox(height: 10),// Espacio entre título y tabla

            // 🔹 TABLA CON SCROLL
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowHeight: 50,// Altura de encabezado
                    dataRowMinHeight: 40,// Altura mínima de filas
                    dataRowMaxHeight: 50,// Altura máxima de filas
                    columnSpacing: 20,
                    horizontalMargin: 15,
                    border: TableBorder.all(color: Colors.grey),
                    headingRowColor: WidgetStateProperty.all(Colors.grey[300]),
                    columns: const [
                      DataColumn(
                        label: Text("Nombre Proceso", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                      ),
                      DataColumn(
                        label: Text("Tamaño", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                      ),
                      DataColumn(
                        label: Text("Tiempo Llegada", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                      ),
                      DataColumn(
                        label: Text("Tiempo Salida", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                      ),
                      DataColumn(
                        label: Text("Tiempo Atencion", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                      ),
                      DataColumn(
                        label: Text("Tiempo Espera", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                      ),
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
                            return DataRow(
                              cells: [
                                DataCell(
                                  SizedBox(
                                    width: 80,
                                    child: Text(p["nombre"] ?? "-", overflow: TextOverflow.ellipsis),// Evitar texto largo
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 60,
                                    child: Text(p["tamano"] ?? "-", textAlign: TextAlign.center),// Centrar texto
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 60,
                                    child: Text(p["llegada"] ?? "-", textAlign: TextAlign.center),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 60,
                                    child: Text(p["salida"] ?? "-", textAlign: TextAlign.center),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 60,
                                    child: Text(p["atencion"] ?? "-", textAlign: TextAlign.center),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 60,
                                    child: Text(p["espera"] ?? "-", textAlign: TextAlign.center),
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