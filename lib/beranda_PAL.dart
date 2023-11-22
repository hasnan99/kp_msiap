import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:kp_msiap/api/sheet_api.dart';
import 'package:kp_msiap/tambah%20data/add_data_pal.dart';
import 'package:kp_msiap/widget/asset_pal.dart';
import 'package:refresh/refresh.dart';

import 'model/sheet.dart';

class Beranda_PAL extends StatefulWidget {
  final String query;
  const Beranda_PAL({Key? key, required this.query}) : super(key: key);

  @override
  _Beranda_PAL createState() => _Beranda_PAL();
}

class _Beranda_PAL extends State<Beranda_PAL> {
  int currentIndex = 0;
  int jumlah_pal=0;
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  AssetPAL assetPAL = AssetPAL(query: '',);

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  Future<int> _fetchJumlahpal() async {
    List<sheet> Data = await sheet_api.getAssetPAL();
    return Data.length;
  }

  @override
  void initState() {
    super.initState();
    _fetchJumlahpal().then((jumlah) {
      setState(() {
        jumlah_pal = jumlah;
      });
    });
  }

  Future <void> _onRefresh() async{
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      assetPAL.assetItemKey.currentState?.refreshData();
    });
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff4B5526),
        title: Text('Daftar Aset PAL ${jumlah_pal.toString()} unit'),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        enablePullUp: false,
        enablePullDown: true,
        child:ListView(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 15),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child:  Column(
                children: [
                  AssetPAL(
                    key: assetPAL.assetItemKey,
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
        backgroundColor: const Color(0xff4B5526),
        label: const Text("Tambah Asset"),
        visible: true,
        curve: Curves.bounceIn,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.add),
            backgroundColor: Colors.white,
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>const AddData_pal()));
            },
            label: 'Tambah Asset',
            labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: const Color(0xff4B5526),
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
            labelBackgroundColor: const Color(0xff4B5526),
          ),
        ],
      ),
    );
  }
}
