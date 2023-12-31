import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:kp_msiap/api/sheet_api.dart';
import 'dart:convert';
import 'package:kp_msiap/model/sheet_chart.dart';
import 'package:kp_msiap/statistik/chart_pie_len.dart';
import 'package:kp_msiap/statistik/chart_pie_dahana.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartPageLen extends StatefulWidget {
  ChartPageLen({Key? key}) : super(key: key);

  @override
  _ChartPageLen createState() => _ChartPageLen();

  final Map<String, dynamic Function(sheet_chart)> xMappers = {
    'Nama Aset':(sheet_chart sales) => sales.nama_aset?.toString()??"kosong",
    'Jenis Aset':(sheet_chart sales) => sales.jenis_aset?.toString()??"kosong",
    'kondisi':(sheet_chart sales) => sales.kondisi?.toString()??"kosong",
    'Status Pemakaian':(sheet_chart sales) => sales.status_pemakaian?.toString()??"kosong",
    'Utilisasi':(sheet_chart sales) => sales.utilisasi?.toString()??"kosong",
    'Tahun Perolehan':(sheet_chart sales) => sales.tahun_perolehan?.toString()??"kosong",
    'Umur Teknis':(sheet_chart sales) => sales.umur_teknis?.toString()??"kosong",
    'Sumber Dana':(sheet_chart sales) => sales.sumber_dana?.toString()??"kosong",
    'Nilai Perolehan':(sheet_chart sales)=> sales.nilai_perolehan?.toString()??"kosong",
    'Nilai Buku':(sheet_chart sales)=> sales.nilai_buku?.toString()??"kosong",
    'Rencana Optimisasi':(sheet_chart sales) => sales.rencana_optimisasi?.toString()??"kosong",
  };
}

class _ChartPageLen extends State<ChartPageLen> {
  List<sheet_chart> chartdata = [];
  int total=0;
  late String selectedXValue = 'Nama Aset';
  late String selectedYValue = 'Nilai Perolehan';
  late Map<String, dynamic Function(sheet_chart)> yMappers;

  Future<List<sheet_chart>> _fetchDataLen() async {
    try {
      final response = await http.get(Uri.parse(sheet_api.URL_len));
      if (response.statusCode == 200) {
        final List<dynamic> json = jsonDecode(response.body);
        return json.map((item) => sheet_chart.fromJson(item)).toList();
      } else {
        throw Exception("Failed to load Data");
      }
    } catch (e) {
      print("Error while fetching data: $e");
      return []; // Return an empty list or handle the error appropriately
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchDataLen().then((data){
      setState(() {
        total=data.length;
      });
    });

    yMappers = {
      'Utilisasi':(sheet_chart sales) => sales.utilisasi,
      'Tahun Perolehan':(sheet_chart sales) => sales.tahun_perolehan,
      'Umur Teknis':(sheet_chart sales) => sales.umur_teknis,
      'Nilai Perolehan':(sheet_chart sales)=> sales.nilai_perolehan,
      'Nilai Buku':(sheet_chart sales)=> sales.nilai_buku,

      'jumlah nama aset': (sheet_chart sales) {
        return sales.countData(chartdata, 'nama_aset', sales.nama_aset??"");
      },
      'jumlah jenis aset': (sheet_chart sales) {
        return sales.countData(chartdata, 'jenis_aset', sales.jenis_aset??"");
      },
      'jumlah Kondisi': (sheet_chart sales) {
        return sales.countData(chartdata, 'kondisi', sales.kondisi??"");
      },
      'jumlah status pemakaian': (sheet_chart sales) {
        return sales.countData(chartdata, 'status_pemakaian', sales.status_pemakaian??"");
      },
      'jumlah Utilisasi': (sheet_chart sales) {
        return sales.countData(chartdata, 'utilisasi', sales.utilisasi??0);
      },
      'jumlah Tahun Perolehan': (sheet_chart sales) {
        return sales.countData(chartdata, 'tahun_perolehan', sales.tahun_perolehan??0);
      },
      'jumlah umur teknis': (sheet_chart sales) {
        return sales.countData(chartdata, 'umur_teknis', sales.umur_teknis??0);
      },
      'jumlah Sumber dana': (sheet_chart sales) {
        return sales.countData(chartdata, 'sumber_dana', sales.sumber_dana??"");
      },
      'jumlah Nilai Perolehan': (sheet_chart sales) {
        return sales.countData(chartdata, 'nilai_perolehan', sales.nilai_perolehan??0);
      },
      'jumlah Nilai Buku': (sheet_chart sales) {
        return sales.countData(chartdata, 'nilai_buku', sales.nilai_buku??0);
      },
      'jumlah rencana optimisasi': (sheet_chart sales) {
        return sales.countData(chartdata, 'rencana_optimisasi', sales.rencana_optimisasi??"");
      },
    };
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  dispose(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff4B5526),
        title: Text("Statistik asset LEN"),
        actions: [
          IconButton(
            icon: Icon(Icons.pie_chart),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChartPieLen()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Text('X:'),
                SizedBox(width: 5),
                DropdownButton<String>(
                  value: selectedXValue,
                  onChanged: (newValue) {
                    setState(() {
                      selectedXValue = newValue!;
                    });
                  },
                  items: widget.xMappers.keys.map((key) {
                    return DropdownMenuItem<String>(
                      value: key,
                      child: Text(key),
                    );
                  }).toList(),
                ),
                SizedBox(width: 10),
                Text('Y:'),
                SizedBox(width: 5),
                DropdownButton<String>(
                  value: selectedYValue,
                  onChanged: (newValue) {
                    setState(() {
                      selectedYValue = newValue!;
                    });
                  },
                  items: yMappers.keys.map((key) {
                    return DropdownMenuItem<String>(
                      value: key,
                      child: Text(key),
                    );
                  }).toList(),
                ),
                SizedBox(width: 50),
                Text("Jumlah Total Asset : $total"),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<sheet_chart>>(
              future: _fetchDataLen(),
              builder: (BuildContext context, AsyncSnapshot <List<sheet_chart>> snapshot) {
                if (snapshot.hasData) {
                  chartdata = snapshot.data!;
                  return SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    title: ChartTitle(text: 'Grafik Aset'),
                    legend: Legend(isVisible: true),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <ChartSeries<sheet_chart, String>>[
                      ColumnSeries<sheet_chart, String>(
                          dataSource: snapshot.data!,
                          xValueMapper: (sheet_chart sales, _) {
                            final xMapper = widget.xMappers[selectedXValue];
                            return xMapper != null ? xMapper(sales) : null;
                          },
                          yValueMapper: (sheet_chart sales, _) {
                            final yMapper = yMappers[selectedYValue];
                            return yMapper != null ? yMapper(sales) : null;
                          },
                          dataLabelSettings: DataLabelSettings(isVisible: false))
                    ],
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
