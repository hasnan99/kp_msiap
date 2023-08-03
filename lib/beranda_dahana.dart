import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kp_msiap/widget/asset_dahana.dart';
import 'package:kp_msiap/excel.dart';
import 'beranda.dart';
import 'beranda_DI.dart';
import 'beranda_PAL.dart';
import 'beranda_pindad.dart';

class Beranda_dahana extends StatefulWidget {
  const Beranda_dahana({Key? key}) : super(key: key);

  @override
  _Beranda_dahana createState() => _Beranda_dahana();
}

class _Beranda_dahana extends State<Beranda_dahana> {
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
              title: const Text('Daftar Aset Dahana'),
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
                      AssetDahana(),
                    ],
                  ),
                ),
              ],
            ),
          );
      }
    }
