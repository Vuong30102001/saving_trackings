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
          child: BlocListener<AuthenticationCubit, AuthenticationState>(
              listener: (context, state){
                if(state is Authenticated){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Login Success'))
                  );
                }
                else if(state is AuthenticationError){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message))
                  );
                }
              },
            child: Column(
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
                  onPressed: () async {
                    final email = emailController.text;
                    final password = passwordController.text;
                    print("Đang thực hiện đăng nhập với email: $email"); // Thêm print để kiểm tra
                    await context.read<AuthenticationCubit>().signInUser(email, password);
                    context.go('/home');
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
            ),
          ),
        ),
      ),
    );
  }
}
