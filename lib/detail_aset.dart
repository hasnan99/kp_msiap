import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kp_msiap/api/sheet_api.dart';
import 'model/sheet.dart';

class DetailAset extends StatefulWidget {
  final sheet data;
  const DetailAset({Key? key, required this.data}) : super(key: key);

  @override
  _DetailAset createState() => _DetailAset();
}

class _DetailAset extends State<DetailAset> {
  List<sheet> data = [];
  List<sheet> dataList = [];
  late var jsondata;

  @override
  void initState() {
    super.initState();
    _fetchdatalen();
  }

  Future <void> _fetchdatalen() async {
    final response = await http.get(Uri.parse(sheet_api.URL_len));
    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      setState(() {
        data = json.map((item) => sheet.fromJson(item)).toList();
        dataList = List.from(data);
      });
    } else {
      throw Exception("Failed to load Data");
    }
  }

  @override
  Widget build(BuildContext context) {
    sheet? foundAsset = dataList.firstWhereOrNull((asset) =>
    asset.Id.toString() == widget.data.Id.toString(),
    );
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Asset"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if(foundAsset == null)
            CircularProgressIndicator()
          else
            Container(
              height: 250,
              alignment: Alignment.center,
              child: Image.network(foundAsset!.gambar, height: 250),
            ),
            if(foundAsset != null)
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailItem("Nama Aset", foundAsset.nama_aset),
                      _buildDetailItem("Jenis Aset", foundAsset.jenis_aset),
                      _buildDetailItem("Kondisi", foundAsset.kondisi),
                      _buildDetailItem("Status Pemakaian", foundAsset.status_pemakaian),
                      _buildDetailItem("Utilisasi", foundAsset.utilisasi.toString()),
                      _buildDetailItem("Tahun Perolehan", foundAsset.tahun_perolehan.toString()),
                      _buildDetailItem("Umur Teknis", foundAsset.umur_teknis.toString()),
                      _buildDetailItem("Sumber Dana", foundAsset.sumber_dana),
                      _buildDetailItem("Nilai Perolehan", formatter.format(double.parse(foundAsset.nilai_perolehan.toString()??'0'))),
                      _buildDetailItem("Nilai Buku", formatter.format(double.parse(foundAsset.nilai_buku.toString()??'0'))),
                      _buildDetailItem("Rencana Optimisasi", foundAsset.rencana_optimisasi),
                      _buildDetailItem("Lokasi", foundAsset.lokasi),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
  Widget _buildDetailItem(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 15,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
