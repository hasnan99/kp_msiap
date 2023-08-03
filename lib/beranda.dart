import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kp_msiap/add_data.dart';
import 'package:kp_msiap/beranda_DI.dart';
import 'package:kp_msiap/beranda_PAL.dart';
import 'package:kp_msiap/beranda_dahana.dart';
import 'package:kp_msiap/beranda_pindad.dart';
import 'package:kp_msiap/excel.dart';
import 'package:kp_msiap/qr_scanner.dart';
import 'package:kp_msiap/view_table.dart';
import 'package:kp_msiap/widget/asset_item.dart';
import 'package:kp_msiap/widget/table_asset.dart';
import 'package:permission_handler/permission_handler.dart';

class Beranda extends StatefulWidget {
  const Beranda({Key? key}) : super(key: key);

  @override
  _BerandaState createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  int currentIndex = 0;
  final _auth = FirebaseAuth.instance;
  late User? user;

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void getuseremail() async {
    user = _auth.currentUser; // Mengambil data user setelah berhasil login
  }

  void getpermission()async{
    await Permission.notification.isDenied.then((value) {
      if(value){
        Permission.notification.request();
      }
    });
    await Permission.storage.isDenied.then((value){
      if(value){
        Permission.storage.request();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getuseremail();
    getpermission();
  }

  @override
  Widget build(BuildContext context) {
    Widget bottomNavBar() {
      return BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.red,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.library_books_rounded,
              color: currentIndex == 0 ? Colors.red : Colors.black,
            ),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.table_chart,
              color: currentIndex == 1 ? Colors.red : Colors.black,
            ),
            label: 'Tables asset',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
              color: currentIndex == 2 ? Colors.red : Colors.black,
            ),
            label: 'Tambah Data',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.qr_code_scanner,
              color: currentIndex == 3 ? Colors.red : Colors.black,
            ),
            label: 'Scan Qr',
          ),
        ],
      );
    }

    Widget body() {
      switch (currentIndex) {
        case 0:
          return Scaffold(
            appBar: AppBar(
              title: const Text('Daftar Aset Len'),
            ),
            drawer: Drawer( // Add a Drawer widget for the sidebar menu
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Center(
                    child: Container(
                      color: Colors.red,
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/Logo_siap.png',
                        width: 105,
                        alignment: Alignment.center,
                        fit: BoxFit.fill,
                        height: 100,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 80,
                    child: UserAccountsDrawerHeader(
                      accountName: const Text("Username"), // Replace with the user's name
                      accountEmail: Text(user?.email??''), // Replace with the user's email
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.document_scanner_sharp),
                    title: const Text('Buka File Excel'),
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>const upload_excel()));
                    },
                  ),
                  ExpansionTile(
                    leading: const Icon(Icons.dataset),
                    title: const Text("Workspace"),
                    children: [
                      ListTile(
                        leading: Image.asset("assets/Logo-Len.png",
                            width: 60),
                        title: const Text("PT Len"),
                        onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context)=>const Beranda()));
                        },
                      ),
                      ListTile(
                        leading: Image.asset("assets/logo_dahana.png",
                            width: 60),
                        title: const Text("PT Dahana"),
                        onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context)=>const Beranda_dahana()));
                        },
                      ),
                      ListTile(
                        leading: Image.asset("assets/Logo_PT_Pindad_(Persero).png",
                            width: 60),
                        title: const Text("PT Pindad"),
                        onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context)=>const Beranda_pindad()));
                        },
                      ),
                      ListTile(
                        leading: Image.asset("assets/logo_dirgantara.png",
                            width: 47),
                        title: const Text("    PT Dirgantara"),
                        onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context)=>const Beranda_DI()));
                        },
                      ),
                      ListTile(
                        leading: Image.asset("assets/2560px-PT-PAL.svg.png",
                            width: 60),
                        title: const Text("PT Pal"),
                        onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context)=>const Beranda_PAL()));
                        },
                      ),
                    ],
                  ),
                ],
              ),
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
                      AssetItem(),
                    ],
                  ),
                ),
              ],
            ),
          );
        case 1:
          return const view_table();
        case 2:
          return const AddData();
        case 3:
          return const ScanQR();
        default:
          return Scaffold(
            appBar: AppBar(
              title: const Text('Beranda'),
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
                      AssetItem(),
                    ],
                  ),
                ),
              ],
            ),
          );
      }
    }

    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        body: SafeArea(
          child: body(),
        ),
        bottomNavigationBar: bottomNavBar(),
      ),
    );
  }
}
