import 'package:flutter/material.dart';
import 'package:kp_msiap/datatables.dart';
import 'package:kp_msiap/widget/table_asset.dart';
import 'beranda.dart';
import 'login.dart';

void main() {
  runApp(MaterialApp(
    home: login(),
  ));
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget bottomNavBar() {
      return BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.green,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books_rounded,
              color: currentIndex == 0 ? Colors.red : Colors.black,
            ),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.table_chart,
              color: currentIndex == 1 ? Colors.red : Colors.black,
            ),
            label: 'Tables asset',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle,
              color: currentIndex == 2 ? Colors.red : Colors.black,
            ),
            label: 'Pesanan',
          ),
        ],
      );
    }

    Widget body() {
      switch (currentIndex) {
        case 0:
          return Beranda();
        case 1:
          return Container();
        case 2:
          return Container();
        default:
          return login();
      }
    }

    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.green,
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
