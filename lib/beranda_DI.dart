import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:kp_msiap/tambah%20data/add_data_di.dart';
import 'package:kp_msiap/widget/asset_DI.dart';
import 'package:refresh/refresh.dart';

class Beranda_DI extends StatefulWidget {
  const Beranda_DI({Key? key}) : super(key: key);

  @override
  _Beranda_DI createState() => _Beranda_DI();
}

class _Beranda_DI extends State<Beranda_DI> {
  int currentIndex = 0;

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  AssetDI assetDI = AssetDI();


  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Future <void> _onRefresh() async{
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      assetDI.assetItemKey.currentState?.refreshData();
    });
    _refreshController.refreshCompleted();
  }

  Future <void> _onLoading() async{
    await Future.delayed(const Duration(seconds: 1));
    setState(() {// Create an instance of AssetItem
      assetDI.assetItemKey.currentState?.refreshData();
    });
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff4B5526),
        title: const Text('Daftar Aset DI'),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        enablePullUp: true,
        enablePullDown: true,
        child:ListView(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 15),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  AssetDI(
                    key: assetDI.assetItemKey,
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
                  MaterialPageRoute(builder: (context)=>const AddData_di()));
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
