import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:store/models/user_model.dart';
import 'package:store/screens/signup_screen.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _fomrKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Sign in"),
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
              child: Text(
                "SIGN UP",
                style: TextStyle(fontSize: 15.0),
              ),
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignUpScreen()));
              },
            )
          ],
        ),
        body:
            ScopedModelDescendant<UserModel>(builder: (context, child, model) {
          if (model.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Form(
              key: _fomrKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      onPressed: () {
                        if (_emailController.text.isEmpty) {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text("Please enter an e-mail"),
                            backgroundColor: Colors.redAccent,
                            duration: Duration(seconds: 2),
                          ));
                        } else {
                          model.resetPassword(_emailController.text);
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text(
                                "An e-mail was sent to this address, please check your inbox"),
                            backgroundColor: Theme.of(context).primaryColor,
                            duration: Duration(seconds: 2),
                          ));
                        }
                      },
                      child: Text(
                        "Forgot password",
                        textAlign: TextAlign.right,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  SizedBox(
                    child: RaisedButton(
                      child: Text(
                        "Sign in",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        if (_fomrKey.currentState.validate()) {
                          model.signIn(
                              email: _emailController.text,
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
        }));
  }

  void _onSuccess() {
    Navigator.of(context).pop();
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Login unsuccessfull!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}
