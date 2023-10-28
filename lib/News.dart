import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kp_msiap/model/news.dart';
import 'package:kp_msiap/api/sheet_api.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class News extends StatefulWidget {
  const News({Key? key}) : super(key: key);

  @override
  _News createState() => _News();
}

class _News extends State<News> {
  List<news> data = [];
  late Future<List<news>> dataFuture;
  final _auth = FirebaseAuth.instance;
  late User? user;
  int jumlah_news=0;

  Future<List<news>> _fetchnews() async {
    List<news> newData = await sheet_api.getnews();
    try {
      for (var item in newData) {
        String fileId = extractFileId(item.link_file??"");
        String directDownloadUrl = convertToDirectDownloadUrl(fileId);
        item.link_file = directDownloadUrl;
      }
      setState(() {
        jumlah_news = newData.length;
      });
      return newData;
    }
    catch(e){
      print(e.toString());
    }
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
    String formattedDateTime = DateFormat('dd-MM-yyyy  HH:mm:ss').format(dateTime);
    return formattedDateTime;
  }

  void getuseremail() async {
    user = _auth.currentUser;
  }

  @override
  void initState() {
    super.initState();
    dataFuture = _fetchnews();
    getuseremail();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context,jumlah_news);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff4B5526),
          title: const Text("News"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context,jumlah_news);
              },
            )
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<news>>(
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
                            title: Text(snapshot.data![index].nama_file??"",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                            ),
                            ),
                            subtitle: Text("Upload News: ${formatDate(snapshot.data![index].date_edit??"2000-30-30")}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                  builder: (context) => PDFScreen(pdfUrl: snapshot.data![index].url??"")
                                  ));
                              setState(() {
                                jumlah_news=0;
                              });
                              },
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
      ),
    );
  }
}
class PDFScreen extends StatelessWidget {
  final String pdfUrl;

  PDFScreen({required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
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