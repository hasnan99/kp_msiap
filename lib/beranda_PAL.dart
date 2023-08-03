import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kp_msiap/widget/asset_DI.dart';
import 'package:kp_msiap/widget/asset_dahana.dart';
import 'package:kp_msiap/excel.dart';
import 'package:kp_msiap/widget/asset_pal.dart';
import 'beranda.dart';
import 'beranda_DI.dart';
import 'beranda_dahana.dart';
import 'beranda_pindad.dart';

class Beranda_PAL extends StatefulWidget {
  const Beranda_PAL({Key? key}) : super(key: key);

  @override
  _Beranda_PAL createState() => _Beranda_PAL();
}

class _Beranda_PAL extends State<Beranda_PAL> {
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
        title: const Text('Daftar Aset PAL'),
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
                AssetPAL(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
