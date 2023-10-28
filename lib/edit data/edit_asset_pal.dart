import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kp_msiap/api/sheet_api.dart';
import 'package:kp_msiap/model/sheet.dart';
import 'package:kp_msiap/widget/background.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'dart:io';

class EditAsset_pal extends StatefulWidget {
  final sheet data;
  const EditAsset_pal({Key? key, required this.data}) : super(key: key);

  @override
  _EditAsset_pal createState() => _EditAsset_pal();
}

enum pilihan_upload { uploadFile, googleDriveLink }
class _EditAsset_pal extends State<EditAsset_pal> {
  final _auth = FirebaseAuth.instance;
  late User? user;
  bool isImageAdded = false;
  bool isUploading = false;
  bool linkdrive=false;
  String? selected_data_Sheet;
  bool gambar_kartu_mesin=false;
  String? url_gambar_kartu_mesin='';
  pilihan_upload? selected_upload;

  void getuseremail() async {
    user = _auth.currentUser;
  }

  @override
  void initState() {
    super.initState();
    getuseremail();
    imageUrl=widget.data.gambar??"";
    url_gambar_kartu_mesin=widget.data.kartu_mesin??"";
    nama_asetcontrol=TextEditingController(text: widget.data.nama_asset);
    jenis_asetcontrol=TextEditingController(text: widget.data.jenis_asset);
    kondisicontrol=TextEditingController(text: widget.data.kondisi);
    status_pemakaiancontrol=TextEditingController(text: widget.data.status_pemakaian);
    utilisasicontrol=TextEditingController(text: widget.data.utilisasi.toString());
    tahun_perolehancontrol=TextEditingController(text: widget.data.tahun_perolehan.toString());
    umur_tekniscontrol=TextEditingController(text: widget.data.umur_teknis.toString());
    sumber_danacontrol=TextEditingController(text: widget.data.sumber_dana);
    nilai_perolehancontrol=TextEditingController(text: widget.data.nilai_perolehan.toString());
    nilai_bukucontrol=TextEditingController(text: widget.data.nilai_buku.toString());
    rencana_optimisasicontrol=TextEditingController(text: widget.data.rencana_optimisasi);
    lokasicontrol=TextEditingController(text: widget.data.lokasi);
    merkcontrol=TextEditingController(text: widget.data.merk);
    tipe_mesincontrol=TextEditingController(text: widget.data.tipe_mesin);
    data_sheetcontrol=TextEditingController(text: widget.data.data_sheet);
  }

  GlobalKey<FormState> key = GlobalKey();

  String imageUrl = '';
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // TextField Controllers
  TextEditingController? nama_asetcontrol = TextEditingController();
  TextEditingController? jenis_asetcontrol = TextEditingController();
  TextEditingController? kondisicontrol = TextEditingController();
  TextEditingController? status_pemakaiancontrol = TextEditingController();
  TextEditingController? utilisasicontrol = TextEditingController();
  TextEditingController? tahun_perolehancontrol = TextEditingController();
  TextEditingController? umur_tekniscontrol = TextEditingController();
  TextEditingController? sumber_danacontrol = TextEditingController();
  TextEditingController? nilai_perolehancontrol = TextEditingController();
  TextEditingController? nilai_bukucontrol = TextEditingController();
  TextEditingController? rencana_optimisasicontrol = TextEditingController();
  TextEditingController? lokasicontrol = TextEditingController();
  TextEditingController? merkcontrol = TextEditingController();
  TextEditingController? tipe_mesincontrol = TextEditingController();
  TextEditingController? customRawMaterialController = TextEditingController();
  TextEditingController? customkategori_mesin = TextEditingController();
  TextEditingController? data_sheetcontrol = TextEditingController();
  TextEditingController? kartu_mesincontrol = TextEditingController();
  TextEditingController? kartu_elektronikcontrol = TextEditingController();

  List<DropdownMenuItem<String>> get kategori_mesin_item{
    List<DropdownMenuItem<String>> kategori_fungsi_mesin = [
      DropdownMenuItem(child: Text("-Kosong-"),value: "kosong"),
      DropdownMenuItem(child: Text("Bubut"),value: "bubut"),
      DropdownMenuItem(child: Text("Cutting"),value: "cutting"),
      DropdownMenuItem(child: Text("Ketik"), value: customkategori_mesin?.text),
    ];
    return kategori_fungsi_mesin;
  }

  List<DropdownMenuItem<String>> get raw_material{
    List<DropdownMenuItem<String>> raw_material = [
      DropdownMenuItem(child: Text("Kosong"),value: "Kosong"),
      DropdownMenuItem(child: Text("Bubut"),value: "bubut"),
      DropdownMenuItem(child: Text("Cutting"),value: "cutting"),
      DropdownMenuItem(child: Text("Ketik"), value: customRawMaterialController?.text),
    ];
    return raw_material;
  }

  String selected_kategori_mesin='kosong';
  String selected_raw_material='Kosong';

  List<String> selectedItems_kategori_mesin = [];
  List<String> selectedItems_raw_material = [];

  void select_data_sheet() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        selected_data_Sheet = result.files.single.path;
      });
    }
  }

  void _clearSelection() {
    setState(() {
      selected_data_Sheet = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color(0xff4B5526),
        title: const Text('Edit Aset PAL'),
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
                          text: 'Edit Data',
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
                                    validator: (value) {
                                      if (value== null || value.isEmpty){
                                        return jenis_asetcontrol?.text="Na";
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
                                      if (value== null || value.isEmpty){
                                        return kondisicontrol?.text="Na";
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
                                      if (value== null || value.isEmpty){
                                        return status_pemakaiancontrol?.text="Na";
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
                                    validator: (value) {
                                      if (value== null || value.isEmpty){
                                        return utilisasicontrol?.text=0.toString();
                                      }
                                      return null;
                                    },
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
                                  "Tahun Perolehan",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                    controller: tahun_perolehancontrol,
                                    validator: (value) {
                                      if (value== null || value.isEmpty){
                                        return tahun_perolehancontrol?.text=0.toString();
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
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
                                      if (value== null || value.isEmpty){
                                        return umur_tekniscontrol?.text=0.toString();
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
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
                                        return sumber_danacontrol?.text="Na";
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
                                      if (value == null || value.isEmpty) {
                                        return nilai_perolehancontrol?.text=0.toString();
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
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
                                      if (value == null || value.isEmpty) {
                                        return nilai_bukucontrol?.text=0.toString();
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
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
                                        return rencana_optimisasicontrol?.text="Na";
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
                                        return lokasicontrol?.text="Na";
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
                                        return merkcontrol?.text="Na";
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
                                        return tipe_mesincontrol?.text="Na";
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
                                  "Kategori Fungsi Mesin",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey, width: 2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  items: kategori_mesin_item,
                                  value: selected_kategori_mesin,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selected_kategori_mesin = newValue!;
                                      selectedItems_kategori_mesin.add(selected_kategori_mesin);
                                    });
                                  },
                                ),
                                if (selected_kategori_mesin == customkategori_mesin?.text)
                                  TextFormField(
                                    controller: customkategori_mesin,
                                    onEditingComplete: () {
                                      setState(() {
                                        selected_kategori_mesin = customkategori_mesin!.text;
                                        selectedItems_kategori_mesin.add(customkategori_mesin!.text);
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Masukkan Kategori Mesin",
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey, width: 2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                Text('Item yang dipilih (Kategori Mesin): ${selectedItems_kategori_mesin.join(', ')}'),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  <Widget>[
                                const Text(
                                  "Raw Material",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey, width: 2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  items: raw_material,
                                  value: selected_raw_material,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selected_raw_material = newValue!;
                                      selectedItems_raw_material.add(selected_raw_material);
                                    });
                                  },
                                ),
                                if (selected_raw_material == customRawMaterialController?.text)
                                  TextFormField(
                                    controller: customRawMaterialController,
                                    onEditingComplete: () {
                                      setState(() {
                                        selected_raw_material = customRawMaterialController!.text;
                                        selectedItems_raw_material.add(customRawMaterialController!.text);
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Masukkan raw material",
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey, width: 2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                Text('Item yang dipilih (Raw Material): ${selectedItems_raw_material.join(', ')}'),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
                                Text(
                                  "Data Sheet",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Radio(
                                          value: pilihan_upload.uploadFile,
                                          groupValue: selected_upload,
                                          onChanged: (pilihan_upload? value){
                                            setState(() {
                                              selected_upload=value;
                                              linkdrive=false;
                                            });
                                          },
                                        ),
                                        Text("Upload Data sheet")
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Radio(
                                          value: pilihan_upload.googleDriveLink,
                                          groupValue: selected_upload,
                                          onChanged: (pilihan_upload? value) {
                                            setState(() {
                                              selected_upload = value;
                                              linkdrive=true;
                                            });
                                          },
                                        ),
                                        Text("Tautan Google Drive"),
                                      ],
                                    ),
                                  ],
                                ),
                                if (selected_upload == pilihan_upload.uploadFile)
                                  ElevatedButton(
                                    onPressed: select_data_sheet,
                                    child: const Text("Pilih Data Sheet"),
                                  ),
                                if (selected_upload == pilihan_upload.googleDriveLink)
                                  TextField(
                                    controller: data_sheetcontrol,
                                    decoration: InputDecoration(
                                      hintText: "Masukkan Tautan Google Drive",
                                    ),
                                  ),
                                if (selected_data_Sheet != null)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("File Data Sheet: $selected_data_Sheet"),
                                      ElevatedButton(
                                        onPressed: _clearSelection,
                                        child: Text("Hapus Pilihan"),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              const Text(
                                "Tambah Kartu Mesin",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              gambar_kartu_mesin || url_gambar_kartu_mesin!.isNotEmpty ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    url_gambar_kartu_mesin = '';
                                    gambar_kartu_mesin = false;
                                  });
                                },
                                child: Image.network(
                                  url_gambar_kartu_mesin!,
                                  height: 100,
                                  width: 100,
                                ),
                              ): IconButton(
                                onPressed: () async {
                                  ImagePicker imagepicker = ImagePicker();
                                  XFile? file_kartu_mesin = await imagepicker.pickImage(
                                    source: ImageSource.camera,
                                    imageQuality: 60,
                                  );
                                  if (file_kartu_mesin == null) return;
                                  else {
                                    setState(() {
                                      gambar_kartu_mesin=true;
                                      url_gambar_kartu_mesin=file_kartu_mesin.path;
                                    });
                                  }},
                                icon: const Icon(Icons.camera_alt),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                "Tambah Gambar",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              isImageAdded || imageUrl.isNotEmpty ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    imageUrl = '';
                                    isImageAdded = false;
                                  });
                                },
                                child: Image.network(
                                  imageUrl,
                                  height: 100,
                                  width: 100,
                                ),
                              ): IconButton(
                                onPressed: () async {
                                  ImagePicker imagepicker = ImagePicker();
                                  XFile? file = await imagepicker.pickImage(
                                    source: ImageSource.camera,
                                    imageQuality: 60,
                                  );
                                  EasyLoading.show(status: 'Mengupload Gambar');
                                  if (file == null) return;

                                  try {
                                    final response = await addgambar(file.path, widget.data.id??'', user!.email.toString());
                                    Map<String, dynamic> jsonResponse = json.decode(response.body);
                                    if (jsonResponse.containsKey("message") && jsonResponse["message"].isNotEmpty){
                                      EasyLoading.showSuccess("Berhasil Upload");
                                      setState(() {
                                        imageUrl = file.path;
                                        isImageAdded = true;
                                      });
                                    } else {
                                      showSnackbarfail("Gagal Menambahkan Gambar");
                                      EasyLoading.dismiss();
                                    }
                                  } catch (e) {
                                    showSnackbarfail(e.toString());
                                    EasyLoading.dismiss();
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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
    String nama_table="pal";
    String Id= widget.data.id??'';
    String? nama_aset = nama_asetcontrol?.text??"Na";
    String? jenis_aset = jenis_asetcontrol?.text??"Na";
    String? kondisi = kondisicontrol?.text??"Na";
    String? status_pemakaian = status_pemakaiancontrol?.text??"Na";
    int? utilitas = int.parse(utilisasicontrol!.text );
    int? tahun_perolehan =int.parse(tahun_perolehancontrol!.text);
    int? umur_teknis = int.parse(umur_tekniscontrol!.text);
    String? sumber_dana = sumber_danacontrol?.text??"Na";
    int? nilai_perolehan = int.parse(nilai_perolehancontrol!.text);
    int? nilai_buku = int.parse(nilai_bukucontrol!.text);
    String? rencana_optimisasi = rencana_optimisasicontrol?.text??"Na";
    String? lokasi = lokasicontrol?.text??"Na";
    String? user_edit=user!.email.toString();
    String? merk=merkcontrol?.text??"Na";
    String? tipe_mesin=tipe_mesincontrol?.text??"Na";
    List<String> kategori_mesin=selectedItems_kategori_mesin.toList();
    List<String> raw_material=selectedItems_raw_material.toList();
    String? data_sheet;
    if (linkdrive == true) {
      data_sheet = data_sheetcontrol?.text??"Na";
    } else {
      data_sheet = selected_data_Sheet ?? data_sheetcontrol?.text??"Na";
    }
    String? kartu_mesin=url_gambar_kartu_mesin??"Na";
    String? kartu_elektronik=kartu_elektronikcontrol?.text??"Na";

    http.Response response=await sheet_api.editdata(nama_table, Id,nama_aset, jenis_aset, kondisi, status_pemakaian, utilitas,
        tahun_perolehan, umur_teknis, sumber_dana, nilai_perolehan, nilai_buku, rencana_optimisasi, lokasi,
        user_edit,merk,tipe_mesin,kategori_mesin,raw_material,data_sheet,kartu_mesin,kartu_elektronik,linkdrive);
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (jsonResponse.containsKey("message") && jsonResponse["message"].isNotEmpty){
      if(jsonResponse["message"].toString().contains("pesan error")) {
        showSnackbarfail("gagal update asset");
      }else{
        notifikasi();
        showSnackbar("Berhasil Mengedit Asset");
        Navigator.pop(context);
        _formKey.currentState!.reset();
        imageUrl = '';
        nama_asetcontrol?.clear();
        jenis_asetcontrol?.clear();
        kondisicontrol?.clear();
        status_pemakaiancontrol?.clear();
        utilisasicontrol?.clear();
        tahun_perolehancontrol?.clear();
        umur_tekniscontrol?.clear();
        sumber_danacontrol?.clear();
        nilai_perolehancontrol?.clear();
        nilai_bukucontrol?.clear();
        rencana_optimisasicontrol?.clear();
        lokasicontrol?.clear();
      }
    }else{
      showSnackbarfail("Gagal Menambahkan Asset");
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
        title: 'Berhasil Mengedit data',
        body: 'User ${user?.email ?? ''} Mengedit data ${nama_asetcontrol?.text}',
      ),
    );
  }
  Future<http.Response> addgambar(String imagePath, String id, String userEdit) async {
    final url = Uri.parse(sheet_api.URL_addgambar_pal);
    final imageFile = File(imagePath);

    var request = http.MultipartRequest('POST', url)
      ..fields['id'] = id.toString()
      ..fields['user_edit'] = userEdit
      ..files.add(
        await http.MultipartFile.fromPath(
          'photo',
          imageFile.path,         ),
      );

    try {
      final response = await request.send();
      final responseStream = await response.stream.bytesToString();
      print(responseStream);
      return http.Response(responseStream, response.statusCode);
    } catch (error) {
      print('Terjadi kesalahan: $error');
      return http.Response('Terjadi kesalahan', 500); // Ganti dengan status code yang sesuai
    }
  }
}