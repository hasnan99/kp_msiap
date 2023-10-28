import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:kp_msiap/api/sheet_api.dart';
import 'dart:convert';
import 'package:kp_msiap/model/sheet.dart';
import 'package:kp_msiap/model/sheet_chart.dart';
import 'package:kp_msiap/statistik/chart_pie_PAL.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartPagePAL extends StatefulWidget {
  ChartPagePAL({Key? key}) : super(key: key);

  @override
  _ChartPagePAL createState() => _ChartPagePAL();

  final Map<String, dynamic Function(sheet_chart)> xMappers = {
    'Nama Aset':(sheet_chart sales) => sales.nama_aset,
    'Jenis Aset':(sheet_chart sales) => sales.jenis_aset,
    'kondisi':(sheet_chart sales) => sales.kondisi,
    'Status Pemakaian':(sheet_chart sales) => sales.status_pemakaian,
    'Utilisasi':(sheet_chart sales) => sales.utilisasi.toString(),
    'Tahun Perolehan':(sheet_chart sales) => sales.tahun_perolehan.toString(),
    'Umur Teknis':(sheet_chart sales) => sales.umur_teknis.toString(),
    'Sumber Dana':(sheet_chart sales) => sales.sumber_dana,
    'Nilai Perolehan':(sheet_chart sales)=> sales.nilai_perolehan.toString(),
    'Nilai Buku':(sheet_chart sales)=> sales.nilai_buku.toString(),
    'Rencana Optimisasi':(sheet_chart sales) => sales.rencana_optimisasi,
  };
}

class _ChartPagePAL extends State<ChartPagePAL> {
  List<sheet_chart> chartdata = [];
  int total=0;
  late String selectedXValue = 'Nama Aset';
  late String selectedYValue = 'Nilai Perolehan';
  late Map<String, dynamic Function(sheet_chart)> yMappers;

  Future<List<sheet_chart>> _fetchDataPAL() async {
    try {
      final response = await http.get(Uri.parse(sheet_api.URL_PAL));
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
    _fetchDataPAL().then((data){
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
        title: Text("Statistik assets PAL"),
        actions: [
          IconButton(
            icon: Icon(Icons.pie_chart),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChartPiePAL()));
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
              future: _fetchDataPAL(),
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
