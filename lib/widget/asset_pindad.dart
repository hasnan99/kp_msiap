import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kp_msiap/api/sheet_api.dart';
import 'package:kp_msiap/edit%20data/edit_asset_pindad.dart';
import 'package:kp_msiap/model/sheet.dart';
import 'package:intl/intl.dart';

class Assetpindad extends StatefulWidget {
  final GlobalKey<_Assetpindad> assetItemKey = GlobalKey<_Assetpindad>();
   Assetpindad({Key? key}) : super(key: key);

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

  static _Assetpindad of(BuildContext context) =>
      context.findAncestorStateOfType<_Assetpindad>()!;


  Future<List<sheet>> _fetchdatapindad() async {
    List<sheet> newData = await sheet_api.getAssetpindad();
    setState(() {
      data = newData;
      caridata(controller_cari.text); // Apply current search query
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
  }

  void caridata(String query) {
    setState(() {
      if (query.isEmpty) {
        cari_data = data;
      } else {
        cari_data = data
            .where((asset) =>
            asset.nama_aset.toLowerCase().contains(query.toLowerCase()))
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
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AssetDetailPage(
                              data: cari_data[index],
                              refreshCallback: _fetchdatapindad,
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
                                  ? Image.network(
                                  cari_data[index].gambar,
                                  height: 170)
                                  : Text("Gambar belum ditambahkan."),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 10),
                              alignment: Alignment.topLeft,
                              child:
                              Text("ID : ${cari_data[index].Id}"),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 10),
                              alignment: Alignment.center,
                              child: Text(
                                  "Nama Aset : ${cutnamaaset(cari_data[index].nama_aset)}"),
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

  const AssetDetailPage({Key? key, required this.data, required this.refreshCallback}) : super(key: key);

  @override
  _AssetDetailPageState createState() => _AssetDetailPageState();
}

class _AssetDetailPageState extends State<AssetDetailPage> {
  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();
    Future<void> _refreshData() async {
      widget.refreshCallback();
    }

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
            child: Image.network(widget.data.gambar, height: 250),
          ),
          Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailItem("Nama Aset", widget.data.nama_aset),
                    _buildDetailItem("Jenis Aset", widget.data.jenis_aset),
                    _buildDetailItem("Kondisi", widget.data.kondisi),
                    _buildDetailItem("Status Pemakaian", widget.data.status_pemakaian),
                    _buildDetailItem("Utilisasi", widget.data.utilisasi.toString()),
                    _buildDetailItem("Tahun Perolehan", widget.data.tahun_perolehan.toString()),
                    _buildDetailItem("Umur Teknis", widget.data.umur_teknis.toString()),
                    _buildDetailItem("Sumber Dana", widget.data.sumber_dana),
                    _buildDetailItem("Nilai Perolehan", formatter.format(double.parse(widget.data.nilai_perolehan.toString()))),
                    _buildDetailItem("Nilai Buku", formatter.format(double.parse(widget.data.nilai_buku.toString()))),
                    _buildDetailItem("Rencana Optimisasi", widget.data.rencana_optimisasi),
                    _buildDetailItem("Lokasi", widget.data.lokasi),
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
