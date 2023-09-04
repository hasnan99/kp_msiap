import 'package:flutter/material.dart';
import 'package:kp_msiap/widget/table_DI.dart';
import 'package:kp_msiap/widget/table_PAL.dart';
import 'package:kp_msiap/widget/table_len.dart';
import 'package:kp_msiap/widget/table_dahana.dart';
import 'package:kp_msiap/widget/table_pindad.dart';

class view_table extends StatefulWidget {
  const view_table({Key? key}) : super(key: key);

  @override
  _view_tableState createState() => _view_tableState();
}

class _view_tableState extends State<view_table> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => exit_app(context),
        child:Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff4B5526),
            title: const Text('Table'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 180,
                childAspectRatio: 1,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    if (index == 0) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>const TableAsset()));
                    }
                    if(index == 1){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>const Table_dahana()));
                    }
                    if(index == 2){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>const Table_DI()));
                    }
                    if(index == 3){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>const Table_pindad()));
                    }
                    if(index == 4){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>const Table_PAL()));
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color(0xffeef1f4),
                    ),
                    child: _buildItemWidget(index),
                  ),
                );
              },
            ),
          ),
        ),
    );
  }

  Widget _buildItemWidget(int index) {
    if (index == 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/Logo-Len.png',
            height: 80,
            width: 80,
          ),
          SizedBox(height: 10),
          Text('PT.Len'),
        ],
      );
    } else if (index == 1) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo_dahana.png',
            height: 80,
            width: 80,
          ),
          SizedBox(height: 10),
          Text('Pt.Dahana'),
        ],
      );
    } else if (index == 2) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo_dirgantara.png',
            height: 80,
            width: 80,
          ),
          SizedBox(height: 10),
          Text('Pt.Dirgantara'),
        ],
      );
    } else if (index == 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/Logo_PT_Pindad_(Persero).png',
            height: 80,
            width: 80,
          ),
          SizedBox(height: 10),
          Text('Pt.Pindad'),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/2560px-PT-PAL.svg.png',
            height: 80,
            width: 80,
          ),
          SizedBox(height: 10),
          Text('Pt.PAL'),
        ],
      );
    }
  }

  Future <bool> exit_app(BuildContext context) async{
    bool exit=await showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text("Keluar Aplikasi"),
            content: const Text("Yakin ingin keluar dari aplikasi"),
            actions: <Widget>[
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop(false);
                  },
                  child: const Text("Tidak"),
              ),
              TextButton(
                onPressed: (){
                  Navigator.of(context).pop(true);
                },
                child: const Text("Ya"),
              ),
            ],
          );
        },
    );
    return exit ?? false;
  }
}
