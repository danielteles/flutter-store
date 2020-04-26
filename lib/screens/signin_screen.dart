import 'package:flutter/material.dart';
import 'package:store/screens/signup_screen.dart';

class SignInScreen extends StatelessWidget {
  final _fomrKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Form(
        key: _fomrKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
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
                onPressed: () {},
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
                    print("ok");
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
