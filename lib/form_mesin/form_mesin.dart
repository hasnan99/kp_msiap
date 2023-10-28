import 'package:flutter/material.dart';
import 'package:kp_msiap/form_mesin/form_cutting_cable.dart';
import 'package:kp_msiap/form_mesin/form_drilling.dart';
import 'package:kp_msiap/form_mesin/form_laser_marking.dart';
import 'package:kp_msiap/form_mesin/form_mesin_cutting.dart';
import 'package:kp_msiap/form_mesin/form_packing.dart';
import 'package:kp_msiap/form_mesin/form_shock_test.dart';
import 'package:kp_msiap/form_mesin/form_smt.dart';
import 'package:kp_msiap/form_mesin/form_welding.dart';

import 'form_drop_test.dart';
import 'form_ess.dart';
import 'form_solar_panel.dart';
import 'form_vibration_test.dart';

class form_mesin extends StatefulWidget {
  const form_mesin({Key? key}) : super(key: key);

  @override
  _form_mesin createState() => _form_mesin();
}

class _form_mesin extends State<form_mesin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff4B5526),
        title: const Text('Form Mesin'),
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
          itemCount: 12,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                if (index == 0) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=> form_cutting()));
                }
                if(index == 1){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=> form_drilling()));
                }
                if(index == 2){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=> form_Welding()));
                }
                if(index == 3){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=> form_laser_marking()));
                }
                if(index == 4){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=> form_smt()));
                }
                if(index == 5){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=> form_packing()));
                }
                if(index == 6){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=> form_cutting_cable()));
                }
                if(index == 7){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=> form_solar_panel()));
                }
                if(index == 8){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=> form_drop_test()));
                }
                if(index == 9){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=> form_vibration_test()));
                }
                if(index == 10){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=> form_ess()));
                }
                if(index == 11){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=> form_shock_test()));
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
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Cutting'),
        ],
      );
    } else if (index == 1) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Drilling'),
        ],
      );
    } else if (index == 2) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Welding'),
        ],
      );
    } else if (index == 3) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Laser Marking'),
        ],
      );
    } else if(index == 4) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('SMT'),
        ],
      );
    } else if(index == 5) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Packing'),
        ],
      );
    } else if(index == 6) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Cutting Cable'),
        ],
      );
    } else if(index == 7) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Solar Panel'),
        ],
      );
    } else if(index == 8) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Drop Test'),
        ],
      );
    } else if(index == 9) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Vibration Test'),
        ],
      );
    } else if(index == 10) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('ESS Chambers'),
        ],
      );
    } else{
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Shock Test'),
        ],
      );
    }
  }
}
