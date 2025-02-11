import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saving_trackings_flutter/feature/authentication/domain/use_case/sign_in_use_case.dart';
import 'package:saving_trackings_flutter/feature/authentication/domain/use_case/sign_in_with_facebook_use_case.dart';
import 'package:saving_trackings_flutter/feature/authentication/domain/use_case/sign_in_with_google_use_case.dart';
import 'package:saving_trackings_flutter/feature/authentication/domain/use_case/sign_up_use_case.dart';

import '../../../domain/entities/user_entity.dart';
import '../state/authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final SignInUseCase signIn;
  final SignUpUseCase signUp;
  final SignInWithGoogleUseCase signInWithGoogleUseCase;
  final SignInWithFacebookUseCase signInWithFacebookUseCase;

  AuthenticationCubit({
    required this.signIn,
    required this.signUp,
    required this.signInWithGoogleUseCase,
    required this.signInWithFacebookUseCase,
  }) : super(AuthenticationInitial());

  Future<void> signInUser(String email, String password) async {
    emit(AuthenticationLoading());

    try {
      final user = await signIn.execute(email, password);
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthenticationError(e.toString()));
    }
  }

  Future<void> signUpUser(String email, String password) async {
    emit(AuthenticationLoading());

    try {
      final user = await signUp.execute(email, password);
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthenticationError(e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(AuthenticationLoading());

    try{
      final UserEntity user = await signInWithGoogleUseCase.signIn();
      emit(Authenticated(user));
    }
    catch(e){
      emit(AuthenticationError(e.toString()));
    }
  }

  Future<void> signInWithFacebook() async {
    emit(AuthenticationLoading());

    try{
      final UserEntity user = await signInWithFacebookUseCase.signIn();
      emit(Authenticated(user));
    }
    catch(e){
      emit(AuthenticationError(e.toString()));
      print(e.toString());
    }
  }
}