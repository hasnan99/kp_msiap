import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class link_asset extends StatefulWidget {
  final List data;
  const link_asset({Key? key, required this.data}) : super(key: key);

  @override
  _link_asset createState() => _link_asset();
}


class _link_asset extends State<link_asset> {
  late List cari_data=[];
  TextEditingController controller_cari = TextEditingController();

  void cariData(String query) {
    setState(() {
      if (query.isEmpty) {
        cari_data = List.from(widget.data);
      } else {
        cari_data = widget.data
            .where((asset) =>
            asset['Nama Asset'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    cari_data = List.from(widget.data);
    cariData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff4B5526),
        title: const Text("Link Asset"),
      ),
      body: SingleChildScrollView(
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
                onChanged: cariData,
              ),
            ),
            if (widget.data.isNotEmpty)
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.68,
                ),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 15),
                itemCount: cari_data.length,
                itemBuilder: (context, index) {
                  // Gantilah cari_data[index] dengan data[index] sesuai kebutuhan Anda.
                  final item = cari_data[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AssetDetailPage(
                            data: item,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffeef1f4),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 10),
                            alignment: Alignment.center,
                            child: item['Gambar'] != null
                                ? Image.network(
                              item['Gambar'],
                              height: 170,
                            )
                                : Text("Gambar belum ditambahkan."),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 10),
                            alignment: Alignment.topLeft,
                            child: Text("ID : ${item['No']}"),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 10),
                            alignment: Alignment.center,
                            child: Text("Nama Aset : ${(item['Nama Asset'])}"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            else
              const Text('Tidak ada data'), // Tampilkan pesan jika data kosong.
          ],
        ),
      ),
    );
  }
}

class AssetDetailPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const AssetDetailPage({Key? key, required this.data}) : super(key: key);

  @override
  _AssetDetailPageState createState() => _AssetDetailPageState();
}

class _AssetDetailPageState extends State<AssetDetailPage> {
  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff4B5526),
        title: const Text("Detail Asset"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 250,
              alignment: Alignment.center,
              child: Image.network(widget.data['Gambar'], height: 250),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailItem("Nama Aset", widget.data['Nama Asset']),
                  _buildDetailItem("Jenis Aset", widget.data['Jenis Asset']),
                  _buildDetailItem("Kondisi", widget.data['Kondisi']),
                  _buildDetailItem("Status Pemakaian", widget.data['Status pemakaian']),
                  _buildDetailItem("Utilisasi", widget.data['Utilisasi'].toString()),
                  _buildDetailItem("Tahun Perolehan", widget.data['Tahun Perolehan'].toString()),
                  _buildDetailItem("Umur Teknis", widget.data['Umur Teknis'].toString()),
                  _buildDetailItem("Sumber Dana", widget.data['Sumber Dana']),
                  _buildDetailItem("Nilai Perolehan", formatter.format(double.parse(widget.data['Nilai Perolehan'].toString()))),
                  _buildDetailItem("Nilai Buku", formatter.format(double.parse(widget.data['Nilai Buku'].toString()))),
                  _buildDetailItem("Rencana Optimisasi", widget.data['Rencana Optimisasi']),
                  _buildDetailItem("Lokasi", widget.data['Lokasi']),
                ],
              ),
            ),
          ],
        ),
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
