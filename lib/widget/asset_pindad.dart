import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:kp_msiap/api/sheet_api.dart';
import 'package:kp_msiap/edit%20data/edit_asset_pindad.dart';
import 'package:kp_msiap/model/sheet.dart';
import 'package:intl/intl.dart';

import '../model/kurs_helper.dart';

class Assetpindad extends StatefulWidget {
  final GlobalKey<_Assetpindad> assetItemKey = GlobalKey<_Assetpindad>();
  final String query;
   Assetpindad({Key? key, required this.query}) : super(key: key);

  @override
  _Assetpindad createState() => _Assetpindad();

  static void refreshData(BuildContext context) {
    final state = _Assetpindad.of(context);
    state.refreshData();
  }
}

class _Assetpindad extends State<Assetpindad> {
  List<sheet>data = [];
  List<sheet> cari_data = [];
  TextEditingController controller_cari = TextEditingController();
  late Future<List<sheet>> dataFuture;
  late DatabaseHelper _databaseHelper;

  static _Assetpindad of(BuildContext context) =>
      context.findAncestorStateOfType<_Assetpindad>()!;

  Map<int, double> exchangeRates = {};

  Future<void> _loadExchangeRates() async {
    final exchangeRatesFromDB = await _databaseHelper.getExchangeRates();
    exchangeRatesFromDB.forEach((rate) {
      exchangeRates[rate.year] = rate.rate;
    });

    setState(() {});
  }


  Future<List<sheet>> _fetchdatapindad() async {
    List<sheet> newData = await sheet_api.getAssetpindad();
    setState(() {
      data = newData;
      caridata(controller_cari.text);
    });
    return newData;
  }

  void refreshData() {
    setState(() {
      dataFuture = _fetchdatapindad();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchdatapindad();
    dataFuture= _fetchdatapindad();
    _databaseHelper = DatabaseHelper();
    _loadExchangeRates();
    controller_cari.text= widget.query;
  }

  void caridata(String query) {
    setState(() {
      if (query.isEmpty) {
        cari_data = data;
      } else {
        cari_data = data
            .where((asset) =>
            asset.nama_asset.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  String cutnamaaset(String assetName) {
    List<String> words = assetName.split(' ');
    if (words.length > 4) {
      return words.sublist(0, 4).join(' ');
    } else {
      return assetName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller_cari,
              decoration: InputDecoration(
                hintText: "Cari Aset",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: caridata,
            ),
          ),
          FutureBuilder<List<sheet>>(
            future: dataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                int jumlah_data=1;
                return GridView.builder(
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 15),
                  itemCount: cari_data.length,
                  itemBuilder: (context, index) {
                    double exchangeRate = exchangeRates[cari_data[index].tahun_perolehan] ?? 0.0;
                    double nilaiPerolehan = cari_data[index].nilai_perolehan?.toDouble()??0;
                    double nilaiPerolehanDolar = nilaiPerolehan / exchangeRate;
                    var array_gambar = jsonDecode(cari_data[index].gambar ?? '[]');
                    List? url_gambar = array_gambar != null ? List.from(array_gambar) : null;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AssetDetailPage(
                              data: cari_data[index],
                              refreshCallback: _fetchdatapindad,
                              nilaiPerolehanDolar: nilaiPerolehanDolar,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xffeef1f4),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 10),
                              alignment: Alignment.center,
                              child: cari_data[index].gambar != null
                                  ? Image.network(url_gambar?.last,
                                height: 150,)
                                  : Text("Gambar belum ditambahkan."),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 10),
                              alignment: Alignment.topLeft,
                              child:
                              Text("No : ${jumlah_data++}"),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 10),
                              alignment: Alignment.topLeft,
                              child:
                              Text("ID : ${cari_data[index].id}"),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 10),
                              alignment: Alignment.center,
                              child: Text(
                                  "Nama Aset : ${cutnamaaset(cari_data[index].nama_asset)}"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Text('No data');
              }
            },
          ),
        ],
      ),
    );
  }
}

class AssetDetailPage extends StatefulWidget {
  final sheet data;
  final VoidCallback refreshCallback;
  final double nilaiPerolehanDolar;

  const AssetDetailPage({Key? key, required this.data, required this.refreshCallback, required this.nilaiPerolehanDolar}) : super(key: key);

  @override
  _AssetDetailPageState createState() => _AssetDetailPageState();
}

class _AssetDetailPageState extends State<AssetDetailPage> {
  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    final formatterdolar = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
    );
    final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();
    Future<void> _refreshData() async {
      widget.refreshCallback();
    }

    var array_gambar=jsonDecode(widget.data.gambar?? '[]');
    List? url_gambar = array_gambar != null ? List.from(array_gambar) : null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff4B5526),
        title: const Text("Detail Asset"),
      ),
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: _refreshData,
        child: SingleChildScrollView(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 250,
            alignment: Alignment.center,
            child:  widget.data.gambar != null && widget.data.gambar!.isNotEmpty
                ? Image.network(url_gambar?.last, height: 250)
                : Text("Gambar Belum ada"),
          ),
          Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailItem("Nama Aset", widget.data.nama_asset),
                    _buildDetailItem("Jenis Aset", widget.data.jenis_asset??""),
                    _buildDetailItem("Kondisi", widget.data.kondisi??""),
                    _buildDetailItem("Status Pemakaian", widget.data.status_pemakaian??""),
                    _buildDetailItem("Utilisasi", widget.data.utilisasi.toString()),
                    _buildDetailItem("Tahun Perolehan", widget.data.tahun_perolehan.toString()),
                    _buildDetailItem("Umur Teknis", widget.data.umur_teknis.toString()),
                    _buildDetailItem("Sumber Dana", widget.data.sumber_dana??""),
                    _buildDetailItem("Nilai Perolehan", formatter.format(double.parse(widget.data.nilai_perolehan.toString()))),
                    _buildDetailItem("Nilai Perolehan Dollar", widget.data.nilai_perolehan_dollar.toString()),
                    _buildDetailItem("Nilai Buku", formatter.format(double.parse(widget.data.nilai_buku.toString()))),
                    _buildDetailItem("Rencana Optimisasi", widget.data.rencana_optimisasi??""),
                    _buildDetailItem("Lokasi", widget.data.lokasi??""),
                    _buildDetailItem("Merk", widget.data.merk??""),
                    _buildDetailItem("Tipe Mesin", widget.data.tipe_mesin??""),
                    _buildDetailItem("Fungsi Mesin", widget.data.kategori_fungsi_mesin??""),
                    _buildDetailItem("Raw Material", widget.data.raw_material??""),
                    _buildDetailItem("Data Sheet", widget.data.data_sheet??""),
                    _buildDetailItem("Kartu Mesin", widget.data.kartu_mesin??""),
                    _buildDetailItem("Kartu Elektronik", widget.data.kartu_elektronik??""),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => EditAsset_pindad(data: widget.data))).
          whenComplete(() => _refreshData());
        },
        icon: const Icon(Icons.edit),
        label: const Text("Edit Data"),
        backgroundColor: const Color(0xff4B5526),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return InkWell(
      onTap: () async {
        if (label == "Data Sheet" && value.isNotEmpty) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PDFScreen(pdfUrl: value),
            ),
          );
        } else if (label == "Kartu Mesin" && value.isNotEmpty) {
          await showDialog(
            context: context,
            builder: (context) => imageDialog(label, value, context),
          );
        }
      },
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
            style: label == "Data Sheet" || label == "Kartu Mesin"
                ? const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.blue,
              decoration: TextDecoration.underline,
            )
                : const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}

Widget imageDialog(text, path, context) {
  return Dialog(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$text',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.close_rounded),
                color: Colors.redAccent,
              ),
            ],
          ),
        ),
        Container(
          width: 400,
          height: 550,
          child: Image.network(
            '$path',
            fit: BoxFit.cover,
          ),
        ),
      ],
    ),
  );
}

class PDFScreen extends StatelessWidget {
  final String pdfUrl;

  PDFScreen({required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Sheet'),
        backgroundColor: const Color(0xff4B5526),
      ),
      body:  PDF().cachedFromUrl(
        pdfUrl,
        placeholder: (progress) => Center(child: Text('$progress %')),
        errorWidget: (error) => Center(child: Text(error.toString())),
      ),

    );
  }
}
