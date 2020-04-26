import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store/data/product_data.dart';

class CartItem {
  String idCart;
  String category;
  String idItem;
  int amount;
  String version;

  ProductData productData;

  CartItem();

  CartItem.fromDocument(DocumentSnapshot document) {
    idCart = document.documentID;
    category = document.data["category"];
    idItem = document.data["idItem"];
    amount = document.data["amount"];
    version = document.data["version"];
  }
  Map<String, dynamic> toMap() {
    return {
      "category": category,
      "idItem": idItem,
      "amount": amount,
      "version": version,
      "product": productData.toResumedMap()
    };
  }
}
