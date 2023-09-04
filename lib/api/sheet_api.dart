import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kp_msiap/model/sheet.dart';

import '../model/mailbox.dart';
import '../model/news.dart';
import '../model/sheet_add.dart';

class sheet_api {
  // Google App Script Web URL.
  static const String URL_len =
      "http://192.168.249.136:3000/table/get?nama_tabel=len_assets";

  static const String URL_dahana =
      "http://192.168.249.136:3000/table/get?nama_tabel=dahana_assets";

  static const String URL_DI =
      "http://192.168.249.136:3000/table/get?nama_tabel=di_assets";

  static const String URL_Pindad =
      "http://192.168.249.136:3000/table/get?nama_tabel=pindad_assets";

  static const String URL_PAL =
      "http://192.168.249.136:3000/table/get?nama_tabel=pal_assets";

  static const String URL_news =
      "http://192.168.249.136:3000/table/get?nama_tabel=news";

  static const String URL_mailbox_in =
      "http://192.168.249.136:3000/table/get?nama_tabel=mailbox_in";

  static const String URL_mailbox_out =
      "http://192.168.249.136:3000/table/get?nama_tabel=mailbox_out";

  static const String URL_post=
      "https://script.google.com/macros/s/AKfycbxCdY62bBLixrxxX7IusDUByjomSbHygHXtUf8ArLtdjCZ6JIlX_vXiUY_2_eCVAZyA0w/exec";

  static const STATUS_SUCCESS = "SUCCESS";
  void submitForm(sheet_add feedbackForm, void Function(String) callback) async {
    try {
      final response = await http.post(Uri.parse(URL_post), body: feedbackForm.toJson());
      if (response.statusCode == 302) {
        final url = response.headers['location'];
        final getResponse = await http.get(Uri.parse(url!));
        callback(jsonDecode(getResponse.body)['status']);
      } else {
        callback(jsonDecode(response.body)['status']);
      }
    } catch (e) {
      print(e);
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

  static Future<http.Response> tambahdata(String nama_tabel , String nama_asset , String jenis_asset , String kondisi, String status_pemakaian ,
    int utilisasi, int tahun_perolehan,int umur_teknis ,String sumber_dana,int nilai_perolehan,int nilai_buku ,String rencana_optimisasi, String lokasi,String gambar,String user_edit) async {
    Map data={
      "nama_tabel":nama_tabel,
      "nama_asset":nama_asset,
      "jenis_asset":jenis_asset,
      "kondisi":kondisi,
      "status_pemakaian":status_pemakaian,
      "utilisasi":utilisasi,
      "tahun_perolehan":tahun_perolehan,
      "umur_teknis":umur_teknis,
      "sumber_dana":sumber_dana,
      "nilai_perolehan":nilai_perolehan,
      "nilai_buku":nilai_buku,
      "rencana_optimisasi":rencana_optimisasi,
      "lokasi":lokasi,
      "gambar":gambar,
      "user_edit":user_edit
    };
    var body=json.encode(data);
    var url=Uri.parse("http://192.168.1.13:3000/table/insert");
    http.Response response =await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body
    );
    print(response.body);
    return response;
  }

  static Future<http.Response> editdata(String nama_tabel , int Id,String nama_asset , String jenis_asset , String kondisi, String status_pemakaian ,
      int utilisasi, int tahun_perolehan,int umur_teknis ,String sumber_dana,int nilai_perolehan,int nilai_buku ,String rencana_optimisasi, String lokasi,String gambar,String user_edit) async {
    Map data={
      "nama_tabel":nama_tabel,
      "id":Id,
      "nama_asset":nama_asset,
      "jenis_asset":jenis_asset,
      "kondisi":kondisi,
      "status_pemakaian":status_pemakaian,
      "utilisasi":utilisasi,
      "tahun_perolehan":tahun_perolehan,
      "umur_teknis":umur_teknis,
      "sumber_dana":sumber_dana,
      "nilai_perolehan":nilai_perolehan,
      "nilai_buku":nilai_buku,
      "rencana_optimisasi":rencana_optimisasi,
      "lokasi":lokasi,
      "gambar":gambar,
      "user_edit":user_edit
    };
    var body=json.encode(data);
    var url=Uri.parse("http://192.168.1.13:3000/table/update");
    http.Response response =await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: body
    );
    print(response.body);
    return response;
  }

  static Future<http.Response> tambahnews(String nama_tabel , String nama_user , String nama_file) async {
    Map data={
      "nama_tabel":nama_tabel,
      "nama_user":nama_user,
      "nama_file":nama_file
    };
    var body=json.encode(data);
    var url=Uri.parse("http://192.168.1.13:3000/news/insert");
    http.Response response =await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body
    );
    print(response.body);
    return response;
  }
}
