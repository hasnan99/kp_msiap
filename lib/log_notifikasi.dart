import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'api/sheet_api.dart';
import 'package:kp_msiap/model/log.dart';
import 'model/log.dart';
import 'model/sheet.dart';

class Notifikasi_log extends StatefulWidget {
  const Notifikasi_log({Key? key}) : super(key: key);

  @override
  _Notifikasi_log createState() => _Notifikasi_log();
}

class _Notifikasi_log extends State<Notifikasi_log> {
  List<Log> log = [];
  int total_notif=0;

  @override
  void initState() {
    super.initState();
    fetchLogData();
  }

  Future<List<Log>> fetchLogData() async {
    List<Log> newData = await sheet_api.getLog();
    setState(() {
      log = newData;
    });
    return newData;
  }

  String formatDate(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedDateTime = DateFormat('dd-MM-yyyy HH:mm:ss').format(dateTime);
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context,total_notif);
        return true;
      },
        child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff4B5526),
          title: Text("Notifikasi"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context,total_notif);
              },
            )
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
                    title: Text("User ${log[index].user_edit} ${log[index].keterangan}"),
                    subtitle: Text("Pada Tanggal ${formatDate(log[index].date_Edit)}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
            },
          ),
      ),
    );
  }
}
