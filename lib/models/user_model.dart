import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

class UserModel extends Model {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;
  Map<String, dynamic> userData = Map();
  bool isLoading = false;

  @override
  void addListener(listener) {
    super.addListener(listener);

    _loadCurrentUser();
  }

  void signUp(
      {@required Map<String, dynamic> userData,
      @required String password,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) {
    isLoading = true;
    notifyListeners();

    _auth
        .createUserWithEmailAndPassword(
            email: userData["email"], password: password)
        .then((user) async {
      firebaseUser = user;

      await _saveUserData(userData);

      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((error) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signIn(
      {@required String email,
      @required String password,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    isLoading = true;

    await _loadCurrentUser();

    notifyListeners();

    _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) {
      firebaseUser = user;
      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((error) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signOut() async {
    await _auth.signOut();
    userData = Map();
    firebaseUser = null;
    notifyListeners();
  }

  void resetPassword(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  bool isAuthenticated() {
    return firebaseUser != null;
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .setData(userData);
  }

  Future<Null> _loadCurrentUser() async {
    if (firebaseUser == null) {
      firebaseUser = await _auth.currentUser();
    }

    if (firebaseUser != null) {
      DocumentSnapshot docUser = await Firestore.instance
          .collection("users")
          .document(firebaseUser.uid)
          .get();
      userData = docUser.data;
    }

    notifyListeners();
  }
}
