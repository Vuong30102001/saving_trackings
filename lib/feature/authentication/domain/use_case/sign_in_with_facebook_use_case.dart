import 'package:saving_trackings_flutter/feature/authentication/domain/entities/user_entity.dart';
import 'package:saving_trackings_flutter/feature/authentication/domain/repository/authentication_repository.dart';

class SignInWithFacebookUseCase{
  final AuthenticationRepository authenticationRepository;
  SignInWithFacebookUseCase(this.authenticationRepository);

  Future<UserEntity> signIn() async {
    return await authenticationRepository.signInWithFacebook();
  }
}