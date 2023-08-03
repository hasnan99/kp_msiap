import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle, rootBundle;
import 'package:csv/csv.dart';
import 'package:excel_to_json/excel_to_json.dart';

class upload_excel extends StatefulWidget {
  const upload_excel({Key? key}) : super(key: key);

  @override
  State<upload_excel> createState() => _upload_excel();
}

class _upload_excel extends State<upload_excel> {
  List<DataRow> _dataRows = [];
  List<String>? _headerRow;
  String? filePath;
  final List<DataColumn> _dataColumns = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      body: Column(
        children: [
          ElevatedButton(
            child: const Text("Upload File csv"),
            onPressed: () {
              _pickFile();
            },
          ),
          ElevatedButton(
            onPressed: _pickFileexcel,
            child: const Text("Upload File excel")
          ),
          if (_dataColumns != null && _dataRows.isNotEmpty)
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: _headerRow!
                      .map((header) => DataColumn(label: Text(header)))
                      .toList(),
                  rows: _dataRows,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _pickFileexcel() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result == null) return;

    final file = File(result.files.single.path!);
    final bytes = await file.readAsBytes();
    final excel = Excel.decodeBytes(bytes);

    if (excel.tables.isNotEmpty) {
      var table = excel.tables[excel.tables.keys.first]!;
      _headerRow = table.rows[0].map((cell) => cell?.value.toString()).cast<String>().toList();

      _dataRows = table.rows
          .skip(1)
          .map((row) => DataRow(
        cells: row
            .map<DataCell>((cell) => DataCell(Text(cell!.value.toString())))
            .toList(),
      ))
          .toList();

      setState(() {});
    }
  }


  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls', 'csv']
    );

    if (result == null) return;

    final file = File(result.files.single.path!);
    final input = file.openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();

    setState(() {
      _headerRow =
      List<String>.from(fields.first.map((cell) => cell.toString()));
      _dataRows = List<DataRow>.from(
        fields.skip(1).map((row) =>
            DataRow(
              cells: row.map<DataCell>((cell) =>
                  DataCell(Text(cell.toString()))).toList(),
            )),
      );
    });
  }
}