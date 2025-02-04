import 'package:firebase_auth/firebase_auth.dart';
import 'package:saving_trackings_flutter/feature/authentication/data/models/user_model.dart';
import 'package:saving_trackings_flutter/feature/authentication/domain/entities/user_entity.dart';

abstract class FirebaseAuthDataSource{
  Future<UserEntity> signInWithEmailPassword(String email, String password);
  Future<UserEntity> signUpWithEmailPassword(String email, String password);
}

class FirebaseAuthDataSourceImpl implements FirebaseAuthDataSource{
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthDataSourceImpl(this._firebaseAuth);

  @override
  Future<UserEntity> signInWithEmailPassword(String email, String password) async {
    try{
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return UserModel.fromFirebaseUser(userCredential.user!);
    }
    catch(e){
      throw Exception('Login failure');
    }
  }

  @override
  Future<UserEntity> signUpWithEmailPassword(String email, String password) async {
    try{
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      return UserModel.fromFirebaseUser(userCredential.user!);
    }
    catch(e){
      throw Exception('Sign up failure');
    }
  }
}