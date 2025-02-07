import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:paganini/domain/entity/user_entity.dart';

class UserProvider with ChangeNotifier {

  UserEntity? _currentUser;
  UserEntity? get currentUser => _currentUser;

  bool _isImportedContacts = false;

  bool get isImportedContacts => _isImportedContacts;



 void initializeUser() {
  FirebaseAuth.instance.authStateChanges().listen((User? firebaseUser) async {
    if (firebaseUser != null) {
      final userRef = FirebaseDatabase.instance.ref('users/${firebaseUser.uid}');
      final snapshot = await userRef.get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        _currentUser = UserEntity.fromMapEntity(
          firebaseUser.uid,
          data.map((key, value) => MapEntry(key.toString(), value)),
        );
      } else {
        _currentUser = null;
      }
    } else {
      _currentUser = null;
    }
    notifyListeners();
  });
}

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    setUserCurrent();
  }
  
 void setUserCurrent(){
  _currentUser = null;
  notifyListeners();
 } 

 void setUserImportedContacts(){
   _isImportedContacts = true;
   notifyListeners();
 }

 void setUserData(){
  initializeUser();
  notifyListeners();
 }

}
