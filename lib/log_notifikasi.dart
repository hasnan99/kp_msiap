import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'api/sheet_api.dart';
import 'model/sheet.dart';

class Notifikasi_log extends StatefulWidget {
  const Notifikasi_log({Key? key}) : super(key: key);
  @override
  _Notifikasi_log createState() => _Notifikasi_log();
}

class _Notifikasi_log extends State<Notifikasi_log> {
  List<sheet> log = [];

  @override
  void initState() {
    super.initState();
    fetchLogData();
  }

  Future<void> fetchLogData() async {
    try {
      List<sheet> data = await sheet_api.getAssetLen();
      setState(() {
        log = data.where((entry) => entry.user.isNotEmpty && entry.timestamp.isNotEmpty).toList();
      });
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  String formatDate(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedDateTime = DateFormat('dd-MM-yyyy').format(dateTime);
    return formattedDateTime;
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff4B5526),
        title: Text("Notifikasi"),
      ),
      body: log.isEmpty ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
            itemCount: log.length,
            itemBuilder: (context, index) {
            return Card(
              elevation: 6,
              margin: EdgeInsets.all(10),
              child: ListTile(
                title: Text("Tambah Aset"),
                subtitle: Text(
                  "User ${log[index].user} telah menambahkan aset ${cutnamaaset(log[index].nama_aset)} pada tanggal ${formatDate(log[index].timestamp)}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
        },
      ),
    );
  }
}
