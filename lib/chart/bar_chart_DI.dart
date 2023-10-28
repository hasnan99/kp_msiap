import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../model/sheet_chart.dart';

class barChartDI extends StatefulWidget {
  final List<sheet_chart> data_chart;
  barChartDI({Key? key, required this.data_chart}) : super(key: key);

  @override
  _barChartDI createState() => _barChartDI();
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

class _barChartDI extends State<barChartDI> {
  late String selectedXValue = 'Nama Aset';
  late String selectedYValue = 'Nilai Perolehan';
  late Map<String, dynamic Function(sheet_chart)> yMappers;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    yMappers = {
      'Nama Aset':(sheet_chart sales) => sales.nama_aset,
      'Jenis Aset':(sheet_chart sales) => sales.jenis_aset,
      'kondisi':(sheet_chart sales) => sales.kondisi,
      'Status Pemakaian':(sheet_chart sales) => sales.status_pemakaian,
      'Utilisasi':(sheet_chart sales) => sales.utilisasi,
      'Tahun Perolehan':(sheet_chart sales) => sales.tahun_perolehan,
      'Umur Teknis':(sheet_chart sales) => sales.umur_teknis,
      'Sumber Dana':(sheet_chart sales) => sales.sumber_dana,
      'Nilai Perolehan':(sheet_chart sales)=> sales.nilai_perolehan,
      'Nilai Buku':(sheet_chart sales)=> sales.nilai_buku,
      'Rencana Optimisasi':(sheet_chart sales) => sales.rencana_optimisasi,

      'jumlah nama aset': (sheet_chart sales) {
        return sales.countData(widget.data_chart, 'nama_aset', sales.nama_aset??"");
      },
      'jumlah jenis aset': (sheet_chart sales) {
        return sales.countData(widget.data_chart, 'jenis_aset', sales.jenis_aset??"");
      },
      'jumlah Kondisi': (sheet_chart sales) {
        return sales.countData(widget.data_chart, 'kondisi', sales.kondisi??"");
      },
      'jumlah status pemakaian': (sheet_chart sales) {
        return sales.countData(widget.data_chart, 'status_pemakaian', sales.status_pemakaian??"");
      },
      'jumlah Utilisasi': (sheet_chart sales) {
        return sales.countData(widget.data_chart, 'utilisasi', sales.utilisasi??0);
      },
      'jumlah Tahun Perolehan': (sheet_chart sales) {
        return sales.countData(widget.data_chart, 'tahun_perolehan', sales.tahun_perolehan??0);
      },
      'jumlah umur teknis': (sheet_chart sales) {
        return sales.countData(widget.data_chart, 'umur_teknis', sales.umur_teknis??0);
      },
      'jumlah Sumber dana': (sheet_chart sales) {
        return sales.countData(widget.data_chart, 'sumber_dana', sales.sumber_dana??"");
      },
      'jumlah Nilai Perolehan': (sheet_chart sales) {
        return sales.countData(widget.data_chart, 'nilai_perolehan', sales.nilai_perolehan??0);
      },
      'jumlah Nilai Buku': (sheet_chart sales) {
        return sales.countData(widget.data_chart, 'nilai_buku', sales.nilai_buku??0);
      },
      'jumlah rencana optimisasi': (sheet_chart sales) {
        return sales.countData(widget.data_chart, 'rencana_optimisasi', sales.rencana_optimisasi??"");
      },
    };
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
          title: Text("Bar Chart DI"),
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
                Text("Jumlah Data Asset Terpilih : "+widget.data_chart.length.toString()),
              ],
            ),
          ),
          Expanded(
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              title: ChartTitle(text: 'Grafik Aset'),
              legend: Legend(isVisible: true),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<sheet_chart, String>>[
                ColumnSeries<sheet_chart, String>(
                  dataSource: widget.data_chart,
                  xValueMapper: (sheet_chart sales, _) {
                    final xMapper = widget.xMappers[selectedXValue];
                    return xMapper != null ? xMapper(sales) : null;
                  },
                  yValueMapper: (sheet_chart sales, _) {
                    final yMapper = yMappers[selectedYValue];
                    return yMapper != null ? yMapper(sales) : null;
                  },
                  dataLabelSettings: DataLabelSettings(isVisible: false),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
