import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:kp_msiap/model/mesin.dart';
import 'package:kp_msiap/model/sheet.dart';
import '../model/log.dart';
import '../model/mailbox.dart';
import '../model/news.dart';

//api server = 192.168.17.27:5001

class sheet_api {
  static const String URL_len =
      "http://192.168.1.12:3000/assets/len";

  static const String URL_dahana =
      "http://192.168.1.12:3000/assets/dahana";

  static const String URL_DI =
      "http://192.168.1.12:3000/assets/di";

  static const String URL_Pindad =
      "http://192.168.1.12:3000/assets/pindad";

  static const String URL_PAL =
      "http://192.168.1.12:3000/assets/pal";

  static const String URL_news =
      "http://192.168.1.12:3000/news";

  static const String URL_mailbox_in =
      "http://192.168.1.12:3000/mail/in";

  static const String URL_mailbox_out =
      "http://192.168.1.12:3000/mail/out";

  static const String URL_log =
      "http://192.168.1.12:3000/log";

  static const String URL_mesin_len =
      "http://192.168.1.12:3000/kapabilitas/len";

  static const String URL_mesin_dahana =
      "http://192.168.1.12:3000/kapabilitas/dahana";

  static const String URL_mesin_di =
      "http://192.168.1.12:3000/kapabilitas/di";

  static const String URL_mesin_pindad =
      "http://192.168.1.12:3000/kapabilitas/pindad";

  static const String URL_mesin_pal =
      "http://192.168.1.12:3000/kapabilitas/pal";

  static const String URL_addgambar_len =
      "http://192.168.1.12:3000/assets/photo/len";

  static const String URL_addgambar_dahana =
      "http://192.168.1.12:3000/assets/photo/dahana";

  static const String URL_addgambar_di =
      "http://192.168.1.12:3000/assets/photo/di";

  static const String URL_addgambar_pal =
      "http://192.168.1.12:3000/assets/photo/pal";

  static const String URL_addgambar_pindad =
      "http://192.168.1.12:3000/assets/photo/pindad";


  static Future<List<sheet>> getAssetLen_offline() async {
  try{
    final jsonString=await rootBundle.loadString('assets/response.json');
    final List<dynamic> jsonfeedback=json.decode(jsonString);
    return jsonfeedback.map((json) => sheet.fromJson(json)).toList();
  }catch(e){
    print(e.toString());
    return <sheet>[];
  }
  }

  static Future<List<sheet>> getAssetLen() async {
    return await http.get(Uri.parse(URL_len)).then((response) {
      var jsonFeedback = json.decode(response.body) as List<dynamic>;
      return jsonFeedback.map((json) => sheet.fromJson(json)).toList();
    }).catchError((error) {
      print(error);
      return <sheet>[];
    });
  }

  static Future<List<sheet>> getAssetDahana() async {
    return await http.get(Uri.parse(URL_dahana)).then((response) {
      var jsonFeedback = json.decode(response.body) as List<dynamic>;
      return jsonFeedback.map((json) => sheet.fromJson(json)).toList();
    }).catchError((error) {
      print(error);
      return <sheet>[];
    });
  }

  static Future<List<sheet>> getAssetDI() async {
    return await http.get(Uri.parse(URL_DI)).then((response) {
      var jsonFeedback = json.decode(response.body) as List<dynamic>;
      return jsonFeedback.map((json) => sheet.fromJson(json)).toList();
    }).catchError((error) {
      print(error);
      return <sheet>[];
    });
  }

  static Future<List<sheet>> getAssetPAL() async {
    return await http.get(Uri.parse(URL_PAL)).then((response) {
      var jsonFeedback = json.decode(response.body) as List<dynamic>;
      return jsonFeedback.map((json) => sheet.fromJson(json)).toList();
    }).catchError((error) {
      print(error);
      return <sheet>[];
    });
  }

  static Future<List<sheet>> getAssetpindad() async {
    return await http.get(Uri.parse(URL_Pindad)).then((response) {
      var jsonFeedback = json.decode(response.body) as List<dynamic>;
      return jsonFeedback.map((json) => sheet.fromJson(json)).toList();
    }).catchError((error) {
      print(error);
      return <sheet>[];
    });
  }

  static Future<List<news>> getnews() async {
    return await http.get(Uri.parse(URL_news)).then((response) {
      var jsonFeedback = json.decode(response.body) as List<dynamic>;
      return jsonFeedback.map((json) => news.fromJson(json)).toList();
    }).catchError((error) {
      print(error);
      return <news>[];
    });
  }

  static Future<List<mailbox>> getmailbox_in() async {
    return await http.get(Uri.parse(URL_mailbox_in)).then((response) {
      var jsonFeedback = json.decode(response.body) as List<dynamic>;
      return jsonFeedback.map((json) => mailbox.fromJson(json)).toList();
    }).catchError((error) {
      print(error);
      return <mailbox>[];
    });
  }

  static Future<List<mailbox>> getmailbox_out() async {
    return await http.get(Uri.parse(URL_mailbox_out)).then((response) {
      var jsonFeedback = json.decode(response.body) as List<dynamic>;
      return jsonFeedback.map((json) => mailbox.fromJson(json)).toList();
    }).catchError((error) {
      print(error);
      return <mailbox>[];
    });
  }

  static Future<List<Log>> getLog() async {
    return await http.get(Uri.parse(URL_log)).then((response) {
      var jsonFeedback = json.decode(response.body) as List<dynamic>;
      return jsonFeedback.map((json) => Log.fromJson(json)).toList();
    }).catchError((error) {
      print(error);
      return <Log>[];
    });
  }

  static Future<List<Mesin>> getmesin_len() async {
    return await http.get(Uri.parse(URL_mesin_len)).then((response) {
      var jsonFeedback = json.decode(response.body) as List<dynamic>;
      return jsonFeedback.map((json) => Mesin.fromJson(json)).toList();
    }).catchError((error) {
      print(error);
      return <Mesin>[];
    });
  }

  static Future<http.Response> register(String user,String mail,String jabatan,String pass)async{
    Map data={
      "user":user,
      "mail":mail,
      "jabatan":jabatan,
      "pass":pass
    };
    var body=json.encode(data);
    var url=Uri.parse("http://192.168.1.12:3000/user/requestAccount");
    http.Response response =await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body
    );
    print(response.body);
    return response;
  }

  static Future<http.Response> tambahdata(
      String namaTabel,
      String id,
      String namaAsset,
      String jenisAsset,
      String kondisi,
      String statusPemakaian,
      int utilisasi,
      int tahunPerolehan,
      int umurTeknis,
      String sumberDana,
      int nilaiPerolehan,
      int nilaiBuku,
      String rencanaOptimisasi,
      String lokasi,
      String userEdit,
      String merk,
      String tipeMesin,
      String dataSheet,
      String kartuMesin,
      String kartuElektronik,
      bool linkdrive,
      ) async {
    var uri = Uri.parse("http://192.168.1.12:3000/assets/"+namaTabel);

    var request = http.MultipartRequest('POST', uri)
      ..fields['id'] = id
      ..fields['nama_asset'] = namaAsset
      ..fields['jenis_asset'] = jenisAsset
      ..fields['kondisi'] = kondisi
      ..fields['status_pemakaian'] = statusPemakaian
      ..fields['utilisasi'] = utilisasi.toString()
      ..fields['tahun_perolehan'] = tahunPerolehan.toString()
      ..fields['umur_teknis'] = umurTeknis.toString()
      ..fields['sumber_dana'] = sumberDana
      ..fields['nilai_perolehan'] = nilaiPerolehan.toString()
      ..fields['nilai_buku'] = nilaiBuku.toString()
      ..fields['rencana_optimisasi'] = rencanaOptimisasi
      ..fields['lokasi'] = lokasi
      ..fields['user_edit'] = userEdit
      ..fields['merk'] = merk
      ..fields['tipe_mesin'] = tipeMesin
      ..fields['kartu_elektronik'] = kartuElektronik;

    if (linkdrive) {
      request.fields['data_sheet'] = dataSheet;
    } else {
      if(File(dataSheet).existsSync()){
        request.files.add(await http.MultipartFile.fromPath('data_sheet', dataSheet));
      }else{
        request.fields['data_sheet'] = dataSheet;
      }
    }
    if (File(kartuMesin).existsSync()) {
      request.files.add(await http.MultipartFile.fromPath('kartu_mesin', kartuMesin));
    } else {
      request.fields['kartu_mesin'] = kartuMesin;
    }

    var response = await http.Response.fromStream(await request.send());
    print(response.body);
    return response;
  }

  static Future<http.Response> editdata(
      String namaTabel,
      String id,
      String namaAsset,
      String jenisAsset,
      String kondisi,
      String statusPemakaian,
      int utilisasi,
      int tahunPerolehan,
      int umurTeknis,
      String sumberDana,
      int nilaiPerolehan,
      int nilaiBuku,
      String rencanaOptimisasi,
      String lokasi,
      String userEdit,
      String merk,
      String tipeMesin,
      String dataSheet,
      String kartuMesin,
      String kartuElektronik,
      bool linkdrive,
      ) async {
    var uri = Uri.parse("http://192.168.1.12:3000/assets/"+namaTabel);
    var request = http.MultipartRequest('PUT', uri)
      ..fields['id'] = id
      ..fields['nama_asset'] = namaAsset
      ..fields['jenis_asset'] = jenisAsset
      ..fields['kondisi'] = kondisi
      ..fields['status_pemakaian'] = statusPemakaian
      ..fields['utilisasi'] = utilisasi.toString()
      ..fields['tahun_perolehan'] = tahunPerolehan.toString()
      ..fields['umur_teknis'] = umurTeknis.toString()
      ..fields['sumber_dana'] = sumberDana
      ..fields['nilai_perolehan'] = nilaiPerolehan.toString()
      ..fields['nilai_buku'] = nilaiBuku.toString()
      ..fields['rencana_optimisasi'] = rencanaOptimisasi
      ..fields['lokasi'] = lokasi
      ..fields['user_edit'] = userEdit
      ..fields['merk'] = merk
      ..fields['tipe_mesin'] = tipeMesin
      ..fields['kartu_elektronik'] = kartuElektronik;

    if (linkdrive) {
      request.fields['data_sheet'] = dataSheet;
    } else {
      if(File(dataSheet).existsSync()){
        request.files.add(await http.MultipartFile.fromPath('data_sheet', dataSheet));
      }else{
        request.fields['data_sheet'] = dataSheet;
      }
    }
    if (File(kartuMesin).existsSync()) {
      request.files.add(await http.MultipartFile.fromPath('kartu_mesin', kartuMesin));
    } else {
      request.fields['kartu_mesin'] = kartuMesin;
    }
    var response = await http.Response.fromStream(await request.send());
    print(response.body);
    return response;
  }
}
