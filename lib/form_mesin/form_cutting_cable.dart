import 'dart:convert';
import 'dart:io';
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

class form_cutting_cable extends StatefulWidget {
  const form_cutting_cable({Key? key}) : super(key: key);

  @override
  _form_cutting_cable createState() => _form_cutting_cable();
}

class _form_cutting_cable extends State<form_cutting_cable> {
  final _auth = FirebaseAuth.instance;
  late User? user;
  String? hasil_pencarian;

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

      final materialInput = materialTextController.text;
      final dimensiDiameterInput = dimensiDiameterTextController.text;
      final dimensiPanjangInput =dimensiPanjangTextController.text;

      final results = findMatchingData(materialInput, dimensiDiameterInput, dimensiPanjangInput);
      setState(() {
        hasil_pencarian = results.join(', ');
      });
    } catch (error) {
      print("Terjadi kesalahan: $error");
    }
  }

  List<String> materialOptions = [
    'Steel',
    'Aluminum',
    'Stainless Steel',
    'Board',
    'Component',
    'Raw Material Diameter',
    'Conductor Cross Section',
  ];


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

  List<String> findMatchingData(String material, String diameter, String panjang) {
    List<String> results = [];

    for (var entry in dataFromURLs.entries) {
      final key = entry.key;
      final data = entry.value;
      for (var item in data) {
        if (item['jenis_material'] == material &&
            ((item['dimensi-kecil-diameter'] == null ? 'null' : item['dimensi-kecil-diameter'].toString()) == diameter ||
                (item['dimensi-besar-diameter'] == null ? 'null' : item['dimensi-besar-diameter'].toString()) == diameter)&&
            (item['dimensi-kecil-panjang'] == null ? 'null' : item['dimensi-kecil-panjang'].toString()) == panjang ||
                (item['dimensi-besar-panjang'] == null ? 'null' : item['dimensi-besar-panjang'].toString()) == panjang) {
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
                                DropdownButtonFormField<String>(
                                  value: materialTextController.text==''?null:materialTextController.text,
                                  items: materialOptions.map((String material) {
                                    return DropdownMenuItem<String>(
                                      value: material,
                                      child: Text(material),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    // Update the selected value
                                    setState(() {
                                      materialTextController.text = newValue ?? '';
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: Color(0xffD6D6D6),
                                    filled: true,
                                  ),
                                ),
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
                          onPressed: () async {
                            await fetchDataFromServer();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => GeneratePdf(
                                  hasil: hasil_pencarian??'',
                                material: materialTextController.text,
                                dimensiDiameter: dimensiDiameterTextController.text,
                                dimensiPanjang: dimensiPanjangTextController.text,),
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
  final String? material;
  final String? dimensiDiameter;
  final String? dimensiPanjang;
  GeneratePdf({Key? key, required this.hasil, this.material, this.dimensiDiameter, this.dimensiPanjang}) : super(key: key);

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
                    pw.Text("Hasil Pencarian Untuk cutting cable",style: pw.TextStyle(fontSize: 14,font: font)),
                    pw.Text("Material : ${widget.material}",style: pw.TextStyle(fontSize: 12,font: font)),
                    pw.Text("Dimensi Diameter : ${widget.dimensiDiameter}",style: pw.TextStyle(fontSize: 12,font: font)),
                    pw.Text("Dimensi Panjang : ${widget.dimensiPanjang}",style:  pw.TextStyle(fontSize: 12,font: font)),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Screenshot(
              controller: screenshotController,
              child: Container(
                color: Colors.white,
                child: Column(
                children: [
                  const Text("Hasil Pencarian Untuk cutting cable",style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  Text("Material : ${widget.material}",style: const TextStyle(fontSize: 20)),
                  Text("Dimensi Diameter : ${widget.dimensiDiameter}",style: const TextStyle(fontSize: 20)),
                  Text("Dimensi Panjang : ${widget.dimensiPanjang}",style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  const Text("Hasil Pencarian ada di Entitas Indhan :",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Text(widget.hasil,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                  ),
                ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    savetogallery();
                  },
                  child: const Text("Simpan Gambar"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        final controller = TextEditingController();
                        return AlertDialog(
                          title: const Text('Simpan PDF'),
                          content: TextField(
                            controller: controller,
                            decoration: const InputDecoration(labelText: 'Nama File'),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Batal'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Simpan'),
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
                  child: const Text("Simpan PDF"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  savetogallery() {
    screenshotController.capture(delay: const Duration(milliseconds: 10)).then((Uint8List? image){
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