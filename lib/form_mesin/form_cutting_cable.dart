import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kp_msiap/api/sheet_api.dart';

class form_cutting_cable extends StatefulWidget {
  const form_cutting_cable({Key? key}) : super(key: key);

  @override
  _form_cutting_cable createState() => _form_cutting_cable();
}

class _form_cutting_cable extends State<form_cutting_cable> {
  final _auth = FirebaseAuth.instance;
  late User? user;

  void getuseremail() async {
    user = _auth.currentUser;
  }

  @override
  void initState() {
    super.initState();
    getuseremail();
    fetchDataFromServer();
  }

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController materialTextController = TextEditingController();
  TextEditingController dimensiDiameterTextController = TextEditingController();
  TextEditingController dimensiPanjangTextController = TextEditingController();

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AwesomeSnackbarContent(
          title: 'Berhasil',
          message: message,
          contentType: ContentType.success,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void showSnackbarfail(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AwesomeSnackbarContent(
          title: 'Gagal',
          message: message,
          contentType: ContentType.failure,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Map<String, List<Map<String, dynamic>>> dataFromURLs = {
    'len': [], // Data dari URL len
    'dahana': [], // Data dari URL dahana
    'di': [], // Data dari URL di
    'pindad': [], // Data dari URL pindad
    'pal': [], // Data dari URL pal
  };

  Future<void> fetchDataFromServer() async {
    try {
      final List<String> urls = [
        sheet_api.URL_mesin_len,
        sheet_api.URL_mesin_dahana,
        sheet_api.URL_mesin_di,
        sheet_api.URL_mesin_pindad,
        sheet_api.URL_mesin_pal,
      ];

      for (String url in urls) {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = response.body;
          final key = getKeyForURL(url);
          dataFromURLs[key] = processData(data);
        } else {
          print("Gagal mengambil data dari $url");
        }
      }

      final materialInput = "Steel";
      final dimensiDiameterInput = "10";
      final dimensiPanjangInput ="150";

      final results = findMatchingData(materialInput, dimensiDiameterInput, dimensiPanjangInput);

      print(results.join(', '));
    } catch (error) {
      showSnackbarfail("Terjadi kesalahan: $error");
    }
  }

  String getKeyForURL(String url) {
    if (url.contains("len")) {
      return 'PT.Len';
    } else if (url.contains("dahana")) {
      return 'dahana';
    } else if (url.contains("di")) {
      return 'di';
    } else if (url.contains("pindad")) {
      return 'pindad';
    } else if (url.contains("pal")) {
      return 'pal';
    } else {
      return '';
    }
  }

  List<Map<String, dynamic>> processData(String data) {
    final List<dynamic> jsonData = json.decode(data);
    return List<Map<String, dynamic>>.from(jsonData);
  }

  List<String> findMatchingData(String material, String diameter, String panjang) {
    List<String> results = [];

    for (var entry in dataFromURLs.entries) {
      final key = entry.key;
      final data = entry.value;
      for (var item in data) {
        if (item['jenis_material'] == material &&
            (item['dimensi-kecil-diameter'] == null ? 'null' : item['dimensi-kecil-diameter'].toString()) == diameter &&
            (item['dimensi-kecil-panjang'] == null ? 'null' : item['dimensi-kecil-panjang'].toString()) == panjang) {
          results.add(key);
        }
      }
    }
    return results;
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Form Cutting Cable"),
        backgroundColor: const Color(0xff4B5526),
      ),
      body: SizedBox(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: Transform.rotate(
                angle: -3.5,
                child: ClipPath(
                  child: Container(
                    height: .5,
                    width: .5,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xff4B5526),
                          Color(0xff4B5526),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          text: 'Cutting Cable',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text(
                                  "Material",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: materialTextController,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: Color(0xffD6D6D6),
                                    filled: true,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text(
                                  "Dimensi Diameter(mm)",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: dimensiDiameterTextController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: Color(0xffD6D6D6),
                                    filled: true,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text(
                                  "Dimensi Panjang(mm)",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: dimensiPanjangTextController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: Color(0xffD6D6D6),
                                    filled: true,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xff4B5526),
                            onPrimary: Colors.white,
                          ),
                          onPressed: () {
                            fetchDataFromServer();
                          },
                          child: const Text('Cari'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
