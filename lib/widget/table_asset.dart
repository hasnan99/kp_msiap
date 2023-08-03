import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:kp_msiap/api/sheet_api.dart';
import 'package:kp_msiap/model/sheet.dart';
import 'package:intl/intl.dart';
import 'package:kp_msiap/view_table.dart';
import 'package:kp_msiap/widget/table_PAL.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class TableAsset extends StatefulWidget {
  const TableAsset({Key? key}) : super(key: key);

  @override
  _TableAssetState createState() => _TableAssetState();
}

class _TableAssetState extends State<TableAsset> {
  final GlobalKey<SfDataGridState> _sfDataGridKey = GlobalKey<SfDataGridState>();
  List<sheet> data = [];
  late List<GridColumn> columns;
  late var jsondata;

  final List<bool> _hiddenColumns = [false, false, false, false, false,false,false,false,false,false,false,false,false];

  final List<String> _columnNames = [
    'Nama Aset',
    'Jenis Aset',
    'Kondisi',
    'Status Pemakaian',
    'Utilisasi',
    'Tahun Perolehan',
    'Umur Teknis',
    'Sumber Dana',
    'Nilai Perolehan',
    'Nilai Buku',
    'Rencana Optimisasi',
    'Lokasi',
    'Gambar',
  ];

  @override
  void initState() {
    super.initState();
    sheet_api().getAssetList().then((data) {
      setState(() {
        this.data = data;
        jsondata = _dataexcel(data);
      });
    });
  }


  Future generatedata() async {
    var response = await http.get(Uri.parse(
        'https://script.google.com/macros/s/AKfycbwNAHQvcQc8WX9J6WxmdRhVlrqigCAnmp0vGfdwNkySdg5PfrtqHSvVC65mJ7ET7W6Irw/exec'));
    var list = json.decode(response.body).cast<Map<String, dynamic>>();
    var datalist =
    await list.map<sheet>((json) => sheet.fromJson(json)).toList();
    jsondata = _dataexcel(data);
    return datalist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asset Table Len'),
        actions: [
          IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text('Menu'),
            ),
            ListTile(
              leading: const Icon(Icons.remove_red_eye_outlined),
              title: const Text('Sembunyikan Kolom'),
              onTap: () {
                Navigator.pop(context);
                _showHideColumnDialog(context);
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: generatedata(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
          return snapshot.hasData ?SfDataGrid(
            tableSummaryRows: [
              GridTableSummaryRow(
                  color:Colors.indigo ,
                  showSummaryInRow: false,
                  columns:[
                    const GridSummaryColumn(
                        name: 'No',
                        columnName: 'No',
                        summaryType: GridSummaryType.count),
                    const GridSummaryColumn(
                        name: 'Nilai Perolehan',
                        columnName: 'Nilai Perolehan',
                        summaryType: GridSummaryType.sum),
                    const GridSummaryColumn(
                        name: 'Nilai Buku',
                        columnName: 'Nilai Buku',
                        summaryType: GridSummaryType.sum),
                  ],
                  position: GridTableSummaryRowPosition.bottom),
              GridTableSummaryRow(
                  color:Colors.indigo ,
                  showSummaryInRow: false,
                  columns: [
                    const GridSummaryColumn(
                        name: 'Nilai Perolehan',
                        columnName: 'Nilai Perolehan',
                        summaryType: GridSummaryType.average),
                    const GridSummaryColumn(
                        name: 'Nilai Buku',
                        columnName: 'Nilai Buku',
                        summaryType: GridSummaryType.average)
                  ],
                  position: GridTableSummaryRowPosition.bottom)
            ],
            source: jsondata,
            columns: getColumn(),
            allowSorting: true,
            allowFiltering: true,
            allowColumnsResizing: true,
            allowMultiColumnSorting: true,
          )
              :const Center(
            child: CircularProgressIndicator(
              strokeWidth:3 ,
            ),
          );
        },
      ),
    );
  }
  void _showHideColumnDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pilih Kolom yang ingin disembunyikan'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _columnNames.map((columnName) {
                    int index = _columnNames.indexOf(columnName);
                    return CheckboxListTile(
                      title: Text(columnName),
                      value: _hiddenColumns[index],
                      onChanged: (value) {
                        setState(() {
                          _hiddenColumns[index] = value!;
                          _updateVisibleColumns();
                        });
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }
  void _updateVisibleColumns() {
    List<GridColumn> newColumns = [];
    for (int i = 0; i < _columnNames.length; i++) {
      if (!_hiddenColumns[i]) {
        newColumns.add(columns[i]);
      }
    }
    setState(() {
      columns = newColumns;
    });
    _sfDataGridKey.currentState?.refresh(); // Refresh the SfDataGrid
  }

  List<GridColumn>getColumn(){
    columns = ([
      GridColumn(
        columnName: 'No',
        width: 95,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text(
            'No',
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
        GridColumn(
          columnName: 'Nama Aset',
          visible:  !_hiddenColumns[0],
          width: 220,
          label: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            child: const Text(
              'Nama Aset',
              overflow: TextOverflow.clip,
              softWrap: true,
            ),
          ),
        ),
      GridColumn(
        columnName: 'Jenis Aset',
        visible: !_hiddenColumns[1],
        width: 220,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text(
            'Jenis Aset',
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridColumn(
        columnName: 'Kondisi',
        visible: !_hiddenColumns[2],
        width: 220,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text(
            'Kondisi',
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridColumn(
        columnName: 'Status Pemakaian',
        visible: !_hiddenColumns[3],
        width: 220,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text(
            'Status Pemakaian',
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridColumn(
        columnName: 'Utilisasi',
        visible: !_hiddenColumns[4],
        width: 220,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text('Utilisasi'),
        ),
      ),
      GridColumn(
        columnName: 'Tahun Perolehan',
        visible: !_hiddenColumns[5],
        width: 220,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child:const Text('Tahun Perolehan'),
        ),
      ),
      GridColumn(
        columnName: 'Umur Teknis',
        visible: !_hiddenColumns[6],
        width: 220,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text('Umur Teknis'),
        ),
      ),
      GridColumn(
        columnName: 'Sumber Dana',
        visible: !_hiddenColumns[7],
        width: 220,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text('Sumber Dana'),
        ),
      ),
      GridColumn(
        columnName: 'Nilai Perolehan',
        visible: !_hiddenColumns[8],
        width: 220,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text('Nilai Perolehan'),
        ),
      ),
      GridColumn(
        columnName: 'Nilai Buku',
        visible: !_hiddenColumns[9],
        width: 220,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text('Nilai Buku'),
        ),
      ),
      GridColumn(
        columnName: 'Rencana Optimisasi',
        visible: !_hiddenColumns[10],
        width: 220,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text('Rencana Optimisasi'),
        ),
      ),
      GridColumn(
        columnName: 'Lokasi',
        visible: !_hiddenColumns[11],
        width: 220,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text('Lokasi'),
        ),
      ),
      GridColumn(
        columnName: 'Gambar',
        visible: !_hiddenColumns[12],
        width: 220,
        label: Container(
          padding:const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text('Gambar'),
        ),
      ),
    ]);
    return columns;
  }
}

class _dataexcel extends DataGridSource {
  _dataexcel(this.data) {
    buildDataGridRow();
  }
  List<sheet> data = [];
  List<DataGridRow> dataGridRows = [];

  void buildDataGridRow() {
    dataGridRows = data.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'No', value: dataGridRow.No),
        DataGridCell<String>(columnName: 'Nama Aset', value: dataGridRow.nama_aset),
        DataGridCell<String>(columnName: 'Jenis Aset', value: dataGridRow.jenis_aset),
        DataGridCell<String>(columnName: 'Kondisi', value: dataGridRow.kondisi),
        DataGridCell<String>(columnName: 'Status Pemakaian', value: dataGridRow.status_pemakaian),
        DataGridCell<String>(columnName: 'Utilisasi', value: dataGridRow.utilisasi),
        DataGridCell<String>(columnName: 'Tahun Perolehan', value: dataGridRow.tahun_perolehan),
        DataGridCell<String>(columnName: 'Umur Teknis', value: dataGridRow.umur_teknis),
        DataGridCell<String>(columnName: 'Sumber Dana', value: dataGridRow.sumber_dana),
        DataGridCell<int>(columnName: 'Nilai Perolehan', value: dataGridRow.nilai_perolehan),
        DataGridCell<int>(columnName: 'Nilai Buku', value: dataGridRow.nilai_buku),
        DataGridCell<String>(columnName: 'Rencana Optimisasi', value: dataGridRow.rencana_optimisasi),
        DataGridCell<String>(columnName: 'Lokasi', value: dataGridRow.lokasi),
        DataGridCell<String>(columnName: 'Gambar', value: dataGridRow.gambar),
      ]);
    }).toList(growable: false);
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[0].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[1].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[2].value,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[3].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[4].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[5].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[6].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding:const EdgeInsets.all(8.0),
        child: Text(row.getCells()[7].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[8].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(CurrencyFormat.convertToIdr(row.getCells()[9].value, 2),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(CurrencyFormat.convertToIdr(row.getCells()[10].value, 2),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[11].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[12].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Image.network(row.getCells()[13].value.toString())
      ),
    ]);
  }
  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue,
      ) {
    if(summaryColumn?.columnName=='No'){
      return Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        child:
        Text('Jumlah Data: '+summaryValue, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
    }
    if(summaryColumn?.summaryType==GridSummaryType.sum){
      final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
      return Container(
        padding: EdgeInsets.all(5.0),
        alignment: Alignment.center,
        child:
        Text('Sum '+
          formatter.format(double.parse(summaryValue)),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
    }
    if(summaryColumn?.summaryType==GridSummaryType.average){
      final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
      return Container(
        padding: EdgeInsets.all(5.0),
        alignment: Alignment.center,
        child:
        Text('average '+
            formatter.format(double.parse(summaryValue)),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
    }
  }
}

