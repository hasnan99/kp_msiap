import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:kp_msiap/api/sheet_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import '../widget/background.dart';

class form_smt extends StatefulWidget {
  const form_smt({Key? key}) : super(key: key);

  @override
  _form_smt createState() => _form_smt();
}

class _form_smt extends State<form_smt> {
  final _auth = FirebaseAuth.instance;
  late User? user;
  String? hasil_pencarian;

  TextEditingController dimensipanjangTextController = TextEditingController();
  TextEditingController dimensilebarTextController = TextEditingController();
  TextEditingController dimensitinggiTextController = TextEditingController();
  TextEditingController componentpanjangTextController = TextEditingController();
  TextEditingController componentlebarTextController = TextEditingController();
  TextEditingController componenttinggiTextController = TextEditingController();

  void getuseremail() async {
    user = _auth.currentUser;
  }

  @override
  void initState() {
    super.initState();
    getuseremail();
    fetchDataFromServer();
  }
  GlobalKey<FormState> key = GlobalKey();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();


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

      final dimensipanjanginput =dimensipanjangTextController.text;
      final dimensilebar = dimensilebarTextController.text;
      final dimensitingginput = dimensitinggiTextController.text;
      final componentpanjanginput = componentpanjangTextController.text;
      final componentlebarinput = componentlebarTextController.text;
      final componenttinggiinput = componenttinggiTextController.text;

      final results = findMatchingData(dimensipanjanginput, dimensilebar, dimensitingginput, componentpanjanginput, componentlebarinput, componenttinggiinput);
      setState(() {
        hasil_pencarian = results.join(', ');
      });
    } catch (error) {
      print("Terjadi kesalahan: $error");
    }
  }

  String getKeyForURL(String url) {
    if (url.contains("len")) {
      return 'PT.Len';
    } else if (url.contains("dahana")) {
      return 'Pt.Dahana';
    } else if (url.contains("di")) {
      return 'PT.DI';
    } else if (url.contains("pindad")) {
      return 'PT.Pindad';
    } else if (url.contains("pal")) {
      return 'PT.PAL';
    } else {
      return '';
    }
  }

  List<Map<String, dynamic>> processData(String data) {
    final List<dynamic> jsonData = json.decode(data);
    return List<Map<String, dynamic>>.from(jsonData);
  }

  List<String> findMatchingData(String dimensipanjang, String dimensilebar, String dimensitinggi, String componentpanjang, String componentlebar, String componenttinggi) {
    List<String> results = [];

    for (var entry in dataFromURLs.entries) {
      final key = entry.key;
      final data = entry.value;
      for (var item in data) {
        if (((item['dimensi-kecil-panjang'] == null ? 'null' : item['dimensi-kecil-panjang'].toString()) == dimensipanjang ||
                (item['dimensi-besar-panjang'] == null ? 'null' : item['dimensi-besar-panjang'].toString()) == dimensipanjang)&&
            ((item['dimensi-kecil-lebar'] == null ? 'null' : item['dimensi-kecil-lebar'].toString()) == dimensilebar ||
                (item['dimensi-besar-lebar'] == null ? 'null' : item['dimensi-besar-lebar'].toString()) == dimensilebar)&&
            ((item['dimensi-kecil-tinggi'] == null ? 'null' : item['dimensi-kecil-tinggi'].toString()) == dimensitinggi ||
                (item['dimensi-besar-tinggi'] == null ? 'null' : item['dimensi-besar-tinggi'].toString()) == dimensitinggi)){
          results.add(key);
          break;
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
        title: const Text("Form SMT"),
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
                angle: -pi / 3.5,
                child: ClipPath(
                  clipper: ClipPainter(),
                  child: Container(
                    height: MediaQuery.of(context).size.height * .5,
                    width: MediaQuery.of(context).size.width,
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
                          text: 'Surface Mount Technology (SMT)',
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
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  <Widget>[
                                Text(
                                  "BOARD",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  <Widget>[
                                const Text(
                                  "Dimensi Panjang(mm)",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                    controller: dimensipanjangTextController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        fillColor: Color(0xffD6D6D6),
                                        filled: true))
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  <Widget>[
                                const Text(
                                  "Dimensi Lebar(mm)",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                    controller: dimensilebarTextController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        fillColor: Color(0xffD6D6D6),
                                        filled: true))
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  <Widget>[
                                const Text(
                                  "Dimensi Tinggi(mm)",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                    controller: dimensitinggiTextController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        fillColor: Color(0xffD6D6D6),
                                        filled: true))
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  <Widget>[
                                const Text(
                                  "Component Panjang(mm)",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                    controller: componentpanjangTextController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        fillColor: Color(0xffD6D6D6),
                                        filled: true))
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  <Widget>[
                                const Text(
                                  "Component Lebar(mm)",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                    controller: componentlebarTextController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        fillColor: Color(0xffD6D6D6),
                                        filled: true))
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  <Widget>[
                                const Text(
                                  "Component Tinggi(mm)",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: componenttinggiTextController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        fillColor: Color(0xffD6D6D6),
                                        filled: true))
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
                          onPressed: () async {
                            await fetchDataFromServer();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => GeneratePdf(
                                    hasil: hasil_pencarian??'',
                                    dimensipanjang: dimensipanjangTextController.text,
                                    dimensilebar: dimensilebarTextController.text,
                                    dimensitinggi: dimensitinggiTextController.text,
                                ),
                              ),
                            );
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

class GeneratePdf extends StatefulWidget {
  final String hasil;
  final String dimensipanjang;
  final String dimensilebar;
  final String dimensitinggi;
  GeneratePdf({Key? key, required this.hasil, required this.dimensipanjang, required this.dimensilebar, required this.dimensitinggi}) : super(key: key);

  @override
  _GeneratePdfState createState() => _GeneratePdfState();
}

class _GeneratePdfState extends State<GeneratePdf> {
  final pdf = pw.Document();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ScreenshotController screenshotController = ScreenshotController();

  Future<void> savePdf(String fileName) async {
    try {
      var data = await rootBundle.load("assets/times.ttf");
      final font = pw.Font.ttf(data.buffer.asByteData());

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text('Form Mesin Kebutuhan Indhan', style: pw.TextStyle(font: font, fontSize: 16)),
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(height: 20),
                    pw.Text("Hasil Pencarian Untuk SMT",style: pw.TextStyle(fontSize: 20,font: font)),
                    pw.Text("Dimensi Panjang : ${widget.dimensipanjang}",style: pw.TextStyle(fontSize: 14,font: font)),
                    pw.Text("Dimensi Lebar : ${widget.dimensilebar}",style: pw.TextStyle(fontSize: 14,font: font)),
                    pw.Text("Dimensi Tinggi : ${widget.dimensitinggi}",style: pw.TextStyle(fontSize: 14,font: font)),
                    pw.SizedBox(height: 20),
                    pw.Text('Hasil Pencarian ada di Entitas Indhan :', style: pw.TextStyle(font: font, fontSize: 14)),
                    pw.Text(widget.hasil ?? '', style: pw.TextStyle(font: font, fontSize: 12)),
                  ],
                ),
              ],
            );
          },
        ),
      );

      final dir = Directory('/storage/emulated/0/Download');
      final file = File('${dir.path}/$fileName.pdf');
      await file.writeAsBytes(await pdf.save());
      showSnackbar('PDF berhasil disimpan di ${file.path}');
    } catch (e) {
      showSnackbarfail('Terjadi kesalahan saat menyimpan PDF');
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text("Hasil Pencarian"),
        backgroundColor: const Color(0xff4B5526),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Screenshot(
              controller: screenshotController,
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    const Text("Hasil Pencarian Untuk Packing",style: TextStyle(fontSize: 20)),
                    SizedBox(height: 20),
                    Text("Dimensi Panjang: ${widget.dimensipanjang}",style: TextStyle(fontSize: 20)),
                    Text("Dimensi Lebar : ${widget.dimensilebar}",style: const TextStyle(fontSize: 20)),
                    Text("Dimensi Tinggi : ${widget.dimensitinggi}",style: const TextStyle(fontSize: 20)),
                    SizedBox(height: 20),
                    const Text("Hasil Pencarian ada di Entitas Indhan :",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(16.0),
                      child: Text(widget.hasil,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    savetogallery();
                  },
                  child: Text("Simpan Gambar"),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        final controller = TextEditingController();
                        return AlertDialog(
                          title: Text('Simpan PDF'),
                          content: TextField(
                            controller: controller,
                            decoration: InputDecoration(labelText: 'Nama File'),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Batal'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Simpan'),
                              onPressed: () {
                                final fileName = controller.text;
                                if (fileName.isNotEmpty) {
                                  savePdf(fileName);
                                }
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text("Simpan PDF"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  savetogallery() {
    screenshotController.capture(delay: Duration(milliseconds: 10)).then((Uint8List? image){
      savescreenshot(image!);
    });
    showSnackbar('Gambar berhasil disimpan di Gallery');
  }

  savescreenshot(Uint8List bytes)async {
    final time=DateTime.now().toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final name="Screenshot$time";
    await ImageGallerySaver.saveImage(bytes, name: name);
  }
}

