import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:store/models/cart_model.dart';
import 'package:store/models/user_model.dart';
import 'package:store/screens/order_screen.dart';
import 'package:store/screens/signin_screen.dart';
import 'package:store/tiles/cart_tile.dart';
import 'package:store/widgets/cart_price.dart';
import 'package:store/widgets/discount_card.dart';
import 'package:store/widgets/ship_card.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My cart"),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 8.0),
            alignment: Alignment.center,
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model) {
                int p = model.items.length;
                return Text(
                  "${p ?? 0} ${p == 1 ? "ITEM" : "ITEMS"}",
                  style: TextStyle(fontSize: 17.0),
                );
              },
            ),
          )
        ],
      ),
      body: ScopedModelDescendant<CartModel>(
        builder: (context, child, model) {
          if (model.isLoading && UserModel.of(context).isAuthenticated()) {
            return Center(child: CircularProgressIndicator());
          } else if (!UserModel.of(context).isAuthenticated()) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.remove_shopping_cart,
                    size: 80.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    "Sign in to add!",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  RaisedButton(
                    child: Text(
                      "Sign in",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SignInScreen()));
                    },
                  )
                ],
              ),
            );
          } else if (model.items == null || model.items.length == 0) {
            return Center(
              child: Text(
                "Cart empty!",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView(
              children: <Widget>[
                Column(
                  children: model.items.map((product) {
                    return CartTile(product);
                  }).toList(),
                ),
                DiscountCard(),
                ShipCard(),
                CartPrice(() async {
                  String orderId = await model.finishOrder();
                  if (orderId != null) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => OrderScreen(orderId)),
                    );
                  }
                }),
              ],
            );
          }
        },
      ),
    );
  }
}
