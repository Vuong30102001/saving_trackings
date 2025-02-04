import 'package:saving_trackings_flutter/feature/authentication/domain/entities/user_entity.dart';
import 'package:saving_trackings_flutter/feature/authentication/domain/repository/authentication_repository.dart';

class SignUpUseCase{
  final AuthenticationRepository authenticationRepository;
  SignUpUseCase(this.authenticationRepository);

  Future<UserEntity> execute(String email, String password) async {
    return await authenticationRepository.signUpWithEmailPassword(email, password);
  }
}