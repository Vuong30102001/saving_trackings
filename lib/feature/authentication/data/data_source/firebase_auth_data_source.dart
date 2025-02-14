import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:saving_trackings_flutter/feature/authentication/data/models/user_model.dart';
import 'package:saving_trackings_flutter/feature/authentication/domain/entities/user_entity.dart';

abstract class FirebaseAuthDataSource{
  Future<UserEntity> signInWithEmailPassword(String email, String password);
  Future<UserEntity> signUpWithEmailPassword(String email, String password);
  Future<UserEntity> signInWithGoogle();
  Future<UserEntity> signInWithFacebook();
}

class FirebaseAuthDataSourceImpl implements FirebaseAuthDataSource{
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthDataSourceImpl(this._firebaseAuth);

  @override
  Future<UserEntity> signInWithEmailPassword(String email, String password) async {
    try{
      // Kiểm tra sinh trắc học trước khi đăng nhập
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

  @override
  Future<UserEntity> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    try {
      await googleSignIn.signOut(); //log out to choice ne account

      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount == null) {
        throw Exception('Google Sign-In canceled');
      }

      final GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user == null) {
        throw Exception('Google Sign-In failed');
      }

      return UserModel.fromFirebaseUser(user); // Trả về UserEntity
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Google Sign-In error');
    }
  }

  @override
  Future<UserEntity> signInWithFacebook() async {
    try{
      await FacebookAuth.instance.logOut();
      // Hiển thị hộp thoại đăng nhập Facebook
      final LoginResult result = await FacebookAuth.instance.login();
      if(result.status == LoginStatus.success){
        // Lấy token từ Facebook
        final AccessToken accessToken = result.accessToken!;

        // Tạo credential từ token Facebook
        final OAuthCredential credential = FacebookAuthProvider.credential(accessToken.tokenString);

        //Đăng nhập vào Firebase bằng credential Facebook
        final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);

        // Lấy thông tin user
        final User? user = userCredential.user;
        if(user == null){
          throw Exception('Facebook Sign-In failed');
        }

        return UserModel.fromFirebaseUser(user);
      }
      else {
        throw Exception('Facebook Sign-In canceled');
      }
    }
    on FirebaseAuthException catch(e){
      throw Exception(e.message ?? 'Facebook Sign-In error');
    }
  }
}