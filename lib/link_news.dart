import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:intl/intl.dart';

class link_News extends StatefulWidget {
  final List data;
  const link_News({Key? key, required this.data}) : super(key: key);

  @override
  _link_News createState() => _link_News();
}

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

String formatDate(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  String formattedDateTime = DateFormat('dd-MM-yyyy').format(dateTime);
  return formattedDateTime;
}

class _link_News extends State<link_News> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff4B5526),
        title: const Text("Link News"),
      ),
      body: ListView.builder(
        itemCount: widget.data.length,
        itemBuilder: (context, index) {
          final item = widget.data[index];
          final googleDriveLink = item['Link File'];
          final fileId = extractFileId(googleDriveLink);
          final directDownloadUrl = convertToDirectDownloadUrl(fileId);
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetailPage(
                    pdfUrl: directDownloadUrl
                  ),
                ),
              );
            },
            child: Card(
              child: ListTile(
                title: Text(item['Nama news'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                subtitle: Text("Terdapat News baru pada ${formatDate(item['Time stamp'])}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class NewsDetailPage extends StatelessWidget {
  final String pdfUrl;

  NewsDetailPage({required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
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
