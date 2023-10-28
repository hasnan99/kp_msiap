import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:kp_msiap/api/sheet_api.dart';
import 'package:http/http.dart' as http;
import '../model/mesin.dart';

class mesin_pindad extends StatefulWidget {
  const mesin_pindad({Key? key}) : super(key: key);

  @override
  _mesin_pindad createState() => _mesin_pindad();
}

class _mesin_pindad extends State<mesin_pindad> {
  List<Mesin>data = [];
  late List<GridColumn> columns;
  late _datamesin datamesin;
  late var jsondata;

  Future generatedata() async {
    try{
      final response = await http.get(Uri.parse(sheet_api.URL_mesin_pindad));
      var list = json.decode(response.body);
      List<Mesin> _jsondata = await list.map<Mesin>((json) => Mesin.fromJson(json)).toList();
      datamesin = _datamesin(_jsondata);
      return _jsondata;
    }catch(e){
      print(e.toString());
    }

  }

  List<GridColumn>_getcolumn(){
    List<GridColumn> columns;
    columns=<GridColumn>[
      GridColumn(
          columnName: 'No',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'No',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'fungsi',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Fungsi',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'jenis material',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Jenis Material',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'metode',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Metode',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'dimensi-kecil-panjang',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Panjang',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'dimensi-kecil-lebar',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Lebar',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'dimensi-kecil-tebal',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Tebal',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'dimensi-kecil-diameter',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Panjang',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'dimensi-besar-panjang',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Panjang',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'dimensi-besar-lebar',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Lebar',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'dimensi-besar-tebal',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Tebal',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'dimensi-besar-diameter',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Diameter',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'berat-kecil',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Terkecil',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'berat-besar',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Terbesar',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'panjang_kabel-pendek',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Terpendek',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'panjang_kabel-panjang',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Terpanjang',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'kapasitas_daya-kecil',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Terkecil',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'kapasitas_daya-besar',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Terbesar',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'ketinggian_jatuh-kecil',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Terkecil',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'ketinggian_jatuh-besar',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Terbesar',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'frekwensi-kecil',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Terkecil',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'frekwensi-besar',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Terbesar',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'acceleration-kecil',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Terkecil',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'acceleration-besar',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Terbesar',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'lima-gram-kecil',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Terkecil',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'lima-gram-besar',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Terbesar',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'sepuluh-gram-kecil',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Terkecil',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'sepuluh-gram-besar',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Terbesar',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'dua-puluh-gram-kecil',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Terkecil',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'dua-puluh-gram-besar',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Terbesar',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'tiga-puluh-gram-kecil',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Terkecil',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'tiga-puluh-gram-besar',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Terbesar',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'temperature-kecil',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Terkecil',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'temperature-besar',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Terbesar',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'humidity-kecil',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Terkecil',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'humidity-besar',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Terbesar',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'pulsa-kecil',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Terkecil',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
      GridColumn(
          columnName: 'pulsa-besar',
          label: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Terbesar',
              overflow: TextOverflow.ellipsis,
            ),
          )
      ),
    ];
    return columns;
  }

  Widget _getWidgetForStackedHeaderCell(String title) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.center,
        child: Text(title));
  }

  List<StackedHeaderRow>_getsubcolumn(){
    List<StackedHeaderRow> stackedHeaderRows;
    stackedHeaderRows=<StackedHeaderRow>[
      StackedHeaderRow(cells: <StackedHeaderCell>[
        StackedHeaderCell(columnNames: <String>[
          'dimensi-kecil-panjang',
          'dimensi-kecil-lebar',
          'dimensi-kecil-tebal',
          'dimensi-kecil-diameter'
        ], child: _getWidgetForStackedHeaderCell('Terkecil')),
        StackedHeaderCell(columnNames: <String>[
          'dimensi-besar-panjang',
          'dimensi-besar-lebar',
          'dimensi-besar-tebal',
          'dimensi-besar-diameter'
        ], child: _getWidgetForStackedHeaderCell('Terbesar')),
        StackedHeaderCell(columnNames: <String>[
          'berat-kecil',
          'berat-besar'
        ], child: _getWidgetForStackedHeaderCell('Berat Material')),
        StackedHeaderCell(columnNames: <String>[
          'panjang_kabel-pendek',
          'panjang_kabel-panjang'
        ], child: _getWidgetForStackedHeaderCell('Panjang Kabel')),
        StackedHeaderCell(columnNames: <String>[
          'kapasitas_daya-kecil',
          'kapasitas_daya-besar'
        ], child: _getWidgetForStackedHeaderCell('Kapasitas Daya')),
        StackedHeaderCell(columnNames: <String>[
          'ketinggian_jatuh-kecil',
          'ketinggian_jatuh-besar'
        ], child: _getWidgetForStackedHeaderCell('Ketinggian Jatuh')),
        StackedHeaderCell(columnNames: <String>[
          'frekwensi-kecil',
          'frekwensi-besar'
        ], child: _getWidgetForStackedHeaderCell('Frekwensi')),
        StackedHeaderCell(columnNames: <String>[
          'acceleration-kecil',
          'acceleration-besar'
        ], child: _getWidgetForStackedHeaderCell('Acceleration')),
        StackedHeaderCell(columnNames: <String>[
          'lima-gram-kecil',
          'lima-gram-besar'
        ], child: _getWidgetForStackedHeaderCell('5G')),
        StackedHeaderCell(columnNames: <String>[
          'sepuluh-gram-kecil',
          'sepuluh-gram-besar'
        ], child: _getWidgetForStackedHeaderCell('10G')),
        StackedHeaderCell(columnNames: <String>[
          'dua-puluh-gram-kecil',
          'dua-puluh-gram-besar'
        ], child: _getWidgetForStackedHeaderCell('20G')),
        StackedHeaderCell(columnNames: <String>[
          'tiga-puluh-gram-kecil',
          'tiga-puluh-gram-besar'
        ], child: _getWidgetForStackedHeaderCell('30G')),
        StackedHeaderCell(columnNames: <String>[
          'temperature-kecil',
          'temperature-besar'
        ], child: _getWidgetForStackedHeaderCell('Temperature')),
        StackedHeaderCell(columnNames: <String>[
          'humidity-kecil',
          'humidity-besar'
        ], child: _getWidgetForStackedHeaderCell('Humidity')),
        StackedHeaderCell(columnNames: <String>[
          'pulsa-kecil',
          'pulsa-besar'
        ], child: _getWidgetForStackedHeaderCell('Pulsa')),
      ]),
    ];
    stackedHeaderRows.insert(0,
        StackedHeaderRow(cells: [
          StackedHeaderCell(
              columnNames: [
                'dimensi-kecil-panjang',
                'dimensi-kecil-lebar',
                'dimensi-kecil-tebal',
                'dimensi-kecil-diameter',
                'dimensi-besar-panjang',
                'dimensi-besar-lebar',
                'dimensi-besar-tebal',
                'dimensi-besar-diameter',
              ],
              child: Container(
                child: Center(child: Text("Dimensi Material"),),
              ))
        ])
    );
    stackedHeaderRows.insert(0,
        StackedHeaderRow(cells: [
          StackedHeaderCell(
              columnNames: [
                'lima-gram-kecil',
                'lima-gram-besar',
                'sepuluh-gram-kecil',
                'sepuluh-gram-besar',
                'dua-puluh-gram-kecil',
                'dua-puluh-gram-besar',
                'tiga-puluh-gram-kecil',
                'tiga-puluh-gram-besar',
              ],
              child: Container(
                child: Center(child: Text("Load (Sine)"),),
              ))
        ])
    );
    return stackedHeaderRows;
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mesin Pindad'),
        backgroundColor: const Color(0xFF4B5526),
      ),
      body: FutureBuilder(
        future: generatedata(),
        builder: (context,data){
          return data.hasData ?SfDataGrid(
            source: datamesin,
            columns:_getcolumn(),
            stackedHeaderRows: _getsubcolumn(),
            columnWidthMode: ColumnWidthMode.auto,
            gridLinesVisibility: GridLinesVisibility.both,
            headerGridLinesVisibility: GridLinesVisibility.both,
            allowSorting: true,
            allowMultiColumnSorting: true,
            allowFiltering: true,

          )
              :const Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
          );
        },
      ),
    );
  }
}

class _datamesin extends DataGridSource{
  _datamesin(this.data){
    buildDataGridRow();
  }
  List<Mesin>data=[];
  List<DataGridRow> dataGridRows = [];

  void buildDataGridRow(){
    int jumlahdata=1;
    dataGridRows=data.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells:[
        DataGridCell<int>(columnName: 'No', value:jumlahdata++ ),
        DataGridCell<String>(columnName: 'fungsi', value: dataGridRow.fungsi),
        DataGridCell<String>(columnName: 'jenis material', value: dataGridRow.jenis_material),
        DataGridCell<String>(columnName: 'metode', value: dataGridRow.metode),
        DataGridCell<num>(columnName: 'dimensi-kecil-panjang', value: dataGridRow.dimensi_kecil_panjang),
        DataGridCell<num>(columnName: 'dimensi-kecil-lebar', value: dataGridRow.dimensi_besar_lebar),
        DataGridCell<num>(columnName: 'dimensi-kecil-tebal', value: dataGridRow.dimensi_kecil_tebal),
        DataGridCell<num>(columnName: 'dimensi-kecil-diameter', value: dataGridRow.dimensi_kecil_diameter),
        DataGridCell<num>(columnName: 'dimensi-besar-panjang', value: dataGridRow.dimensi_besar_panjang),
        DataGridCell<num>(columnName: 'dimensi-besar-lebar', value: dataGridRow.dimensi_besar_lebar),
        DataGridCell<num>(columnName: 'dimensi-besar-tebal', value: dataGridRow.dimensi_besar_tebal),
        DataGridCell<num>(columnName: 'dimensi-besar-diameter', value: dataGridRow.dimensi_besar_diameter),
        DataGridCell<num>(columnName: 'berat-kecil', value: dataGridRow.berat_kecil),
        DataGridCell<num>(columnName: 'berat-besar', value: dataGridRow.berat_besar),
        DataGridCell<num>(columnName: 'panjang_kabel-pendek', value: dataGridRow.panjang_kabel_pendek),
        DataGridCell<num>(columnName: 'panjang_kabel-panjang', value: dataGridRow.panjang_kabel_panjang),
        DataGridCell<num>(columnName: 'kapasitas_daya-kecil', value: dataGridRow.kapasitas_daya_kecil),
        DataGridCell<num>(columnName: 'kapasitas_daya-besar', value: dataGridRow.kapasitas_daya_besar),
        DataGridCell<num>(columnName: 'ketinggian_jatuh-kecil', value: dataGridRow.ketinggian_jatuh_kecil),
        DataGridCell<num>(columnName: 'ketinggian_jatuh-besar', value: dataGridRow.ketinggian_jatuh_besar),
        DataGridCell<num>(columnName: 'frekwensi-kecil', value: dataGridRow.frekwensi_kecil),
        DataGridCell<num>(columnName: 'frekwensi-besar', value: dataGridRow.frekwensi_besar),
        DataGridCell<num>(columnName: 'acceleration-kecil', value: dataGridRow.acceleration_kecil),
        DataGridCell<num>(columnName: 'acceleration-besar', value: dataGridRow.acceleration_besar),
        DataGridCell<num>(columnName: 'lima-gram-kecil', value: dataGridRow.lima_gram_kecil),
        DataGridCell<num>(columnName: 'lima-gram-besar', value: dataGridRow.lima_gram_besar),
        DataGridCell<num>(columnName: 'sepuluh-gram-kecil', value: dataGridRow.sepuluh_gram_kecil),
        DataGridCell<num>(columnName: 'sepuluh-gram-besar', value: dataGridRow.sepuluh_gram_besar),
        DataGridCell<num>(columnName: 'dua-puluh-gram-kecil', value: dataGridRow.dua_puluh_gram_kecil),
        DataGridCell<num>(columnName: 'dua-puluh-gram-besar', value: dataGridRow.dua_puluh_gram_besar),
        DataGridCell<num>(columnName: 'tiga-puluh-gram-kecil', value: dataGridRow.tiga_puluh_gram_kecil),
        DataGridCell<num>(columnName: 'tiga-puluh-gram-besar', value: dataGridRow.tiga_puluh_gram_besar),
        DataGridCell<num>(columnName: 'temperature-kecil', value: dataGridRow.temperature_kecil),
        DataGridCell<num>(columnName: 'temperature-besar', value: dataGridRow.temperature_besar),
        DataGridCell<num>(columnName: 'humidity-kecil', value: dataGridRow.humidity_kecil),
        DataGridCell<num>(columnName: 'humidity-besar', value: dataGridRow.humidity_besar),
        DataGridCell<num>(columnName: 'pulsa-kecil', value: dataGridRow.pulsa_kecil),
        DataGridCell<num>(columnName: 'pulsa-besar', value: dataGridRow.pulsa_besar),
      ]);
    }).toList(growable: false);
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row){
    return DataGridRowAdapter(cells: [
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[0].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[1].value.toString()),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[2].value.toString()),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[3].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[4].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[5].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[6].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[7].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[8].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[9].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[10].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[11].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[12].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[13].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[14].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[15].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[16].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[17].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[18].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[19].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[20].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[21].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[22].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[23].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[24].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[25].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[26].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[27].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[28].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[29].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[30].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[31].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[32].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[33].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[34].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[35].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[36].value.toString()),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(row.getCells()[37].value.toString()),
      ),
    ]);
  }
}
