import 'package:equatable/equatable.dart';
import 'package:saving_trackings_flutter/feature/authentication/domain/entities/user_entity.dart';

abstract class AuthenticationState extends Equatable{
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

class AuthenticationInitial extends AuthenticationState{}

class AuthenticationLoading extends AuthenticationState {}

class Authenticated extends AuthenticationState{
  final UserEntity userEntity;
  const Authenticated(this.userEntity);
}

class AuthenticationError extends AuthenticationState {
  final String message;
  const AuthenticationError(this.message);
}