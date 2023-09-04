import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:kp_msiap/model/mailbox.dart';
import 'package:kp_msiap/model/news.dart';
import 'package:kp_msiap/api/sheet_api.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Mailbox_out extends StatefulWidget {
  const Mailbox_out({Key? key}) : super(key: key);

  @override
  _Mailbox_out createState() => _Mailbox_out();
}

class _Mailbox_out extends State<Mailbox_out> {
  List<mailbox> data = [];
  late Future<List<mailbox>> dataFuture;
  final _auth = FirebaseAuth.instance;
  late User? user;

  Future<List<mailbox>> _fetchmailbox_out() async {
    List<mailbox> newData = await sheet_api.getmailbox_out();
    return newData;
  }

  String extractFileId(String googleDriveUrl) {
    RegExp regExp = RegExp(r"/d/([a-zA-Z0-9_-]+)");
    Match? match = regExp.firstMatch(googleDriveUrl);
    if (match != null && match.groupCount >= 1) {
      return match.group(1)!;
    }
    return "";
  }

  String convertToDirectDownloadUrl(String fileId) {
    return "https://drive.google.com/uc?export=view&id=$fileId";
  }

  String formatDate(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedDateTime = DateFormat('dd-MM-yyyy').format(dateTime);
    return formattedDateTime;
  }

  void getuseremail() async {
    user = _auth.currentUser;
  }

  @override
  void initState() {
    super.initState();
    dataFuture = _fetchmailbox_out();
    getuseremail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xff4B5526),
          title: const Text("Mailbox out"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          )
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<mailbox>>(
              future:dataFuture,
              builder: (context,snapshot){
                if(snapshot.hasData){
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder:(context,index){
                        return Card(
                          elevation: 6,
                          margin: EdgeInsets.all(10),
                          child:ListTile(
                            title: const Text("Dokumen keluar",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text("Terdapat Dokumen masuk  ${snapshot.data![index].dokumen}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            onTap: (){},
                          ),
                        );
                      }
                  );
                }else if(snapshot.hasError){
                  return Center(
                    child: Text("${snapshot.error}"),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}