import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class auth{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  static const Map<String,String> headers={"Content-Type":"application/json"};

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
}