import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:kp_msiap/api/sheet_api.dart';
import 'package:kp_msiap/tambah%20data/add_data_pindad.dart';
import 'package:kp_msiap/widget/asset_pindad.dart';
import 'package:refresh/refresh.dart';

import 'model/sheet.dart';

class Beranda_pindad extends StatefulWidget {
  final String query;
  const Beranda_pindad({Key? key, required this.query}) : super(key: key);

  @override
  _Beranda_pindad createState() => _Beranda_pindad();
}

class _Beranda_pindad extends State<Beranda_pindad> {
  int currentIndex = 0;
  int jumlah_pindad=0;
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  Assetpindad assetpindad = Assetpindad(query: '',);

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  Future<int> _fetchJumlahpindad() async {
    List<sheet> Data = await sheet_api.getAssetpindad();
    return Data.length;
  }

  @override
  void initState() {
    super.initState();
    _fetchJumlahpindad().then((jumlah) {
      setState(() {
        jumlah_pindad = jumlah;
      });
    });
  }

  Future <void> _onRefresh() async{
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      assetpindad.assetItemKey.currentState?.refreshData();
    });
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff4B5526),
        title: Text('Daftar Aset Pindad ${jumlah_pindad.toString()} unit'),
      ),
      body:SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        enablePullUp: false,
        enablePullDown: true,
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 15),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Assetpindad(
                    key: assetpindad.assetItemKey,
                    query:widget.query,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        child: const Icon(Icons.add),
        animatedIconTheme: const IconThemeData(size: 22.0),
        backgroundColor: Color(0xff4B5526),
        label: const Text("Tambah Asset"),
        visible: true,
        curve: Curves.bounceIn,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.add),
            backgroundColor: Colors.white,
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>const AddData_pindad()));
            },
            label: 'Tambah Asset',
            labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Color(0xff4B5526),
          ),
          SpeedDialChild(
            child: const Icon(Icons.qr_code_scanner),
            backgroundColor: Colors.white,
            onTap: () {

            },
            label: 'Tambah dengan Scan QR',
            labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Color(0xff4B5526),
          ),
        ],
      ),
    );
  }
}
