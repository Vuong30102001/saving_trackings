import 'package:saving_trackings_flutter/feature/authentication/domain/entities/user_entity.dart';

abstract class AuthenticationRepository {
  Future<UserEntity> signInWithEmailPassword(String email, String password);
  Future<UserEntity> signUpWithEmailPassword(String email, String password);
  Future<UserEntity> signInWithGoogle();
  Future<UserEntity> signInWithFacebook();
}