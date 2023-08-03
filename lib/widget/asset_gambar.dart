import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AssetGambar extends StatelessWidget {
  final int imageIndex; // Add this variable to store the image index
  AssetGambar({Key? key, required this.imageIndex}) : super(key: key);

  final CollectionReference _reference =
  FirebaseFirestore.instance.collection('gambar');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _reference.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data found'));
          }

          if (imageIndex >= snapshot.data!.docs.length) {
            return const Text('Invalid index');
          }

          DocumentSnapshot documentSnapshot = snapshot.data!.docs[imageIndex];
          Map<String, dynamic>? data =
          documentSnapshot.data() as Map<String, dynamic>?;

          if (data == null || !data.containsKey('image')) {
            return const Text('Image URL not found');
          }

          return Image.network(
            '${data['image']}',
            height: 550,
            alignment: Alignment.center,// Adjust to the desired height
          );
        },
      ),
    );
  }
}
