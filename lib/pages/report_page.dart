import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  final String report;

  const ReportPage({Key? key, required this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rows = report.split('\n').map((row) {
      final cells = row.split(';');
      return DataRow(cells: [
        DataCell(cells.length > 0 ? Flexible(child: Text(cells[0])) : Text('')),
        DataCell(cells.length > 1 ? Flexible(child: Text(cells[1])) : Text('')),
        DataCell(cells.length > 2 ? Flexible(child: Text(cells[2])) : Text('')),
        DataCell(cells.length > 3 ? Flexible(child: Text(cells[3])) : Text('')),
        DataCell(cells.length > 4 ? Flexible(child: Text(cells[4])) : Text('')),
        DataCell(cells.length > 5 ? Flexible(child: Text(cells[5])) : Text('')),
      ]);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Report')),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: const [
            DataColumn(label: Flexible(child: Text('Pedido'))),
            DataColumn(label: Flexible(child: Text('Tipo de pedido'))),
            DataColumn(label: Flexible(child: Text('Qtde Ingrediente 1'))),
            DataColumn(label: Flexible(child: Text('Qtde Ingrediente 2'))),
            DataColumn(label: Flexible(child: Text('Qtde Ingrediente 3'))),
            DataColumn(label: Flexible(child: Text('Tempo do pedido'))),
          ],
          rows: rows,
        ),
      ),
    );
  }
}
