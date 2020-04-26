import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store/tiles/store_tile.dart';

class StoresTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection("stores").getDocuments(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        else
          return ListView(
            children:
                snapshot.data.documents.map((doc) => StoresTile(doc)).toList(),
          );
      },
    );
  }
}
