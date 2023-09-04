import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class auth{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  static const Map<String,String> headers={"Content-Type":"application/json"};

  Future<void>register(String email,String password)async{
   final user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<UserCredential?> login(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (error) {
      // Handle login errors
      return null;
    }
  }

  static Future<http.Response> daftar(String username,String email,String password) async{
    Map data={
      "name":username,
      "email":email,
      "password":password,
    };
    var body =json.encode(data);
    var url=Uri.parse('http://192.168.249.136:8000/api/auth/register');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    print(response.body);
    return response;
  }
}