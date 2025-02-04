import 'package:firebase_auth/firebase_auth.dart';
import 'package:saving_trackings_flutter/feature/authentication/domain/entities/user_entity.dart';

class UserModel extends UserEntity{
  UserModel({required super.uid, required super.email});

  factory UserModel.fromFirebaseUser(User user){
    return UserModel(
        uid: user.uid,
        email: user.email ?? '',
    );
  }

  UserEntity toEntity(){
    return UserEntity(uid: uid, email: email);
  }
}