import 'dart:convert';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kp_msiap/api/sheet_api.dart';
import 'package:kp_msiap/edit%20data/edit_asset_len.dart';
import 'package:kp_msiap/model/sheet.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

class AssetItem extends StatefulWidget {
  final GlobalKey<_AssetItemState> assetItemKey = GlobalKey<_AssetItemState>();
  final ValueChanged<String> onTextFieldValue;
  AssetItem({Key? key, required this.onTextFieldValue, }) : super(key: key);

  @override
  _AssetItemState createState() => _AssetItemState();

  static void refreshData(BuildContext context) {
    final state = _AssetItemState.of(context);
    state.refreshData();
  }

  static String getquerydata(BuildContext context) {
    final state = _AssetItemState.of(context);
    return state.controller_cari.text;
  }
}

class _AssetItemState extends State<AssetItem> {
  List<sheet> data = [];
  List<sheet> cari_data = [];
  TextEditingController controller_cari = TextEditingController();
  late Future<List<sheet>> dataFuture;
  int current_page=1;
  int items_page=10;
  int currentPageOnRefresh = 1;

  static _AssetItemState of(BuildContext context) =>
      context.findAncestorStateOfType<_AssetItemState>()!;

  @override
  void initState() {
    super.initState();
      dataFuture = _fetchdatalen();
  }

  void refreshData() {
    setState(() {
      dataFuture = _fetchdatalen();
      currentPageOnRefresh = current_page;
    });
  }

  void _handleTextFieldChanged(String newValue) {
    widget.onTextFieldValue(newValue);
  }

  Future<List<sheet>> _fetchdatalen() async {
    try {
      setState(() {
        currentPageOnRefresh = current_page;
      });
      List<sheet> newData = await sheet_api.getAssetLen();
      setState(() {
        data = newData;
        cariData(controller_cari.text);
      });
      return newData;
    } catch (e) {
      print(e.toString());
      print(dataFuture.toString());
    }
    return data;
  }

  void cariData(String query) {
    setState(() {
      _handleTextFieldChanged(query);
      if (query.isEmpty) {
        cari_data = List.from(data);
      } else {
        cari_data = data
            .where((asset) =>
            asset.nama_asset.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      if(query.isNotEmpty){
        current_page=1;
      }else{
        current_page=currentPageOnRefresh;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<sheet> currentPageData = cari_data
        .skip((current_page - 1) * items_page)
        .take(items_page)
        .toList();

    return WillPopScope(
      onWillPop: () => exit_app(context),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: controller_cari,
                decoration: InputDecoration(
                  hintText: "Cari Aset",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: cariData,
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    if (current_page > 1) {
                      setState(() {
                        current_page--;
                        currentPageOnRefresh--;
                      });
                    }
                    },
                ),
                DropdownButton<int>(
                  items: List.generate((cari_data.length / items_page).ceil(), (index) => DropdownMenuItem(value: index + 1, child: Text('Page ${index + 1}'))),
                  onChanged: (value) {
                    setState(() {
                      current_page = value!;
                      currentPageOnRefresh = value!;
                    });
                    },
                  value: current_page,
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    if (current_page < (cari_data.length / items_page).ceil()) {
                      setState(() {
                        current_page++;
                        currentPageOnRefresh++;
                      });
                    }
                    },
                ),
              ],
            ),
            FutureBuilder<List<sheet>>(
              future: dataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return GridView.builder(
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.68,
                    ),
                    cacheExtent: 1500,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 15),
                    itemCount: currentPageData.length,
                    itemBuilder: (context, index) {
                      var array_gambar = jsonDecode(currentPageData[index].gambar ?? '[]');
                      List? url_gambar = array_gambar != null ? List.from(array_gambar) : null;
                      int jumlah_data=(current_page - 1) * items_page + index + 1;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AssetDetailPage(
                                data: currentPageData[index],
                                refreshCallback: _fetchdatalen,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xffeef1f4),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 10),
                                alignment: Alignment.center,
                                child: currentPageData[index].gambar != null
                                    ? CachedNetworkImage(
                                  imageUrl: url_gambar?.last,
                                  cacheManager: DefaultCacheManager(),
                                  memCacheHeight: 100,
                                  memCacheWidth: 100,
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                )
                                    : Text("Gambar belum ditambahkan."),
                              ),

                              Container(
                                padding: const EdgeInsets.only(left: 10),
                                alignment: Alignment.topLeft,
                                child:
                                Text("No : ${jumlah_data}"),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 10),
                                alignment: Alignment.topLeft,
                                child:
                                Text("ID : ${currentPageData[index].id}"),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 10),
                                alignment: Alignment.center,
                                child: Text(
                                    "Nama Aset : ${(currentPageData[index].nama_asset)}"),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Text('No data');
                }
              },
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    if (current_page > 1) {
                      setState(() {
                        current_page--;
                        currentPageOnRefresh--;
                      });
                    }
                  },
                ),
                DropdownButton<int>(
                  items: List.generate((cari_data.length / items_page).ceil(), (index) => DropdownMenuItem(value: index + 1, child: Text('Page ${index + 1}'))),
                  onChanged: (value) {
                    setState(() {
                      current_page = value!;
                      currentPageOnRefresh = value!;
                    });
                  },
                  value: current_page,
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    if (current_page < (cari_data.length / items_page).ceil()) {
                      setState(() {
                        current_page++;
                        currentPageOnRefresh++;
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
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

class AssetDetailPage extends StatefulWidget {
  final sheet data;
  final VoidCallback refreshCallback;
  const AssetDetailPage({Key? key, required this.data, required this.refreshCallback}) : super(key: key);

  @override
  _AssetDetailPageState createState() => _AssetDetailPageState();
}

class _AssetDetailPageState extends State<AssetDetailPage> {
  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    final formatterdolar = NumberFormat.currency(
      locale: 'en_US', // Sesuaikan dengan locale yang sesuai dengan format dolar.
      symbol: '\$', // Simbol mata uang dolar.
    );
    final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();
    Future<void> _refreshData() async {
      widget.refreshCallback();
    }

    var array_gambar=jsonDecode(widget.data.gambar?? '[]');
    List? url_gambar = array_gambar != null ? List.from(array_gambar) : null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff4B5526),
        title: const Text("Detail Asset"),
      ),
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 250,
                alignment: Alignment.center,
                child: widget.data.gambar != null && widget.data.gambar!.isNotEmpty
                    ? FancyShimmerImage(
                    imageUrl: url_gambar?.last, height: 250)
                    : Text("Gambar Belum ada"),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailItem("Nama Aset", widget.data.nama_asset),
                    _buildDetailItem("Jenis Aset", widget.data.jenis_asset??""),
                    _buildDetailItem("Kondisi", widget.data.kondisi??""),
                    _buildDetailItem("Status Pemakaian", widget.data.status_pemakaian??""),
                    _buildDetailItem("Utilisasi", widget.data.utilisasi.toString()),
                    _buildDetailItem("Tahun Perolehan", widget.data.tahun_perolehan.toString()),
                    _buildDetailItem("Umur Teknis", widget.data.umur_teknis.toString()),
                    _buildDetailItem("Sumber Dana", widget.data.sumber_dana??""),
                    _buildDetailItem("Nilai Perolehan", formatter.format(double.parse(widget.data.nilai_perolehan.toString()))),
                    _buildDetailItem("Nilai Perolehan Dollar", widget.data.nilai_perolehan_dollar.toString()),
                    _buildDetailItem("Nilai Buku", formatter.format(double.parse(widget.data.nilai_buku.toString()))),
                    _buildDetailItem("Rencana Optimisasi", widget.data.rencana_optimisasi??""),
                    _buildDetailItem("Lokasi", widget.data.lokasi??""),
                    _buildDetailItem("Merk", widget.data.merk??""),
                    _buildDetailItem("Tipe Mesin", widget.data.tipe_mesin??""),
                    _buildDetailItem("Fungsi Mesin", widget.data.kategori_fungsi_mesin??""),
                    _buildDetailItem("Raw Material", widget.data.raw_material??""),
                    _buildDetailItem("Data Sheet", widget.data.data_sheet??""),
                    _buildDetailItem("Kartu Mesin", widget.data.kartu_mesin??""),
                    _buildDetailItem("Kartu Elektronik", widget.data.kartu_elektronik??""),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => EditAsset(data: widget.data))).
          whenComplete(() => _refreshData());
        },
        icon: const Icon(Icons.edit),
        label: const Text("Edit Data"),
        backgroundColor: const Color(0xff4B5526),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return InkWell(
      onTap: () async {
        if (label == "Data Sheet" && value.isNotEmpty) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PDFScreen(pdfUrl: value),
            ),
          );
        } else if (label == "Kartu Mesin" && value.isNotEmpty) {
          await showDialog(
            context: context,
            builder: (context) => imageDialog(label, value, context),
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 15,
            ),
          ),
          Text(
            value,
            style: label == "Data Sheet" || label == "Kartu Mesin"
                ? const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.blue,
              decoration: TextDecoration.underline,
            )
                : const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}

Widget imageDialog(text, path, context) {
  return Dialog(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$text',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.close_rounded),
                color: Colors.redAccent,
              ),
            ],
          ),
        ),
        Container(
          width: 400,
          height: 550,
          child: Image.network(
            '$path',
            fit: BoxFit.cover,
          ),
        ),
      ],
    ),
  );
}

class PDFScreen extends StatelessWidget {
  final String pdfUrl;

  PDFScreen({required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Sheet'),
        backgroundColor: const Color(0xff4B5526),
      ),
      body:  PDF().cachedFromUrl(
        pdfUrl,
        placeholder: (progress) => Center(child: Text('$progress %')),
        errorWidget: (error) => Center(child: Text(error.toString())),
      ),

    );
  }
}

