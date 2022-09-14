import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserCredential? firebaseUser;

  Map<String, dynamic> userData = {};

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    _loadCurrentUser();
  }

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  void singUp({
    required Map<String, dynamic> userData,
    required String password,
    required VoidCallback onSuccess,
    required VoidCallback onFail,
  }) async {
    setLoading(isLoadingParam: true);

    _auth
        .createUserWithEmailAndPassword(
      email: userData['email'],
      password: password,
    )
        .then((user) async {
      firebaseUser = user;
      await _saveUserData(userData);

      onSuccess();
      setLoading(isLoadingParam: false);
    }).catchError((error) {
      onFail();
      setLoading(isLoadingParam: false);
    });
  }

  void singIn({
    required String email,
    required String password,
    required VoidCallback onSuccess,
    required VoidCallback onFail,
  }) async {
    isLoading = true;
    notifyListeners();

    _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) async {
      firebaseUser = user;

      await _loadCurrentUser();

      onSuccess();
      isLoading = false;

      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;

      notifyListeners();
    });
  }

  void recoverPassword(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  void signOut() async {
    await _auth.signOut();
    firebaseUser = null;

    notifyListeners();
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  void setLoading({required bool isLoadingParam}) {
    isLoading = isLoadingParam;
    notifyListeners();
  }

  Future _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser!.user!.uid)
        .set(userData);
  }

  Future _loadCurrentUser() async {
    // if (_auth.currentUser != null) {
    //   _auth.currentUser!.uid;
    // }

    // firebaseUser ??= _auth.currentUser!;

    if (firebaseUser != null) {
      if (userData["name"] == null) {
        DocumentSnapshot docUser = await FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseUser!.user!.uid)
            .get();

        userData = (docUser.data() as Map<String, dynamic>);
      }
    }

    notifyListeners();
  }
}
