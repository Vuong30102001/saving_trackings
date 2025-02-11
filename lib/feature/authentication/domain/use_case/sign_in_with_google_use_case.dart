import 'package:saving_trackings_flutter/feature/authentication/domain/repository/authentication_repository.dart';

import '../entities/user_entity.dart';

class SignInWithGoogleUseCase{
  final AuthenticationRepository authenticationRepository;
  SignInWithGoogleUseCase(this.authenticationRepository);

  Future<UserEntity> signIn() async {
    return await authenticationRepository.signInWithGoogle();
  }
}