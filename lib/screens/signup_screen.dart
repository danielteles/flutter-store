import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:store/models/user_model.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _fomrKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Sign up"),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<UserModel>(builder: (context, child, model) {
        if (model.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Form(
            key: _fomrKey,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(hintText: "Full name"),
                  validator: (text) {
                    String result;
                    if (text.isEmpty) {
                      result = "You must enter a name";
                    }
                    return result;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(hintText: "E-mail"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (text) {
                    bool emailValid;
                    String result;
                    if (text.isEmpty) {
                      result = "You must enter an e-mail";
                    } else {
                      emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(text);
                      if (!emailValid) {
                        result = "Invalid E-mail";
                      }
                    }
                    return result;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(hintText: "Password"),
                  obscureText: true,
                  validator: (text) {
                    String result;
                    if (text.isEmpty) {
                      result = "You must enter a password";
                    } else {
                      if (text.length < 6) {
                        result = "Password is too short";
                      }
                    }
                    return result;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(hintText: "Adress"),
                  validator: (text) {
                    String result;
                    if (text.isEmpty) {
                      result = "You must enter an address";
                    }
                    return result;
                  },
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  child: RaisedButton(
                    child: Text(
                      "Sign up",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (_fomrKey.currentState.validate()) {
                        Map<String, dynamic> userData = {
                          "name": _nameController.text,
                          "email": _emailController.text,
                          "address": _addressController.text,
                        };
                        model.signUp(
                            userData: userData,
                            password: _passwordController.text,
                            onSuccess: _onSuccess,
                            onFail: _onFail);
                      }
                    },
                  ),
                )
              ],
            ),
          );
        }
      }),
    );
  }

  void _onSuccess() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Successfully created user!"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 2),
    ));
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pop();
    });
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Error while creating user!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}
