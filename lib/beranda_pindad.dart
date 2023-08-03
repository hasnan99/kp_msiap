import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kp_msiap/excel.dart';
import 'package:kp_msiap/widget/asset_pindad.dart';
import 'beranda.dart';
import 'beranda_DI.dart';
import 'beranda_PAL.dart';
import 'beranda_dahana.dart';

class Beranda_pindad extends StatefulWidget {
  const Beranda_pindad({Key? key}) : super(key: key);

  @override
  _Beranda_pindad createState() => _Beranda_pindad();
}

class _Beranda_pindad extends State<Beranda_pindad> {
  int currentIndex = 0;

  final _auth = FirebaseAuth.instance;
  late User? user;

  void getuseremail() async {
    user = _auth.currentUser; // Mengambil data user setelah berhasil login
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    getuseremail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Daftar Aset Pindad'),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 15),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: const Column(
              children: [
                Assetpindad(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
