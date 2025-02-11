import 'package:saving_trackings_flutter/feature/authentication/data/data_source/firebase_auth_data_source.dart';
import 'package:saving_trackings_flutter/feature/authentication/domain/entities/user_entity.dart';
import 'package:saving_trackings_flutter/feature/authentication/domain/repository/authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository{
  final FirebaseAuthDataSource firebaseAuthDataSource;
  AuthenticationRepositoryImpl(this.firebaseAuthDataSource);

  @override
  Future<UserEntity> signInWithEmailPassword(String email, String password){
    return firebaseAuthDataSource.signInWithEmailPassword(email, password);
  }

  @override
  Future<UserEntity> signUpWithEmailPassword(String email, String password){
    return firebaseAuthDataSource.signUpWithEmailPassword(email, password);
  }

  @override
  Future<UserEntity> signInWithGoogle(){
    return firebaseAuthDataSource.signInWithGoogle();
  }
  @override
  Future<UserEntity> signInWithFacebook(){
    return firebaseAuthDataSource.signInWithFacebook();
  }
}