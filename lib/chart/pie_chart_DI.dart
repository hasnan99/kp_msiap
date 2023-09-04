import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../model/sheet_chart.dart';


class pieChartDI extends StatefulWidget {
  final List<sheet_chart> data_chart;
  pieChartDI({Key? key, required this.data_chart}) : super(key: key);

  @override
  _pieChartDI createState() => _pieChartDI();
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

class _pieChartDI extends State<pieChartDI> {
  late String selectedXValue = 'Tahun Perolehan';
  late Map<String, dynamic Function(sheet_chart)> yMappers;
  final Map<String, List<sheet_chart>> groupedData = {};

  void updateGroupedData() {
    groupedData.clear();

    for (final dataPoint in widget.data_chart) {
      final xValue = widget.xMappers[selectedXValue]?.call(dataPoint) ?? '';

      if (groupedData.containsKey(xValue)) {
        groupedData[xValue]!.add(dataPoint);
      } else {
        groupedData[xValue] = [dataPoint];
      }
    }
  }

  @override
  void initState() {
    super.initState();
    updateGroupedData();
  }

  @override
  Widget build(BuildContext context) {
    updateGroupedData();
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xff4B5526),
          title: Text("Pie Chart DI"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
            },
          )
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
                Text("Jumlah Data Asset Asset : "+widget.data_chart.length.toString()),
              ],
            ),
          ),
          Expanded(
            child: SfCircularChart(
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
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                )
              ],
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
