import 'package:flutter/material.dart';
import 'package:kp_msiap/api/sheet_api.dart';
import 'package:kp_msiap/model/sheet.dart';
import 'package:intl/intl.dart';
import 'dart:convert' as convert;
import 'package:kp_msiap/widget/asset_gambar.dart';

class Assetpindad extends StatefulWidget {
  const Assetpindad({Key? key}) : super(key: key);

  @override
  _Assetpindad createState() => _Assetpindad();
}

class _Assetpindad extends State<Assetpindad> {
  List<sheet>data = [];
  List<sheet> cari_data = [];
  TextEditingController controller_cari = TextEditingController();

  @override
  void initState() {
    super.initState();
    sheet_api().getAssetpindad().then((data) {
      setState(() {
        this.data = data;
        this.cari_data=data;
      });
    });
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller_cari,
              onChanged: caridata,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)
                ),
                labelText: "Cari Asset",
                prefixIcon: Icon(Icons.search),
              ),

            ),
          ),
          Container(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                        builder: (context) => AssetDetailPage(data: cari_data[index]),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
                              ? Image.network(cari_data[index].gambar, height: 170)
                              : Text("Gambar belum ditambahkan."),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          alignment: Alignment.center,
                          child: Text("Nama Aset : ${cari_data[index].nama_aset}"),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
class AssetDetailPage extends StatelessWidget {
  final sheet data;

  const AssetDetailPage({Key? key, required this.data}) : super(key: key);

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
    String formatDate(String dateTimeString) {
      // Parse the date-time string into a DateTime object
      DateTime dateTime = DateTime.parse(dateTimeString);

      // Format the DateTime object as per your desired format
      String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime); // Replace 'yyyy-MM-dd' with your desired format

      return formattedDate;
    }
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header(context),
          Container(
              alignment: Alignment.center,
              child: Image.network(data.gambar,height: 250,)
          ),
          Expanded(child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Nama Aset : ${data.nama_aset}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Jenis Aset : ${data.jenis_aset}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          height: 2
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Kondisi : ${data.kondisi}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          height: 2
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Status Pemakaian : ${data.status_pemakaian}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          height: 2
                      ),

                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Utilisasi : ${data.utilisasi}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          height: 2
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Tahun Perolehan : ${formatDate(data.tahun_perolehan)}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          height: 2
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Umur Teknis : ${data.umur_teknis}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          height: 2
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Sumber Dana : ${data.sumber_dana}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          height: 2
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Nilai Perolehan : ${data.nilai_perolehan}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        height: 2,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Nilai Buku : ${data.nilai_buku}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        height: 2,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Rencana Optimisasi : ${data.rencana_optimisasi}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20, height: 2
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Lokasi : ${data.lokasi}",
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
