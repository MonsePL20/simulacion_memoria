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
                  "TABLA DE PROCESOS",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // TABLA CON SCROLL
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowHeight: 50,
                    dataRowMinHeight: 40,
                    dataRowMaxHeight: 50,
                    columnSpacing: 20,
                    horizontalMargin: 15,
                    border: TableBorder.all(color: Colors.grey),
                    headingRowColor: WidgetStateProperty.all(Colors.grey[300]),
                    columns: const [
                      // 1. Nombre Proceso
                      DataColumn(
                        label: Text("Nombre Proceso", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                      ),
                      // 2. Tamaño
                      DataColumn(
                        label: Text("Tamaño", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                      ),
                      // 3. duracion Tiempo
                      DataColumn(
                        label: Text("Duracion Tiempo", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                      ),
                      // 4. Tiempo Llegada
                      DataColumn(
                        label: Text("Tiempo Llegada", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                      ),
                      // 5. Tiempo Atención
                      DataColumn(
                        label: Text("Tiempo Atención", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                      ),
                      // 6. Tiempo Salida
                      DataColumn(
                        label: Text("Tiempo Salida", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                      ),
                      // 7. Tiempo Espera
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
                              DataCell(Text("-", textAlign: TextAlign.center)),
                            ])
                          ]
                        : procesos.map((p) {
                            return DataRow(
                              cells: [
                                // 1. Nombre Proceso
                                DataCell(
                                  SizedBox(
                                    width: 90,
                                    child: Text(p["nombre"] ?? "-", overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                                // 2. Tamaño
                                DataCell(
                                  SizedBox(
                                    width: 70,
                                    child: Text("${p["tamano"]} MB", textAlign: TextAlign.center),
                                  ),
                                ),
                                // 3. duracion Tiempo
                                DataCell(
                                  SizedBox(
                                    width: 90,
                                    child: Text(p["duracion"] ?? "-", textAlign: TextAlign.center),
                                  ),
                                ),
                                // 4. Tiempo Llegada
                                DataCell(
                                  SizedBox(
                                    width: 90,
                                    child: Text(p["llegada"] ?? "-", textAlign: TextAlign.center),
                                  ),
                                ),
                                // 5. Tiempo Atención
                                DataCell(
                                  SizedBox(
                                    width: 90,
                                    child: Text(p["atencion"] ?? "-", textAlign: TextAlign.center),
                                  ),
                                ),
                                // 6. Tiempo Salida
                                DataCell(
                                  SizedBox(
                                    width: 90,
                                    child: Text(p["salida"] ?? "-", textAlign: TextAlign.center),
                                  ),
                                ),
                                // 7. Tiempo Espera
                                DataCell(
                                  SizedBox(
                                    width: 90,
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