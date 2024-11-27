import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier{
  User? _user;

  User? get user => _user;

  void initializeUser(){
    FirebaseAuth.instance.authStateChanges().listen((User? user){
      _user = user;
      notifyListeners();
    });
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    _user = null; // Limpiar la información del usuario
    notifyListeners();
  }
}