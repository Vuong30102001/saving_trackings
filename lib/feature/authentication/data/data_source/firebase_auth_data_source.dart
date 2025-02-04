import 'package:firebase_auth/firebase_auth.dart';

abstract class FirebaseAuthDataSource{
  Future<User> signInWithEmailPassword(String email, String password);
  Future<User> signUpWithEmailPassword(String email, String password);
}

class FirebaseAuthDataSourceImpl implements FirebaseAuthDataSource{
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthDataSourceImpl(this._firebaseAuth);

  @override
  Future<User> signInWithEmailPassword(String email, String password) async {
    try{
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return userCredential.user!;
    }
    catch(e){
      throw Exception('Login failure');
    }
  }

  @override
  Future<User> signUpWithEmailPassword(String email, String password) async {
    try{
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      return userCredential.user!;
    }
    catch(e){
      throw Exception('Sign up failure');
    }
  }
}