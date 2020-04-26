import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:store/data/cart_item.dart';
import 'package:store/models/user_model.dart';

class CartModel extends Model {
  UserModel user;
  List<CartItem> items = [];
  bool isLoading = false;
  String couponCode;
  int discountPercentage = 0;

  CartModel(this.user) {
    if (user.isAuthenticated()) {
      _loadCartItems();
    }
  }

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartItem item) {
    items.add(item);

    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .add(item.toMap())
        .then((doc) {
      item.idCart = doc.documentID;
    });

    notifyListeners();
  }

  void removeCartItem(CartItem item) {
    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(item.idCart)
        .delete();

    items.remove(item);
    notifyListeners();
  }

  void decProduct(CartItem item) {
    item.amount--;

    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(item.idCart)
        .updateData(item.toMap());

    notifyListeners();
  }

  void incProduct(CartItem item) {
    item.amount++;

    Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .document(item.idCart)
        .updateData(item.toMap());

    notifyListeners();
  }

  void _loadCartItems() async {
    QuerySnapshot query = await Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .getDocuments();

    items = query.documents.map((doc) => CartItem.fromDocument(doc)).toList();

    notifyListeners();
  }

  void setCoupon(String couponCode, int discountPercentage) {
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  void updatePrices() {
    notifyListeners();
  }

  double getProductsPrice() {
    double price = 0.0;
    for (CartItem item in items) {
      if (item.productData != null)
        price += item.amount * item.productData.price;
    }
    return price;
  }

  double getDiscount() {
    return getProductsPrice() * discountPercentage / 100;
  }

  double getShipPrice() {
    return 9.99;
  }

  Future<String> finishOrder() async {
    if (items.length == 0) {
      return null;
    }

    isLoading = true;
    notifyListeners();

    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    DocumentReference refOrder =
        await Firestore.instance.collection("orders").add({
      "clientId": user.firebaseUser.uid,
      "products": items.map((item) => item.toMap()).toList(),
      "shipPrice": shipPrice,
      "productsPrice": productsPrice,
      "discount": discount,
      "totalPrice": productsPrice - discount + shipPrice,
      "status": 1
    });

    await Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("orders")
        .document(refOrder.documentID)
        .setData({"orderId": refOrder.documentID});

    QuerySnapshot query = await Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart")
        .getDocuments();

    for (DocumentSnapshot doc in query.documents) {
      doc.reference.delete();
    }

    items.clear();

    couponCode = null;
    discountPercentage = 0;

    isLoading = false;
    notifyListeners();

    return refOrder.documentID;
  }
}
