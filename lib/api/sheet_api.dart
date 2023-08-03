import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kp_msiap/model/sheet.dart';

import '../model/sheet_add.dart';

class sheet_api {
  // Google App Script Web URL.
  static const String URL_len =
      "https://script.google.com/macros/s/AKfycbwNAHQvcQc8WX9J6WxmdRhVlrqigCAnmp0vGfdwNkySdg5PfrtqHSvVC65mJ7ET7W6Irw/exec";

  static const String URL_dahana =
      "https://script.google.com/macros/s/AKfycbwGU9nZCPa3c87uw-jG3G9hJfB9G2pY0wLGj-es0PpsnCSDm0MFECxMGbn2RxYY0K_-GA/exec";

  static const String URL_DI =
      "https://script.google.com/macros/s/AKfycbyGeC0OCpDKR_iTXkCRjLf4PsOdGJm37W1ExWpQMMG0c3lnAGIaTdY6esmJ8bzVzB4fug/exec";

  static const String URL_Pindad =
      "https://script.google.com/macros/s/AKfycbzvWweW_ByRfPezmchE-obp7LhE9UsngyKClRjQljVawX5rqo1PME9wCqa_NWlV5OCXnQ/exec";

  static const String URL_PAL =
      "https://script.google.com/macros/s/AKfycbxoEqLAPSwWASXhbXeb-azctarRP4nPgVZuPXPbYsdceMo9oVQ6wcZgo_ajCJU2LThF8Q/exec";

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

  Future<List<sheet>> getAssetList() async {
    return await http.get(Uri.parse(URL_len)).then((response) {
      var jsonFeedback = json.decode(response.body) as List<dynamic>;
      return jsonFeedback.map((json) => sheet.fromJson(json)).toList();
    }).catchError((error) {
      print(error);
      return <sheet>[];
    });
  }

  Future<List<sheet>> getAssetDahana() async {
    return await http.get(Uri.parse(URL_dahana)).then((response) {
      var jsonFeedback = json.decode(response.body) as List<dynamic>;
      return jsonFeedback.map((json) => sheet.fromJson(json)).toList();
    }).catchError((error) {
      print(error);
      return <sheet>[];
    });
  }

  Future<List<sheet>> getAssetDI() async {
    return await http.get(Uri.parse(URL_DI)).then((response) {
      var jsonFeedback = json.decode(response.body) as List<dynamic>;
      return jsonFeedback.map((json) => sheet.fromJson(json)).toList();
    }).catchError((error) {
      print(error);
      return <sheet>[];
    });
  }

  Future<List<sheet>> getAssetPAL() async {
    return await http.get(Uri.parse(URL_PAL)).then((response) {
      var jsonFeedback = json.decode(response.body) as List<dynamic>;
      return jsonFeedback.map((json) => sheet.fromJson(json)).toList();
    }).catchError((error) {
      print(error);
      return <sheet>[];
    });
  }

  Future<List<sheet>> getAssetpindad() async {
    return await http.get(Uri.parse(URL_Pindad)).then((response) {
      var jsonFeedback = json.decode(response.body) as List<dynamic>;
      return jsonFeedback.map((json) => sheet.fromJson(json)).toList();
    }).catchError((error) {
      print(error);
      return <sheet>[];
    });
  }
}
