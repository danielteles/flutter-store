import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:store/data/cart_item.dart';
import 'package:store/data/product_data.dart';
import 'package:store/models/cart_model.dart';
import 'package:store/models/user_model.dart';
import 'package:store/screens/cart_screen.dart';
import 'package:store/screens/signin_screen.dart';

class ItemScreen extends StatefulWidget {
  final ProductData product;

  ItemScreen(this.product);

  @override
  _ItemScreenState createState() => _ItemScreenState(product);
}

class _ItemScreenState extends State<ItemScreen> {
  final ProductData product;
  String lang;

  _ItemScreenState(this.product);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
        actions: <Widget>[],
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1,
            child: Carousel(
              images: product.images.map((url) {
                return NetworkImage(url);
              }).toList(),
              dotSize: 4.0,
              dotSpacing: 15.0,
              dotColor: primaryColor,
              dotBgColor: Colors.transparent,
              autoplay: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  product.title,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                  maxLines: 3,
                ),
                Text(
                  "R\$ ${product.price.toStringAsFixed(2)}",
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  "Vesion",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 34.0,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 0.5),
                    children: product.versions.map((version) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            lang = version;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4.0)),
                              border: Border.all(
                                  color: lang == version
                                      ? primaryColor
                                      : Colors.grey[500])),
                          width: 50.0,
                          alignment: Alignment.center,
                          child: Text(version),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                SizedBox(
                  height: 44.0,
                  child: RaisedButton(
                    onPressed: lang != null
                        ? () {
                            if (UserModel.of(context).isAuthenticated()) {
                              CartItem item = CartItem();
                              item.version = lang;
                              item.amount = 1;
                              item.idItem = product.id;
                              item.category = product.category;

                              CartModel.of(context).addCartItem(item);

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CartScreen()));
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SignInScreen()));
                            }
                          }
                        : null,
                    child: Text(
                      UserModel.of(context).isAuthenticated()
                          ? "Add to cart"
                          : "Login to buy",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    color: primaryColor,
                    textColor: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  "Description",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                Text(
                  product.description,
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
