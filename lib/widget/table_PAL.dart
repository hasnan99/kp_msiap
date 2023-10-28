import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kp_msiap/chart/bar_chart_pal.dart';
import 'package:kp_msiap/chart/pie_chart_pal.dart';
import 'package:kp_msiap/model/sheet.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:kp_msiap/api/sheet_api.dart';
import '../model/kurs.dart';
import '../model/kurs_helper.dart';
import '../model/sheet_chart.dart';

class Table_PAL extends StatefulWidget {
  const Table_PAL({Key? key}) : super(key: key);

  @override
  _Table_PAL createState() => _Table_PAL();
}

class _Table_PAL extends State<Table_PAL> {
  final GlobalKey<SfDataGridState> _sfDataGridKey = GlobalKey<SfDataGridState>();
  List<sheet> data = [];
  late List<GridColumn> columns;
  late var jsondata;
  late _dataexcel dataexcel;
  List<sheet_chart> cellValues = [];
  final DataGridController _dataGridController = DataGridController();
  late DatabaseHelper _databaseHelper;

  final List<bool> _hiddenColumns = [false, false, false, false, false,false,false,false,false,false,false,false,false,false];

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
    'kurs',
    'Nilai Buku',
    'Rencana Optimisasi',
    'Lokasi',
    'Gambar',
  ];

  Map<int, double> exchangeRates = {
    2000:9595,
    2001:10400,
    2002:8940,
    2003:8465,
    2004:9290,
    2005:9830,
    2006:9020,
    2007:9419,
    2008:10950,
    2009:9400,
    2010:8911,
    2011:9068,
    2012:9670,
    2013:12189,
    2014:12440,
    2015:13795,
    2016:13436,
    2017:13548,
    2018:14481,
    2019:13901,
    2020:14105,
    2021:14269,
    2022:15731,
  };

  Future<void> _loadExchangeRates() async {
    final exchangeRatesFromDB = await _databaseHelper.getExchangeRates();
    exchangeRatesFromDB.forEach((rate) {
      exchangeRates[rate.year] = rate.rate;
    });

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
    _loadExchangeRates();
  }


  Future generatedata() async {
    final response = await http.get(Uri.parse(sheet_api.URL_PAL));
    var list = json.decode(response.body);
    List<sheet> _jsondata = await list.map<sheet>((json) => sheet.fromJson(json)).toList();
    dataexcel = _dataexcel(_jsondata, exchangeRates);
    return _jsondata;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff4B5526),
        title: const Text('Asset Table PAL'),
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
              leading: const Icon(Icons.visibility),
              title: const Text('Sembunyikan Kolom'),
              onTap: () {
                Navigator.pop(context);
                _showHideColumnDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Buat Bar Chart'),
              onTap: () async {
                for(var data in _dataGridController.selectedRows){
                  var Id=data.getCells()[0].value.toString();
                  var nama_aset=data.getCells()[1].value.toString();
                  var jenis_aset=data.getCells()[2].value.toString();
                  var kondisi=data.getCells()[3].value.toString();
                  var status_pemakaian=data.getCells()[4].value.toString();
                  var utilisasi=data.getCells()[5].value as int;
                  var tahun_perolehan=data.getCells()[6].value as int;
                  var umur_teknis=data.getCells()[7].value as int;
                  var sumber_dana=data.getCells()[8].value.toString();
                  var nilai_perolehan=data.getCells()[9].value as int;
                  var nilai_buku=data.getCells()[11].value as int;
                  var rencana_optimisasi=data.getCells()[12].value.toString();
                  var Sheet_values=sheet_chart(Id, nama_aset, jenis_aset, kondisi, status_pemakaian, utilisasi, tahun_perolehan, umur_teknis, sumber_dana, nilai_perolehan, nilai_buku, rencana_optimisasi);
                  cellValues.add(Sheet_values);
                }
                bool cleardata= await Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>barChartPAL(data_chart: cellValues,)));
                if(cleardata==true){
                  cellValues.clear();
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.pie_chart),
              title: const Text('Buat Pie Chart'),
              onTap: () async {
                for(var data in _dataGridController.selectedRows){
                  var Id=data.getCells()[0].value.toString();
                  var nama_aset=data.getCells()[1].value.toString();
                  var jenis_aset=data.getCells()[2].value.toString();
                  var kondisi=data.getCells()[3].value.toString();
                  var status_pemakaian=data.getCells()[4].value.toString();
                  var utilisasi=data.getCells()[5].value as int;
                  var tahun_perolehan=data.getCells()[6].value as int;
                  var umur_teknis=data.getCells()[7].value as int;
                  var sumber_dana=data.getCells()[8].value.toString();
                  var nilai_perolehan=data.getCells()[9].value as int;
                  var nilai_buku=data.getCells()[11].value as int;
                  var rencana_optimisasi=data.getCells()[12].value.toString();
                  var Sheet_values=sheet_chart(Id, nama_aset, jenis_aset, kondisi, status_pemakaian, utilisasi, tahun_perolehan, umur_teknis, sumber_dana, nilai_perolehan, nilai_buku, rencana_optimisasi);
                  cellValues.add(Sheet_values);
                }
                bool cleardata= await Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>pieChartPAL(data_chart: cellValues,)));
                if(cleardata==true){
                  cellValues.clear();
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.monetization_on),
              title: const Text('Nilai Kurs'),
              onTap: (){
                Navigator.pop(context);
                _shownilaikurs(context);
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
                  color:Color(0xff4B5526) ,
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
                  color:Color(0xff4B5526) ,
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
            source: dataexcel,
            columns: getColumn(),
            controller: _dataGridController,
            showCheckboxColumn: true,
            selectionMode: SelectionMode.multiple,
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

  void _shownilaikurs(BuildContext context) async {
    final TextEditingController _searchController = TextEditingController();
    List<MapEntry<int, double>> filteredRates = [];

    final kursList = await _databaseHelper.getExchangeRates();

    final kursMapEntries = kursList
        .map((exchangeRate) =>
        MapEntry(exchangeRate.year, exchangeRate.rate.toDouble()))
        .toList();

    kursMapEntries.sort((a, b) => a.key.compareTo(b.key));

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            filteredRates.clear();
            final query = _searchController.text.toLowerCase();
            if (query.isNotEmpty) {
              filteredRates.addAll(kursMapEntries.where((entry) =>
                  entry.key.toString().toLowerCase().contains(query)));
            } else {
              filteredRates.addAll(kursMapEntries);
            }

            return AlertDialog(
              title: const Text('Nilai Kurs'),
              insetPadding: const EdgeInsets.all(11),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Cari tahun kurs...',
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 10),
                    if (filteredRates.isNotEmpty)
                      Column(
                        children: filteredRates.map((entry) {
                          final kurs = entry.value;
                          final kursFormatted =
                          CurrencyFormat.convertToIdr(kurs, 2);
                          return ListTile(
                            title: Text('Tahun ${entry.key}'),
                            subtitle: Text(' $kursFormatted',
                                style: const TextStyle(
                                  color: Colors.black,
                                )),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                await _databaseHelper
                                    .deleteExchangeRate(entry.key);
                                setState(() {
                                  kursMapEntries.remove(entry);
                                  filteredRates.remove(entry);
                                });
                              },
                            ),
                          );
                        }).toList(),
                      )
                    else
                      const Text('Tidak ada hasil yang ditemukan.'),
                  ],
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Tutup'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showAddKursDialog(context);
                  },
                  child: const Text("Tambah Kurs"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddKursDialog(BuildContext context) async {
    final TextEditingController _yearController = TextEditingController();
    final TextEditingController _rateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Kurs'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _yearController,
                decoration: const InputDecoration(
                  hintText: 'Tahun',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _rateController,
                decoration: const InputDecoration(
                  hintText: 'Nilai Kurs',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                final String year = _yearController.text;
                final String rate = _rateController.text;
                if (year.isNotEmpty && rate.isNotEmpty) {
                  final int yearInt = int.tryParse(year) ?? 0;
                  final double rateDouble = double.tryParse(rate) ?? 0.0;
                  final exchangeRate = ExchangeRate(yearInt, rateDouble);

                  final databaseHelper = DatabaseHelper();
                  await databaseHelper.insertExchangeRate(exchangeRate);

                  setState(() {});

                  _yearController.clear();
                  _rateController.clear();
                }
                Navigator.pop(context);
              },
              child: const Text('Tambah'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
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
        columnName: 'Nilai Perolehan Dolar',
        visible: !_hiddenColumns[9],
        width: 220,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text('Kurs Dolar'),
        ),
      ),
      GridColumn(
        columnName: 'Nilai Buku',
        visible: !_hiddenColumns[10],
        width: 220,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text('Nilai Buku'),
        ),
      ),
      GridColumn(
        columnName: 'Rencana Optimisasi',
        visible: !_hiddenColumns[12],
        width: 220,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text('Rencana Optimisasi'),
        ),
      ),
      GridColumn(
        columnName: 'Lokasi',
        visible: !_hiddenColumns[12],
        width: 220,
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Text('Lokasi'),
        ),
      ),
      GridColumn(
        columnName: 'Gambar',
        visible: !_hiddenColumns[13],
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

class CurrencyFormat {
  static String convertToIdr(dynamic number, int decimalDigit) {
      NumberFormat currencyFormatter = NumberFormat.currency(
        locale: 'id',
        symbol: 'Rp ',
        decimalDigits: decimalDigit,
      );
      return currencyFormatter.format(number);
  }
}

class _dataexcel extends DataGridSource {
  final Map<int, double> exchangeRates;
  _dataexcel(this.data, this.exchangeRates) {
    buildDataGridRow();
  }
  List<sheet> data = [];
  List<DataGridRow> dataGridRows = [];

  String formatDate(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    return formattedDate;
  }

  void buildDataGridRow() {
    int jumlahdata=1;
    dataGridRows = data.map<DataGridRow>((dataGridRow) {
      double exchangeRate = exchangeRates[dataGridRow.tahun_perolehan] ?? 0.0;
      double nilaiPerolehan = dataGridRow.nilai_perolehan?.toDouble()??0;
      double nilaiPerolehanDolar = nilaiPerolehan / exchangeRate;

      final formatter = NumberFormat.currency(
        locale: 'en_US',
        symbol: '\$',
      );

      String nilaiPerolehanDolarFormatted = formatter.format(nilaiPerolehanDolar);
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'No', value: jumlahdata++),
        DataGridCell<String>(columnName: 'Nama Aset', value: dataGridRow.nama_asset),
        DataGridCell<String>(columnName: 'Jenis Aset', value: dataGridRow.jenis_asset),
        DataGridCell<String>(columnName: 'Kondisi', value: dataGridRow.kondisi),
        DataGridCell<String>(columnName: 'Status Pemakaian', value: dataGridRow.status_pemakaian),
        DataGridCell<int>(columnName: 'Utilisasi', value: dataGridRow.utilisasi),
        DataGridCell<int>(columnName: 'Tahun Perolehan', value: dataGridRow.tahun_perolehan),
        DataGridCell<int>(columnName: 'Umur Teknis', value: dataGridRow.umur_teknis),
        DataGridCell<String>(columnName: 'Sumber Dana', value: dataGridRow.sumber_dana),
        DataGridCell<int?>(columnName: 'Nilai Perolehan', value: dataGridRow.nilai_perolehan),
        DataGridCell<int>(columnName: 'Nilai Perolehan Dolar', value: dataGridRow.nilai_perolehan_dollar),
        DataGridCell<int?>(columnName: 'Nilai Buku', value: dataGridRow.nilai_buku),
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
        child: Text(row.getCells()[2].value.toString(),
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
        child: Text(row.getCells()[6].value.toString() ,
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
        child: Text(row.getCells()[10].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(CurrencyFormat.convertToIdr(row.getCells()[11].value, 2),
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
        child: Text(row.getCells()[13].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Image.network(row.getCells()[14].value.toString())
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
    if(summaryColumn?.columnName =='No' && summaryColumn?.columnName != 'Nilai buku'&& summaryColumn?.columnName != 'Nilai Perolehan'){
      return Container(
        alignment: Alignment.center,
        child:
        Text('Jumlah Data: '+summaryValue, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
    }
    else if(summaryColumn?.summaryType==GridSummaryType.sum){
      final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
      return Container(
        padding: const EdgeInsets.all(5.0),
        alignment: Alignment.center,
        child:
        Text('Total: ${formatter.format(double.parse(summaryValue))}',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
    }
    else if(summaryColumn?.summaryType==GridSummaryType.average){
      final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
      return Container(
        padding: const EdgeInsets.all(5.0),
        alignment: Alignment.center,
        child:
        Text('Rata-Rata: ${formatter.format(double.parse(summaryValue))}',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
    }
  }
}

