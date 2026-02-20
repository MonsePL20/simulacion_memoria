import 'package:flutter/material.dart';

void main() => runApp(const TablaProcesosApp());

class TablaProcesosApp extends StatelessWidget {
  const TablaProcesosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TablaProcesosScreen(),
    );
  }
}

class TablaProcesosScreen extends StatelessWidget {
  const TablaProcesosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[200], // 🔵 Color de fondo
      appBar: AppBar(
        title: const Text('Tabla de Procesos'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Row(
        children: [
          const Spacer(), // Empuja la tabla hacia la derecha

          Padding(
            padding: const EdgeInsets.all(20.0),// Espacio alrededor de la tabla
            child: Container(
              color: Colors.white, // ⚪ Fondo blanco de la tabla
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  border: TableBorder.all(),
                  columns: const [
                    DataColumn(label: Text('Nombre de Proceso')),
                    DataColumn(label: Text('Tamaño')),
                    DataColumn(label: Text('Tiempo de Llegada')),
                    DataColumn(label: Text('Tiempo de Salida')),
                    DataColumn(label: Text('Tiempo de Atención')),
                    DataColumn(label: Text('Tiempo de Espera')),
                  ],
                  rows: const [
                    DataRow(cells: [
                      DataCell(Text('P1')),
                      DataCell(Text('120 KB')),
                      DataCell(Text('0')),
                      DataCell(Text('5')),
                      DataCell(Text('5')),
                      DataCell(Text('0')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('P2')),
                      DataCell(Text('200 KB')),
                      DataCell(Text('2')),
                      DataCell(Text('8')),
                      DataCell(Text('6')),
                      DataCell(Text('2')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('P3')),
                      DataCell(Text('150 KB')),
                      DataCell(Text('4')),
                      DataCell(Text('10')),
                      DataCell(Text('6')),
                      DataCell(Text('3')),
                    ]),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}