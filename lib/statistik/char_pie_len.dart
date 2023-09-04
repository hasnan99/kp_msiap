import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:kp_msiap/api/sheet_api.dart';
import 'dart:convert';
import 'package:kp_msiap/model/sheet_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartPieLen extends StatefulWidget {
  ChartPieLen({Key? key}) : super(key: key);

  @override
  _ChartPieLen createState() => _ChartPieLen();

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

class _ChartPieLen extends State<ChartPieLen> {
  late Future<List<sheet_chart>> chartdata;
  int total=0;
  late String selectedXValue = 'Tahun Perolehan';
  late Map<String, dynamic Function(sheet_chart)> yMappers;

  final Map<String, List<sheet_chart>> groupedData = {};

  void updateGroupedData(List<sheet_chart> data) {
    groupedData.clear();

    for (final dataPoint in data) {
      final xValue = widget.xMappers[selectedXValue]?.call(dataPoint) ?? '';
      if (groupedData.containsKey(xValue)) {
        groupedData[xValue]!.add(dataPoint);
      } else {
        groupedData[xValue] = [dataPoint];
      }
    }
  }

  Future<List<sheet_chart>> _fetchDataLen() async {
    try {
      final response = await http.get(Uri.parse(sheet_api.URL_len));
      if (response.statusCode == 200) {
        final List<dynamic> json = jsonDecode(response.body);
        final data = json.map((item) => sheet_chart.fromJson(item)).toList();
        updateGroupedData(data); // Update the groupedData
        return data;
      } else {
        throw Exception("Failed to load Data");
      }
    } catch (e) {
      print("Error while fetching data: $e");
      // Handle the error appropriately
      return [];
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
  }


  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff4B5526),
        title: Text("Chart Pie Len"),
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
                SizedBox(width: 30),
                Text("Jumlah Data : $total"),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<sheet_chart>>(
              future: _fetchDataLen(),
              builder: (BuildContext context, AsyncSnapshot <List<sheet_chart>> snapshot) {
                if (snapshot.hasData) {
                  return SfCircularChart(
                    title: ChartTitle(text: 'Grafik Aset'),
                    legend: Legend(isVisible: true),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <CircularSeries<ChartData,String>>[
                      PieSeries<ChartData, String>(
                          dataSource: groupedData.entries.map((entry) {
                            final x = entry.key;
                            final y = entry.value.length.toInt();
                            return ChartData(x, y);
                          }).toList(),
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y,
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

class ChartData {
  final String x;
  final int y;

  ChartData(this.x, this.y);
}
