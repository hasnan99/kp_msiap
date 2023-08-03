import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kp_msiap/widget/background.dart';
import 'api/sheet_api.dart';
import 'model/sheet.dart';
import 'dart:math';
import 'dart:io';

import 'model/sheet_add.dart';

class AddData extends StatefulWidget {
  const AddData({Key? key}) : super(key: key);

  @override
  _AddDataState createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  final _auth = FirebaseAuth.instance;
  late User? user;
  bool isImageAdded = false;

  void getuseremail() async {
    user = _auth.currentUser; // Mengambil data user setelah berhasil login
  }

  @override
  void initState() {
    super.initState();
    getuseremail();
  }

  CollectionReference _collectionReference=FirebaseFirestore.instance.collection('gambar');

  GlobalKey<FormState> key = GlobalKey();

  String imageUrl = '';
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // TextField Controllers
  TextEditingController nama_asetcontrol = TextEditingController();
  TextEditingController jenis_asetcontrol = TextEditingController();
  TextEditingController kondisicontrol = TextEditingController();
  TextEditingController status_pemakaiancontrol = TextEditingController();
  TextEditingController utilisasicontrol = TextEditingController();
  TextEditingController tahun_perolehancontrol = TextEditingController();
  TextEditingController umur_tekniscontrol = TextEditingController();
  TextEditingController sumber_danacontrol = TextEditingController();
  TextEditingController nilai_perolehancontrol = TextEditingController();
  TextEditingController nilai_bukucontrol = TextEditingController();
  TextEditingController rencana_optimisasicontrol = TextEditingController();
  TextEditingController lokasicontrol = TextEditingController();

  void _submitForm() async {
    if(imageUrl.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar
        (const SnackBar(content: Text("Masukkan Gambar")));
      return;
    }
    if(_formKey.currentState!.validate()){
      Map<String,String>datasend={
        'image':imageUrl,
      };
      _collectionReference.add(datasend);
    }
    String url = imageUrl;

    if (_formKey.currentState!.validate()) {
      sheet_add feedbackForm = sheet_add(
        nama_asetcontrol.text,
        jenis_asetcontrol.text,
        kondisicontrol.text,
        status_pemakaiancontrol.text,
        utilisasicontrol.text,
        tahun_perolehancontrol.text,
        umur_tekniscontrol.text,
        sumber_danacontrol.text,
        nilai_perolehancontrol.text,
        nilai_bukucontrol.text,
        rencana_optimisasicontrol.text,
        lokasicontrol.text,
        url,
      );

      sheet_api sheetAPI = sheet_api();

      showSnackbarwarning("Menambahkan Asset...");

      sheetAPI.submitForm(feedbackForm, (String response) {
        if (kDebugMode) {
          print("Response: $response");
        }
        if (response == sheet_api.STATUS_SUCCESS) {
          notifikasi();
          showSnackbar("Berhasil Menambahkan");
        } else {
          showSnackbarfail("Gagal Tambah Asset");
        }
      });
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

  void showSnackbarwarning(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AwesomeSnackbarContent(
          title: '.....',
          message: message,
          contentType: ContentType.warning,
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
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Tambah data"),
        backgroundColor: const Color(0xfff20403),
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
                          Color(0xfff20403),
                          Color(0xfff20403),
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
                        text: 'Tambah Data',
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
                            children:  <Widget>[
                              const Text(
                                "Nama Aset",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                  controller: nama_asetcontrol,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Tidak Boleh Kosong';
                                    }
                                    return null;
                                  },
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
                                "Jenis Aset",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                  controller: jenis_asetcontrol,
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
                                "Kondisi",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                  controller: kondisicontrol,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Tidak Boleh Kosong';
                                    }
                                    return null;
                                  },
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
                                "Status Pemakaian",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                  controller: status_pemakaiancontrol,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Tidak Boleh Kosong';
                                    }
                                    return null;
                                  },
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
                                "utilisasi",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                  controller: utilisasicontrol,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Tidak Boleh Kosong';
                                    }
                                    return null;
                                  },
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
                                "Tahun Perolehan",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                  controller: tahun_perolehancontrol,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Tidak Boleh Kosong';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      fillColor: Color(0xffD6D6D6),
                                      filled: true)),

                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:  <Widget>[
                              const Text(
                                "Umur Teknis",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                  controller: umur_tekniscontrol,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Tidak Boleh Kosong';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      fillColor: Color(0xffD6D6D6),
                                      filled: true)),

                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:  <Widget>[
                              const Text(
                                "Sumber Dana",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                  controller: sumber_danacontrol,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Tidak Boleh Kosong';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      fillColor: Color(0xffD6D6D6),
                                      filled: true)),

                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:  <Widget>[
                              const Text(
                                "Nilai Perolehan",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                  controller: nilai_perolehancontrol,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Tidak Boleh Kosong';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      fillColor: Color(0xffD6D6D6),
                                      filled: true)),

                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:  <Widget>[
                              const Text(
                                "Nilai Buku",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                  controller: nilai_bukucontrol,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Tidak Boleh Kosong';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      fillColor: Color(0xffD6D6D6),
                                      filled: true)),

                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:  <Widget>[
                              const Text(
                                "Rencana Optimisasi",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                  controller: rencana_optimisasicontrol,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Tidak Boleh Kosong';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      fillColor: Color(0xffD6D6D6),
                                      filled: true)),

                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:  <Widget>[
                              const Text(
                                "Lokasi",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                  controller: lokasicontrol,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Tidak Boleh Kosong';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      fillColor: Color(0xffD6D6D6),
                                      filled: true)),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            const Text(
                              "Tambah Gambar",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            isImageAdded ? GestureDetector(
                              onTap: () {
                              },
                              child: Image.network(
                                imageUrl!,
                                height: 100,
                                width: 100,
                              ),
                            ): IconButton(
                              onPressed: () async {
                                ImagePicker imagepicker = ImagePicker();
                                XFile? file = await imagepicker.pickImage(source: ImageSource.camera);
                                if (kDebugMode) {
                                  print('${file?.path}');
                                }
                                if (file == null) return;

                                String filename = DateTime.now().microsecondsSinceEpoch.toString();

                                Reference reference = FirebaseStorage.instance.ref();
                                Reference referenceimage = reference.child('gambar');

                                Reference refencegambarupload = referenceimage.child(filename);

                                try {
                                  await refencegambarupload.putFile(File(file.path));
                                  imageUrl = await refencegambarupload.getDownloadURL();
                                  setState(() {
                                    isImageAdded = true;
                                  });
                                } catch (error) {
                                  showSnackbarfail("Gagal");
                                }
                              },
                              icon: const Icon(Icons.camera_alt),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xfff20403),
                          onPrimary: Colors.white,
                        ),
                        onPressed: _submitForm,
                        child: const Text('Submit Asset'),
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

  void notifikasi() {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 10,
            channelKey: 'basic',
            title: 'Berhasil Menambahkan data',
            body: 'User ${user?.email ?? ''} menambahkan data ${nama_asetcontrol.text}',
        ),
    );
  }
}

