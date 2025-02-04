import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:saving_trackings_flutter/feature/authentication/domain/use_case/sign_in_use_case.dart';
import 'package:saving_trackings_flutter/feature/authentication/domain/use_case/sign_up_use_case.dart';
import 'package:saving_trackings_flutter/feature/authentication/presentation/cubit/cubit/authentication_cubit.dart';
import 'package:saving_trackings_flutter/feature/authentication/presentation/cubit/state/authentication_state.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocProvider(
          create: (_) => AuthenticationCubit(
            signIn: context.read<SignInUseCase>(),
            signUp: context.read<SignUpUseCase>(),
          ),
          child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
            builder: (context, state) {
              if (state is Authenticated) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.go('/home');
                });
                return Container();
              } else if (state is AuthenticationError) {
                WidgetsBinding.instance.addPostFrameCallback((_){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message))
                  );
                });
              }

              return Column(
                children: [
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(hintText: 'email'),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(hintText: 'password'),
                    obscureText: true,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final email = emailController.text;
                      final password = passwordController.text;
                      context.read<AuthenticationCubit>().signInUser(email, password);
                    },
                    child: Text('Login'),
                  ),
                  TextButton(
                    onPressed: () {
                      final email = emailController.text;
                      final password = passwordController.text;
                      context.read<AuthenticationCubit>().signUpUser(email, password);
                    },
                    child: Text('Register'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
