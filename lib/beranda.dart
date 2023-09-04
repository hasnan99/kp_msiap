import 'dart:async';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kp_msiap/News.dart';
import 'package:kp_msiap/buka_link_mailbox.dart';
import 'package:kp_msiap/tambah%20data/add_data_len.dart';
import 'package:kp_msiap/beranda_DI.dart';
import 'package:kp_msiap/beranda_PAL.dart';
import 'package:kp_msiap/beranda_dahana.dart';
import 'package:kp_msiap/beranda_pindad.dart';
import 'package:kp_msiap/buka_link.dart';
import 'package:kp_msiap/excel.dart';
import 'package:kp_msiap/log_notifikasi.dart';
import 'package:kp_msiap/login.dart';
import 'package:kp_msiap/qr_scanner.dart';
import 'package:kp_msiap/tambah%20data/tambah_qr.dart';
import 'package:kp_msiap/view_statistik.dart';
import 'package:kp_msiap/view_table.dart';
import 'package:kp_msiap/widget/asset_len.dart';
import 'package:badges/badges.dart'as badges;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:refresh/refresh.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'buka_link_news.dart';
import 'mailbox_in.dart';
import 'mailbox_out.dart';

class Beranda extends StatefulWidget {
  const Beranda({Key? key}) : super(key: key);
  @override
  _BerandaState createState() => _BerandaState();

}

class _BerandaState extends State<Beranda> {
  int currentIndex = 0;
  late TutorialCoachMark tutorialCoachMark;
  final _auth = FirebaseAuth.instance;
  late User? user;
  bool floatExtended = false;
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  AssetItem assetItem = AssetItem();

  GlobalKey keyButtonnotif = GlobalKey();
  GlobalKey keyButtontambah = GlobalKey();

  GlobalKey keyBottomBeranda = GlobalKey();
  GlobalKey keyBottomTable = GlobalKey();
  GlobalKey keyBottomQR = GlobalKey();

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void buat_tutor(){
    tutorialCoachMark = TutorialCoachMark(
      targets: buat_target(),
      colorShadow: Colors.green,
      textSkip: "Lewati",
      textStyleSkip: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      paddingFocus: 10,
      opacityShadow: 0.8,
      imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      onFinish: (){
        print("Selesai");
      },
      onClickTarget: (target){
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print("clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip:  () {
        print("skip");
      },
    );
  }
  void showtutorial(){
    tutorialCoachMark.show(context: context);
  }

  List<TargetFocus>buat_target() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "Target Notif",
        keyTarget: keyButtonnotif,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Tombol Notifikasi",
                    style:TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20.0,
                    ),
                  ),
                  Padding(
                      padding:EdgeInsets.only(top: 10),
                      child: Text("Tombol ini digunakan untuk melihat notifikasi",
                        style:TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
                      )
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target Tambah",
        keyTarget: keyButtontambah,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Tombol Tambah",
                    style:TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20.0,
                    ),
                  ),
                  Padding(
                      padding:EdgeInsets.only(top: 10),
                      child: Text("Jika ingin Menambahkan Asset/Gambar Asset, gunakan tombol ini",
                        style:TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
                      )
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target Beranda",
        keyTarget: keyBottomBeranda,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Beranda",
                    style:TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20.0,
                    ),
                  ),
                  Padding(
                      padding:EdgeInsets.only(top: 10),
                      child: Text("Halaman ini adalah beranda dari aplikasi ini",
                        style:TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
                      )
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target Table",
        keyTarget: keyBottomTable,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Table",
                    style:TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20.0,
                    ),
                  ),
                  Padding(
                      padding:EdgeInsets.only(top: 10),
                      child: Text("Klik halaman ini jika ingin melihat asset dengan tampilan table dari PT",
                        style:TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                      )
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
    targets.add(
        TargetFocus(
            identify: "Target QR",
            keyTarget: keyBottomQR,
            contents: [
              TargetContent(
                align: ContentAlign.top,
                builder: (context, controller) {
                  return const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Scan Qr",
                        style:TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                      ),
                      Padding(
                          padding:EdgeInsets.only(top: 10),
                          child: Text("Klik halaman ini untuk scan QR pada aset lalu akan menampilkan detail dari aset tersebut",
                            style:TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 15.0,
                            ),
                          )
                      )
                    ],
                  );
                },
              ),
            ]
        )
    );
    return targets;
  }

  void getuseremail() async {
    user = _auth.currentUser;
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
    buat_tutor();
    Future.delayed(Duration.zero, showtutorial);
  }

  Future <void> _onRefresh() async{
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      assetItem.assetItemKey.currentState?.refreshData();
    });
    _refreshController.refreshCompleted();
  }

  Future <void> _onLoading() async{
    await Future.delayed(const Duration(seconds: 1));
    setState(() {// Create an instance of AssetItem
      assetItem.assetItemKey.currentState?.refreshData();
    });
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    Widget bottomNavBar() {
      return BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.black,
        selectedItemColor: const Color(0xff4B5526),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.library_books_rounded,
              color: currentIndex == 0 ? const Color(0xff4B5526) : Colors.black,
              key: keyBottomBeranda,
            ),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.table_chart,
              color: currentIndex == 1 ? const Color(0xff4B5526) : Colors.black,
              key: keyBottomTable,
            ),
            label: 'Tables asset',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              key: keyBottomQR,
              Icons.qr_code_scanner,
              color: currentIndex == 2 ? const Color(0xff4B5526) : Colors.black,
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
              backgroundColor: const Color(0xff4B5526),
              title: const Text('Daftar Aset Len'),
              actions: [
                IconButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context)=>const Notifikasi_log()));
                },
                    key: keyButtonnotif,
                    icon: const Icon(Icons.notifications)),
              ],
            ),
            drawer: Drawer(
              backgroundColor: Colors.grey[300],
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Center(
                    child: Container(
                      color: Colors.white,
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
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      accountName: const Text("Username",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),),
                      accountEmail: Text(user?.email??'',
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          fontSize: 15),),
                    ),
                  ),
                  ExpansionTile(
                    collapsedBackgroundColor: const Color(0xff4B5526),
                    collapsedShape: RoundedRectangleBorder(
                      side: const BorderSide(width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    collapsedIconColor: Colors.white,
                    collapsedTextColor: Colors.white,
                    leading: const Icon(Icons.dataset),
                    title: const Text("Workspace"),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: ListTile(
                          leading: Image.asset("assets/Logo-Len.png",
                              width: 60),
                          title: const Text("PT Len"),
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context)=>const Beranda()));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: ListTile(
                          leading: Image.asset("assets/logo_dahana.png",
                              width: 60),
                          title: const Text("PT Dahana"),
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context)=>const Beranda_dahana()));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: ListTile(
                          leading: Image.asset("assets/Logo_PT_Pindad_(Persero).png",
                              width: 60),
                          title: const Text("PT Pindad"),
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context)=>const Beranda_pindad()));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: ListTile(
                          leading: Image.asset("assets/logo_dirgantara.png",
                              width: 47),
                          title: const Text("    PT Dirgantara"),
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context)=>const Beranda_DI()));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: ListTile(
                          leading: Image.asset("assets/2560px-PT-PAL.svg.png",
                              width: 60),
                          title: const Text("PT Pal"),
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context)=>const Beranda_PAL()));
                          },
                        ),
                      ),
                    ],
                  ),
                  ExpansionTile(
                    collapsedBackgroundColor: const Color(0xff4B5526),
                    collapsedShape: RoundedRectangleBorder(
                      side: const BorderSide(width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    collapsedIconColor: Colors.white,
                    collapsedTextColor: Colors.white,
                    leading: const Icon(Icons.mail),
                    title: const Text("MailBox"),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: ListTile(
                          leading: const Icon(Icons.mark_email_unread),
                          title: const Text("Mail Box In"),
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context)=>const Mailbox_in()));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: ListTile(
                          leading:const Icon(Icons.mark_email_read),
                          title: const Text("Mail Box Out"),
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context)=>const Mailbox_out()));
                          },
                        ),
                      ),

                    ],
                  ),
                  ListTile(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    tileColor: const Color(0xff4B5526),
                    leading:const Icon(Icons.article,color: Colors.white,),
                    title: const Text('News',style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),),
                    onTap: () async {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context)=> const News()));
                    },
                  ),
                  ListTile(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    tileColor: const Color(0xff4B5526),
                    leading: const Icon(Icons.add_chart,color: Colors.white,),
                    title: const Text('Statistik',style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),),
                    onTap: () async {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context)=> const view_statistik()));
                    },
                  ),
                  ExpansionTile(
                    collapsedBackgroundColor: const Color(0xff4B5526),
                    collapsedShape: RoundedRectangleBorder(
                      side: const BorderSide(width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    collapsedIconColor: Colors.white,
                    collapsedTextColor: Colors.white,
                    leading: const Icon(Icons.link),
                    title: const Text("Buka Link"),
                    children: [
                      Padding(
                          padding:const EdgeInsets.only(left: 25),
                        child: ListTile(
                          title: const Text("Buka Link Asset Spreadsheet"),
                          onTap: () async {
                            bool result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const BukaLink_Asset()),
                            );
                            setState(() {
                              link = result ?? false;
                            });
                          },
                          leading: Stack(
                            children: [
                              const Icon(
                                Icons.link,
                              ),
                              Positioned(
                                top: -1.0,
                                right: -1.0,
                                child: Stack(
                                  children: [
                                    new Icon(Icons.brightness_1,
                                      size: 12.0,
                                      color: link ? Colors.green : Colors.red,)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding:const EdgeInsets.only(left: 25),
                        child: ListTile(
                          title: const Text("Buka Link News Spreadsheet"),
                          onTap: () async {
                            bool result_news = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const BukaLink_News()),
                            );
                            setState(() {
                              link_news = result_news ?? false;
                            });
                          },
                          leading: Stack(
                            children: [
                              const Icon(
                                Icons.link,
                              ),
                              Positioned(
                                top: -1.0,
                                right: -1.0,
                                child: Stack(
                                  children: [
                                    new Icon(Icons.brightness_1,
                                      size: 12.0,
                                      color: link_news ? Colors.green : Colors.red,)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding:const EdgeInsets.only(left: 25),
                        child: ListTile(
                          title: const Text("Buka Link Mailbox Spreadsheet"),
                          onTap: () async {
                            bool result_mailbox = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const BukaLink_Mailbox()),
                            );
                            setState(() {
                              link_mailbox = result_mailbox ?? false;
                            });
                          },
                          leading: Stack(
                            children: [
                              const Icon(
                                Icons.link,
                              ),
                              Positioned(
                                top: -1.0,
                                right: -1.0,
                                child: Stack(
                                  children: [
                                    new Icon(Icons.brightness_1,
                                      size: 12.0,
                                      color: link_mailbox ? Colors.green : Colors.red,)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  ListTile(
                    tileColor: const Color(0xff4B5526),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    leading: const Icon(Icons.document_scanner_sharp,color: Colors.white,),
                    title: const Text('Buka File Excel',
                        style: TextStyle(
                            color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                    ),
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>const upload_excel()));
                    },
                  ),
                  ListTile(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    tileColor: const Color(0xff4B5526),
                    leading: Image.asset("assets/Icon/icon_logout.png",
                      height: 80.0,width: 25.0,
                      alignment: Alignment.centerLeft,
                      color: Colors.white,),
                    title: const Text('Log Out',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),),
                    onTap: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.remove('uid');
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context)=>const login()));
                    },
                  ),
                ],
              ),
            ),
            body:SmartRefresher(
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
                        AssetItem(
                          key: assetItem.assetItemKey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: SpeedDial(
              key: keyButtontambah,
              child: const Icon(Icons.add),
              animatedIconTheme: const IconThemeData(size: 22.0),
              backgroundColor: const Color(0xff4B5526),
              label: const Text("Tambah Asset"),
              visible: true,
              curve: Curves.bounceIn,
              children: [
                SpeedDialChild(
                  child: const Icon(Icons.photo),
                  backgroundColor: Colors.white,
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>const AddData_len()));},
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>const addScanQR()));
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
        case 1:
          return const view_table();
        case 2:
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
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff4B5526),
        ),
        primaryColor: const Color(0xff4B5526),
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
