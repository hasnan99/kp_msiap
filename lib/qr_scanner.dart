import 'dart:convert';
import 'dart:developer';
import 'package:collection/collection.dart';
import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:kp_msiap/detail_aset.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'model/sheet.dart';
import 'package:kp_msiap/api/sheet_api.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanQR();
}

class _ScanQR extends State<ScanQR> {

  List<sheet> data = [];
  List<sheet> dataList = [];
  late var jsondata;
  bool isLoading = false;
  bool isNavigating = false;

  @override
  void initState() {
    super.initState();
    _fetchdatalen();
  }

  Future<void> _fetchdatalen() async {
    final response = await http.get(Uri.parse(sheet_api.URL_len));
    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      setState(() {
        data = json.map((item) => sheet.fromJson(item)).toList();
        dataList = List.from(data);
      });
    } else {
      throw Exception("Failed to load Data");
    }
  }

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

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
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
    return WillPopScope(
      onWillPop: () => exit_app(context),
      child:Scaffold(
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
                        if (isLoading)
                          Expanded(
                            child: Container(
                              color: Colors.black54,
                              child: const Center(
                                child: SpinKitChasingDots( // Replace with any loading indicator from the flutter_spinkit package
                                  color: Colors.white,
                                  size: 50.0,),
                              ),
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
      if (!isNavigating) { // Only process if not currently navigating
        setState(() {
          result = scanData;
          if (result != null) {
            String? hasil = result?.code;
            isLoading = true;
            sheet? foundAsset = dataList.firstWhereOrNull(
                  (asset) => asset.Id.toString() == hasil,
            );
            if (foundAsset != null) {
              setState(() {
                isNavigating = true;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailAset(data: foundAsset),
                ),
              ).then((_) {
                setState(() {
                  isNavigating = false;
                });
                controller.resumeCamera();
              });
            } else {
              setState(() {
                isLoading = false; // Set loading to false if the asset is not found
              });
            }
          }
        });
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
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
    return exit;
  }
}