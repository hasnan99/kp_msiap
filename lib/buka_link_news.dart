import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:kp_msiap/link_asset.dart';
import 'package:kp_msiap/link_news.dart';
import 'package:http/http.dart' as http;

class BukaLink_News extends StatefulWidget {
  const BukaLink_News({Key? key}) : super(key: key);

  @override
  _BukaLink_News createState() => _BukaLink_News();
}

TextEditingController controller_link = TextEditingController();
TextEditingController sheetname = TextEditingController();
bool link_news=false;
late List<Map<String, dynamic>> list;

Future<List<Map<String, dynamic>>> fetchDataFromGoogleSheets(String link, String sheetName) async {
  final response = await http.get(Uri.parse('https://script.google.com/macros/s/AKfycbzEJ_pzQHhebpIxOX7LgMig5kpwMk064XMdPygz_2sAJMZNw1Oj97NB_ocLa17mksX7/exec?link=$link&sheetName=$sheetName'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    return jsonData.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Gagal mengambil data dari Google Sheets: ${response.statusCode}');
  }
}

class _BukaLink_News extends State<BukaLink_News> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xff4B5526),
          title: const Text("Buka Link"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, link_news);
            },
          )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 5,
              controller: controller_link,
              decoration: const InputDecoration(
                hintText: "Masukkan Link Spreadsheet",
              ),
            ),
            const SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 5,
              controller: sheetname,
              decoration: const InputDecoration(
                hintText: "Masukkan Nama Sheet",
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff4B5526)),
              ),
              onPressed: () async{
                try {
                  list = await fetchDataFromGoogleSheets(controller_link.text, sheetname.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => link_News(data: list),
                    ),
                  );
                  setState(() {
                    link_news=true;
                  });
                } catch (e) {
                  showSnackbar(e.toString());
                }
              },
              child: const Text("Buka Link"),
            ),
          ],
        ),
      ),
    );
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AwesomeSnackbarContent(
          title: 'Terjadi Error',
          message: message,
          contentType: ContentType.failure,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}