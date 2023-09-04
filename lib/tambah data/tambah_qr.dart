import 'dart:developer';
import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kp_msiap/model/sheet_add.dart';
import 'package:kp_msiap/tambah%20data/add_data_qr.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class addScanQR extends StatefulWidget {
  const addScanQR({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _addScanQR();
}

class _addScanQR extends State<addScanQR> {

  List<sheet_add> data = [];
  late var jsondata;
  bool isLoading = false;
  bool isNavigating = false;

  showSnackbarwarning(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AwesomeSnackbarContent(
          title: '.....',
          message: message,
          contentType: ContentType.warning,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(flex: 5, child: _buildQrView(context)),
            Expanded(
              flex: 1,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        Container(
                          margin: const EdgeInsets.all(8),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all(Color(0xff4B5526)),
                              ),
                              onPressed: () async {
                                await controller?.toggleFlash();
                                setState(() {});
                              },
                              child: FutureBuilder(
                                future: controller?.getFlashStatus(),
                                builder: (context, snapshot) {
                                  return Text('Flash: ${snapshot.data}');
                                },
                              )),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all(Color(0xff4B5526)),
                              ),
                              onPressed: () async {
                                await controller?.flipCamera();
                                setState(() {});
                              },
                              child: FutureBuilder(
                                future: controller?.getCameraInfo(),
                                builder: (context, snapshot) {
                                  if (snapshot.data != null) {
                                    return Text(
                                        'Kamera  ${describeEnum(snapshot.data!)}');
                                  } else {
                                    return const Text('loading');
                                  }
                                },
                              )),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Color(0xff4B5526)),
                            ),
                            onPressed: () async {
                              await controller?.pauseCamera();
                            },
                            child: const Text('pause',
                                style: TextStyle(fontSize: 20)),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Color(0xff4B5526)),
                            ),
                            onPressed: () async {
                              await controller?.resumeCamera();
                            },
                            child: const Text('resume',
                                style: TextStyle(fontSize: 20)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Color(0xff4B5526),
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (!isNavigating) {
        setState(() {
          result = scanData;
          if (result != null) {
            String? hasil = result?.code;
            List<String> qrCodeData = hasil?.split(',') ?? [];
            print("QR Code Data: $qrCodeData");
              String nama_aset = qrCodeData[0];
              String jenis_aset = qrCodeData[1];
              String kondisi = qrCodeData[2];
              String status_pemakaian = qrCodeData[3];
              int utilisasi = int.parse(qrCodeData[4]);
              int tahun_perolehan = int.parse(qrCodeData[5]);
              int umur_teknis = int.parse(qrCodeData[6]);
              String sumber_dana = qrCodeData[7];
              int nilai_perolehan = int.parse(qrCodeData[8]);
              int nilai_buku = int.parse(qrCodeData[9]);
              String rencana_optimisasi = qrCodeData[10];
              String lokasi = qrCodeData[11];
              var qr_values=sheet_add(nama_aset, jenis_aset, kondisi, status_pemakaian, utilisasi, tahun_perolehan, umur_teknis, sumber_dana, nilai_perolehan, nilai_buku, rencana_optimisasi, lokasi,'');
              print("QR Values: $qr_values");
              data.add(qr_values);

            if (data != null) {
              setState(() {
                isNavigating = true;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddData_qr(data: data),
                ),
              ).then((_) {
                setState(() {
                  isNavigating = false;
                });
                controller?.resumeCamera();
              });
            } else {
              setState(() {
                isLoading = false; // Set loading to false if the asset is not found
              }
              );
            }
          }
        });
      }}
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }
}