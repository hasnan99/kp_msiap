import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kp_msiap/api/sheet_api.dart';
import 'package:kp_msiap/model/sheet_add.dart';
import 'package:kp_msiap/widget/background.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'dart:io';

class AddData_qr extends StatefulWidget {
  final List<sheet_add> data;
  const AddData_qr({Key? key, required this.data}) : super(key: key);

  @override
  _AddData_qr createState() => _AddData_qr();
}

class _AddData_qr extends State<AddData_qr> {
  final _auth = FirebaseAuth.instance;
  late User? user;
  bool isImageAdded = false;
  bool linkdrive=false;

  void getuseremail() async {
    user = _auth.currentUser; // Mengambil data user setelah berhasil login
  }

  @override
  void initState() {
    print("Widget Data: ${widget.data}");
    super.initState();
    getuseremail();
    nama_asetcontrol.text = widget.data[0].nama_aset;
    jenis_asetcontrol.text = widget.data[0].jenis_aset;
    kondisicontrol.text = widget.data[0].kondisi;
    status_pemakaiancontrol.text = widget.data[0].status_pemakaian;
    utilisasicontrol.text = widget.data[0].utilisasi.toString();
    tahun_perolehancontrol.text = widget.data[0].tahun_perolehan.toString();
    umur_tekniscontrol.text = widget.data[0].umur_teknis.toString();
    sumber_danacontrol.text = widget.data[0].sumber_dana;
    nilai_perolehancontrol.text = widget.data[0].nilai_perolehan.toString();
    nilai_bukucontrol.text = widget.data[0].nilai_buku.toString();
    rencana_optimisasicontrol.text = widget.data[0].rencana_optimisasi.toString();
    lokasicontrol.text = widget.data[0].lokasi;
  }

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
  TextEditingController merkcontrol = TextEditingController();
  TextEditingController tipe_mesincontrol = TextEditingController();
  TextEditingController customRawMaterialController = TextEditingController();
  TextEditingController customkategori_mesin = TextEditingController();
  TextEditingController data_sheetcontrol = TextEditingController();
  TextEditingController kartu_mesincontrol = TextEditingController();
  TextEditingController kartu_elektronikcontrol = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
    String nama_table="len";
    String id="id test";
    String nama_aset = nama_asetcontrol.text;
    String jenis_aset = jenis_asetcontrol.text;
    String kondisi = kondisicontrol.text;
    String status_pemakaian = status_pemakaiancontrol.text;
    int utilitas = int.parse(utilisasicontrol.text );
    int tahun_perolehan =int.parse(tahun_perolehancontrol.text);
    int umur_teknis = int.parse(umur_tekniscontrol.text);
    String sumber_dana = sumber_danacontrol.text;
    int nilai_perolehan = int.parse(nilai_perolehancontrol.text);
    int nilai_buku = int.parse(nilai_bukucontrol.text);
    String rencana_optimisasi = rencana_optimisasicontrol.text;
    String lokasi = lokasicontrol.text;
    String user_edit=user!.email.toString();
    String merk=merkcontrol.text;
    String tipe_mesin=tipe_mesincontrol.text;
    String data_sheet=data_sheetcontrol.text;
    String kartu_mesin=kartu_mesincontrol.text;
    String kartu_elektronik=kartu_elektronikcontrol.text;

    http.Response response=await sheet_api.tambahdata(nama_table, id,nama_aset, jenis_aset, kondisi, status_pemakaian, utilitas,
        tahun_perolehan, umur_teknis, sumber_dana, nilai_perolehan, nilai_buku, rencana_optimisasi,
        lokasi,user_edit,merk,tipe_mesin,data_sheet,kartu_mesin,kartu_elektronik,linkdrive);
    if(response.statusCode==200){
      final responsedata=json.decode(response.body);
      if(responsedata.containsKey('inserted_id')){
        notifikasi();
        showSnackbar("Berhasil Menambahkan Asset");
        _formKey.currentState!.reset();
        imageUrl = '';
        nama_asetcontrol.clear();
        jenis_asetcontrol.clear();
        kondisicontrol.clear();
        status_pemakaiancontrol.clear();
        utilisasicontrol.clear();
        tahun_perolehancontrol.clear();
        umur_tekniscontrol.clear();
        sumber_danacontrol.clear();
        nilai_perolehancontrol.clear();
        nilai_bukucontrol.clear();
        rencana_optimisasicontrol.clear();
        lokasicontrol.clear();
      }else{
        showSnackbarfail("Gagal Menambahkan Asset");
      }
      }
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
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Tambah data Len"),
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
                                      if (value == null || value.isEmpty) {
                                        return nama_asetcontrol.text="Na";
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
                                    validator: (value){
                                      if (value == null || value.isEmpty) {
                                        return jenis_asetcontrol.text="Na";
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
                                      if (value == null || value.isEmpty) {
                                        return kondisicontrol.text="Na";
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
                                      if (value == null || value.isEmpty) {
                                        return status_pemakaiancontrol.text="Na";
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
                                    validator: (value){
                                      if (value == null || value.isEmpty) {
                                        return utilisasicontrol.text=0.toString();
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
                                    validator: (value){
                                      if (value == null || value.isEmpty) {
                                        return tahun_perolehancontrol.text=0.toString();
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
                                    keyboardType: TextInputType.number,
                                    validator: (value){
                                      if (value == null || value.isEmpty) {
                                        return umur_tekniscontrol.text=0.toString();
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
                                      if (value == null || value.isEmpty) {
                                        return sumber_danacontrol.text="Na";
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
                                    keyboardType: TextInputType.number,
                                    validator: (value){
                                      if (value == null || value.isEmpty) {
                                        return nilai_perolehancontrol.text=0.toString();
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
                                    keyboardType: TextInputType.number,
                                    validator: (value){
                                      if (value == null || value.isEmpty) {
                                        return nilai_bukucontrol.text=0.toString();
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
                                      if (value == null || value.isEmpty) {
                                        return rencana_optimisasicontrol.text="Na";
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
                                      if (value == null || value.isEmpty) {
                                        return lokasicontrol.text="Na";
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
                                  "Merk",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                    controller: merkcontrol,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return merkcontrol.text="Na";
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
                                  "Tipe Mesin",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                    controller: tipe_mesincontrol,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return tipe_mesincontrol.text="Na";
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
                                  setState(() {
                                    imageUrl = '';
                                    isImageAdded = false;
                                  });
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
                                  EasyLoading.show(status: 'Mengupload Gambar');
                                  if (kDebugMode) {
                                    print('${file?.path}');
                                  }
                                  if (file == null) return;

                                  String filename = DateTime.now().microsecondsSinceEpoch.toString();

                                  Reference reference = FirebaseStorage.instance.ref();
                                  Reference referenceimage = reference.child('gambar');

                                  Reference refencegambarupload = referenceimage.child(filename);

                                  try {
                                    EasyLoading.showSuccess("Berhasil");
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
                            primary: const Color(0xff4B5526),
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
    // final endpoint = "https://fcm.googleapis.com/fcm/send";

    //final header = {
    //'Authorization': 'key=paste-firebase-cloud-messaging-server-token',
    //'Content-Type': 'application/json'
    //};


    // http.post(
    //  Uri.parse(endpoint),
    //headers: header,
    // body: jsonEncode({
    // "to": "/topics/admin", // topic name
    //"notification": {"body": "YOUR NOTIFICATION BODY TEXT", "title": "YOUR NOTIFICATION TITLE TEXT", "sound": "default"}
    //})
    //);
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

