import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'api/sheet_api.dart';
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
    generatedata().then((data) {
      setState(() {
        dataList = data;
      });
    });
    sheet_api().getAssetList().then((data) {
      setState(() {
        this.data = data;
      });
    });
  }


  Future generatedata() async {
    var response = await http.get(Uri.parse(
        'https://script.google.com/macros/s/AKfycbz_3ydN4P3f9zSbGIOIa9UNP9xBzVVjy19pAwkZuY1jIcRYgqTrBHnwcA8IprC5xvY/exec'));
    var list = json.decode(response.body).cast<Map<String, dynamic>>();
    var datalist = await list.map<sheet>((json) => sheet.fromJson(json)).toList();
    return datalist;
  }

  @override
  Widget header(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.chevron_left,
                  size: 30,
                ),
              ),
              const Text(
                'Detail Asset',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    sheet? foundAsset = dataList.firstWhereOrNull((asset) => asset.nama_aset == widget.data.nama_aset,
    );
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header(context),
          if(foundAsset!=null)
          Container(
              alignment: Alignment.center,
              child: Image.network(foundAsset.gambar,height: 250,)
          ),
          Expanded(child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Nama Aset : ${foundAsset?.nama_aset}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Jenis Aset : ${foundAsset?.jenis_aset}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          height: 2
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Kondisi : ${foundAsset?.kondisi}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          height: 2
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Status Pemakaian : ${foundAsset?.status_pemakaian}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          height: 2
                      ),

                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Utilisasi : ${foundAsset?.utilisasi}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          height: 2
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Tahun Perolehan : ${foundAsset?.tahun_perolehan}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          height: 2
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Umur Teknis : ${foundAsset?.umur_teknis}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          height: 2
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Sumber Dana : ${foundAsset?.sumber_dana}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          height: 2
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Nilai Perolehan : ${foundAsset?.nilai_perolehan}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        height: 2,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Nilai Buku : ${foundAsset?.nilai_buku}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        height: 2,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Rencana Optimisasi : ${foundAsset?.rencana_optimisasi}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20, height: 2
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Lokasi : ${foundAsset?.lokasi}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          height: 2
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ),
        ],
      ),
    );
  }
}
