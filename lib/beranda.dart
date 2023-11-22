import 'dart:async';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kp_msiap/News.dart';
import 'package:kp_msiap/api/sheet_api.dart';
import 'package:kp_msiap/buka_link_mailbox.dart';
import 'package:kp_msiap/form_mesin/form_mesin.dart';
import 'package:kp_msiap/mesin/mesin_dahana.dart';
import 'package:kp_msiap/mesin/mesin_len.dart';
import 'package:kp_msiap/mesin/mesin_pindad.dart';
import 'package:kp_msiap/model/mailbox.dart';
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
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:refresh/refresh.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'buka_link_news.dart';
import 'mailbox_in.dart';
import 'mailbox_out.dart';
import 'mesin/mesin_di.dart';
import 'mesin/mesin_pal.dart';
import 'model/log.dart';
import 'model/news.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

import 'model/sheet.dart';

class Beranda extends StatefulWidget {
  const Beranda({Key? key}) : super(key: key);
  @override
  _BerandaState createState() => _BerandaState();

}

class _BerandaState extends State<Beranda> {
  int currentIndex = 0;
  int jumlah_news=0;
  int jumlah_mailbox_in=0;
  int jumlah_mailbox_out=0;
  int total_mailbox=0;
  int total_notif=0;
  int total_len=0;
  late TutorialCoachMark tutorialCoachMark;
  final _auth = FirebaseAuth.instance;
  late User? user;
  bool floatExtended = false;
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  AssetItem assetItem = AssetItem(onTextFieldValue: (String ) {  },);

  String querydata="";

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

  Future<int> _fetchJumlahNews() async {
    List<news> newsData = await sheet_api.getnews();
    return newsData.length;
  }

  Future<int> _fetchJumlahmailbox_in() async {
    List<mailbox> newsData = await sheet_api.getmailbox_in();
    return newsData.length;
  }

  Future<int> _fetchJumlahmailbox_Out() async {
    List<mailbox> newsData = await sheet_api.getmailbox_out();
    return newsData.length;
  }
  Future<int> _fetchJumlahNotif() async {
    List<Log> logData = await sheet_api.getLog();
    return logData.length;
  }

  Future<int> _fetchJumlahlen() async {
    List<sheet> Datalen = await sheet_api.getAssetLen();
    return Datalen.length;
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
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }
  }

  void showCustomDialog() async {
    var link_gambar = "https://docs.google.com/spreadsheets/d/1ixFCnZzbkQuFHoja_R3U059_td6s5k2RyiWA9-zWfV4/edit#gid=0";
    var link_google =
        "https://script.google.com/macros/s/AKfycbzEJ_pzQHhebpIxOX7LgMig5kpwMk064XMdPygz_2sAJMZNw1Oj97NB_ocLa17mksX7/exec?link=$link_gambar";

    var response = await http.get(Uri.parse(link_google));

    if (response.statusCode == 200) {
      String data = response.body;

      String extractFileId(String googleDriveUrl) {
        RegExp regExp = RegExp(r"/d/([a-zA-Z0-9_-]+)");
        Match? match = regExp.firstMatch(googleDriveUrl);
        if (match != null && match.groupCount >= 1) {
          return match.group(1)!;
        }
        return "";
      }

      String convertToDirectDownloadUrl(String fileId) {
        return "https://drive.google.com/uc?export=view&id=$fileId";
      }
      var link_hasil=extractFileId(data);
      var link=convertToDirectDownloadUrl(link_hasil);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  child:PDF().cachedFromUrl(
                      link,
                    placeholder: (progress) => Center(child: Text('$progress %')),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      showtutorial();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.close, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      print("Gagal mengambil data dari Google Sheets. Status code: ${response.statusCode}");
    }
  }


  @override
  void initState() {
    super.initState();
    getuseremail();
    getpermission();
    buat_tutor();
    SharedPreferences.getInstance().then((prefs) {
      bool popUP = prefs.getBool('popUP') ?? true;
      if (popUP) {
        Future.delayed(Duration.zero, showCustomDialog);
        prefs.setBool('popUP', false);
      }
    });
    _fetchJumlahNews().then((jumlah) {
      setState(() {
        jumlah_news = jumlah;
      });
    });
    _fetchJumlahmailbox_in().then((jumlah) {
      setState(() {
        jumlah_mailbox_in = jumlah;
        total_mailbox = jumlah_mailbox_in + jumlah_mailbox_out;
      });
    });
    _fetchJumlahmailbox_Out().then((jumlah) {
      setState(() {
        jumlah_mailbox_out = jumlah;
        total_mailbox = jumlah_mailbox_in + jumlah_mailbox_out;
      });
    });
    _fetchJumlahNotif().then((jumlah) {
      setState(() {
        total_notif = jumlah;
      });
    });

    _fetchJumlahlen().then((jumlah) {
      setState(() {
        total_len = jumlah;
      });
    });

    assetItem=AssetItem(
      onTextFieldValue: (value){
        setState(() {
          querydata=value;
        });
      },
    );
  }

  Future <void> _onRefresh() async{
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      assetItem.assetItemKey.currentState?.refreshData();
    });
    _refreshController.refreshCompleted();
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
              title:Text('Daftar Aset Len ${total_len.toString()} unit' ),
              actions: [
                IconButton(onPressed: () async{
                  total_notif = await Navigator.push(context, MaterialPageRoute(
                      builder: (context)=>const Notifikasi_log()));
                  setState(() {
                    total_notif = total_notif;
                  });
                },
                    key: keyButtonnotif,
                  icon: total_notif > 0
                      ? badges.Badge(
                    badgeContent: Text(
                      total_notif.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Icon(Icons.notifications),
                  )
                      : const Icon(Icons.notifications),
                ),
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
                        'assets/splash3.png',
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
                      accountName: const Text(
                        "Username",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      accountEmail: Row(
                        children: [
                          Text(
                            user?.email ?? '',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(width: 80),
                          ClipOval(
                            child: FadeInImage.assetNetwork(
                              image: user?.photoURL ?? '',
                              width: 55,
                              height: 55,
                              fit: BoxFit.cover,
                              imageErrorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace){
                                return Image.network('https://cdn3.iconfinder.com/data/icons/avatars-round-flat/33/avat-01-512.png',
                                  width: 55,
                                  height: 55,
                                  fit: BoxFit.cover,);
                              }, placeholder: '' ,
                            ),
                          ),
                        ],
                      ),
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
                    title: const Text("Workspace Asset Mesin Indhan"),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: ListTile(
                          leading: Image.asset("assets/Logo-Len.png",
                              width: 60),
                          title: const Text("PT Len"),
                          onTap: (){
                            Navigator.pushReplacement(context,
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
                                MaterialPageRoute(builder: (context)=> Beranda_dahana(query:querydata)));
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
                                MaterialPageRoute(builder: (context)=> Beranda_pindad( query:querydata,)));
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
                                MaterialPageRoute(builder: (context)=> Beranda_DI( query:querydata,)));
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
                                MaterialPageRoute(builder: (context)=> Beranda_PAL( query:querydata,)));
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
                    leading:const Icon(Icons.ad_units),
                    title: const Text('Kapabilitas Fungsi Mesin Indhan'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: ListTile(
                          leading: Image.asset("assets/Logo-Len.png",
                              width: 60),
                          title: const Text("PT Len"),
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context)=>const mesin_len()));
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
                                MaterialPageRoute(builder: (context)=>const mesin_dahana()));
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
                                MaterialPageRoute(builder: (context)=>const mesin_pindad()));
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
                                MaterialPageRoute(builder: (context)=>const mesin_di()));
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
                                MaterialPageRoute(builder: (context)=>const mesin_pal()));
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
                    leading: const Icon(Icons.document_scanner_outlined,color: Colors.white,),
                    title: const Text(
                      'Form Kebutuhan Mesin',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context)=> const form_mesin()));
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
                    leading: total_mailbox >0 ? badges.Badge(
                      badgeContent: Text(total_mailbox.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),),
                      child: const Icon(Icons.email),
                    ):const Icon(Icons.email),
                    title: const Text("MailBox"),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: ListTile(
                          title: const Text("Mail Box In"),
                          onTap: () async {
                            jumlah_mailbox_in = await Navigator.push(context, MaterialPageRoute(builder: (context) => const Mailbox_in()));
                            setState(() {
                              jumlah_mailbox_in = jumlah_mailbox_in;
                              total_mailbox = jumlah_mailbox_in + jumlah_mailbox_out;
                            });
                          },
                          leading: jumlah_mailbox_in > 0
                              ? badges.Badge(
                            badgeContent: Text(
                              jumlah_mailbox_in.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: const Icon(Icons.mark_email_unread),
                          )
                              : const Icon(Icons.mark_email_unread),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: ListTile(
                          title: const Text("Mail Box Out"),
                          onTap: () async {
                            jumlah_mailbox_out = await Navigator.push(context, MaterialPageRoute(builder: (context) => const Mailbox_out()));
                            setState(() {
                              jumlah_mailbox_out = jumlah_mailbox_out;
                              total_mailbox = jumlah_mailbox_in + jumlah_mailbox_out;
                            });
                          },
                          leading: jumlah_mailbox_out > 0
                              ? badges.Badge(
                            badgeContent: Text(
                              jumlah_mailbox_out.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: const Icon(Icons.mark_email_read),
                          )
                              : const Icon(Icons.mark_email_read),
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
                    title: const Text(
                      'News',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () async {
                      jumlah_news = await Navigator.push(context, MaterialPageRoute(builder: (context) => const News()));
                      setState(() {
                        jumlah_news = jumlah_news;
                      });
                    },
                    leading: jumlah_news > 0
                        ? badges.Badge(
                      badgeContent: Text(
                        jumlah_news.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Icon(Icons.article, color: Colors.white),
                    )
                        : const Icon(Icons.article, color: Colors.white),
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
                                    Icon(Icons.brightness_1,
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
                                    Icon(Icons.brightness_1,
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
                      prefs.remove('popUP');
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
              enablePullUp: false,
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
                          onTextFieldValue: (value){
                            setState(() {
                              querydata=value;
                            });
                          },
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
