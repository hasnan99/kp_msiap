import 'package:flutter/material.dart';
import 'package:kp_msiap/statistik/char_dahana.dart';
import 'package:kp_msiap/statistik/chart_DI.dart';
import 'package:kp_msiap/statistik/chart_PAL.dart';
import 'package:kp_msiap/statistik/chart_len.dart';
import 'package:kp_msiap/statistik/chart_pindad.dart';

class view_statistik extends StatefulWidget {
  const view_statistik({Key? key}) : super(key: key);

  @override
  _view_statistik createState() => _view_statistik();
}

class _view_statistik extends State<view_statistik> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff4B5526),
          title: const Text('Statisktik'),
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
                        MaterialPageRoute(builder: (context)=> ChartPageLen()));
                  }
                  if(index == 1){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=> ChartPageDahana()));
                  }
                  if(index == 2){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=> ChartPageDI()));
                  }
                  if(index == 3){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>ChartPagePindad()));
                  }
                  if(index == 4){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>ChartPagePAL()));
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
}
