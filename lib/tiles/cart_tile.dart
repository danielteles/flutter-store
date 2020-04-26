import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store/data/cart_item.dart';
import 'package:store/data/product_data.dart';
import 'package:store/models/cart_model.dart';

class CartTile extends StatelessWidget {
  final CartItem item;

  CartTile(this.item);
  @override
  Widget build(BuildContext context) {
    Widget _buildContent() {
      CartModel.of(context).updatePrices();

      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            width: 120.0,
            child: Image.network(
              item.productData.images[0],
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    item.productData.title,
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 17.0),
                  ),
                  Text(
                    "Tamanho: ${item.version}",
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Text(
                    "R\$ ${item.productData.price.toStringAsFixed(2)}",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.remove),
                        color: Theme.of(context).primaryColor,
                        onPressed: item.amount > 1
                            ? () {
                                CartModel.of(context).decProduct(item);
                              }
                            : null,
                      ),
                      Text(item.amount.toString()),
                      IconButton(
                        icon: Icon(Icons.add),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          CartModel.of(context).incProduct(item);
                        },
                      ),
                      FlatButton(
                        child: Text("Remover"),
                        textColor: Colors.grey[500],
                        onPressed: () {
                          CartModel.of(context).removeCartItem(item);
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: item.productData == null
          ? FutureBuilder<DocumentSnapshot>(
              future: Firestore.instance
                  .collection("products")
                  .document(item.category)
                  .collection("items")
                  .document(item.idItem)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  item.productData = ProductData.fromDocument(snapshot.data);
                  return _buildContent();
                } else {
                  return Container(
                    height: 70.0,
                    child: CircularProgressIndicator(),
                    alignment: Alignment.center,
                  );
                }
              },
            )
          : _buildContent(),
    );
  }
}
