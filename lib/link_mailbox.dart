import 'package:flutter/material.dart';

class link_Mailbox extends StatefulWidget {
  final List data;
  const link_Mailbox({Key? key, required this.data}) : super(key: key);

  @override
  _link_Mailbox createState() => _link_Mailbox();
}

class _link_Mailbox extends State<link_Mailbox> {
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
          // Gantilah cari_data[index] dengan data[index] sesuai kebutuhan Anda.
          final item = widget.data[index];
          return GestureDetector(
            onTap: () {},
            child: Card(
              child: ListTile(
                title: Text("Dokumen Masuk",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                subtitle: Text("Terdapat Dokumen baru ${item['Dokumen']}",
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
