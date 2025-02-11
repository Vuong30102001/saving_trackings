import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:saving_trackings_flutter/feature/authentication/domain/use_case/sign_in_use_case.dart';
import 'package:saving_trackings_flutter/feature/authentication/domain/use_case/sign_in_with_facebook_use_case.dart';
import 'package:saving_trackings_flutter/feature/authentication/domain/use_case/sign_in_with_google_use_case.dart';
import 'package:saving_trackings_flutter/feature/authentication/domain/use_case/sign_up_use_case.dart';
import 'package:saving_trackings_flutter/feature/authentication/presentation/cubit/cubit/authentication_cubit.dart';
import 'package:saving_trackings_flutter/feature/authentication/presentation/cubit/state/authentication_state.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:saving_trackings_flutter/feature/wallet/presentation/screen/wallet_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true, // bảo mật dữ liệu tốt hơn KeyStore
    )
  );

  bool rememberMe = false; //kiểm tra checkbox có được chọn không

  @override
  void initState(){
    super.initState();
    _loadSavedCredentials();
  }

  //Đọc email & pasword đọc từ Secure Storage
  Future<void> _loadSavedCredentials() async {
    String? savedEmail = await secureStorage.read(key: "email");
    String? savedPassword = await secureStorage.read(key: "password");

    if(savedEmail != null && savedPassword != null){
      setState(() {
        emailController.text = savedEmail;
        passwordController.text = savedPassword;
        rememberMe = true;
      });
    }
  }

  //Lưu email & password vào secure storage
  Future<void> _saveCredentials(String email, String password) async {
    await secureStorage.write(key: 'email', value: email);
    await secureStorage.write(key: 'password', value: password);
  }

  //Xóa email & password từ secure storage
  Future<void> _deleteCredentials() async {
    await secureStorage.delete(key: 'email');
    await secureStorage.delete(key: 'password');
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: BlocProvider(
              create: (_) => AuthenticationCubit(
                signIn: context.read<SignInUseCase>(),
                signUp: context.read<SignUpUseCase>(),
                signInWithGoogleUseCase: context.read<SignInWithGoogleUseCase>(),
                signInWithFacebookUseCase: context.read<SignInWithFacebookUseCase>()
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
                      SizedBox(height: 40.w,),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              height: 100.w,
                              width: 100.w,
                            ),
                            Text(
                              'V&Y quản lý thu chi cùng bạn',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87
                              ),
                            )
                          ],
                        )
                      ),
                      SizedBox(height: 30.w),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          )
                        ),
                      ),
                      SizedBox(height: 20.w),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                            labelText: 'password',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          )
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 10.w,),
                      Row(
                        children: [
                          Checkbox(
                              value: rememberMe,
                              onChanged: (bool? value){
                                setState(() {
                                  rememberMe = value ?? false;
                                });
                              },
                          ),
                          Text("Nhớ mật khẩu"),
                        ],
                      ),
                      SizedBox(height: 25.w,),
                      state is AuthenticationLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(300.w, 50.w),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              )
                            ),
                            onPressed: () async {
                              final email = emailController.text;
                              final password = passwordController.text;
                              if(rememberMe){
                                await _saveCredentials(email, password);
                              }
                              else{
                                await _deleteCredentials();
                              }
                              context.read<AuthenticationCubit>().signInUser(email, password);
                            },
                            child: Text(
                                'Login',
                              style: TextStyle(
                                fontSize: 12.sp,
                              ),
                            ),
                      ),
                      SizedBox(height: 10.w,),
                      //for google login
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10,),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                          ),
                            onPressed: () {
                              context.read<AuthenticationCubit>().signInWithGoogle();
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Image.network('https://t3.ftcdn.net/jpg/05/18/09/32/360_F_518093233_bYlgthr8ZLyAUQ3WryFSSSn3ruFJLZHM.jpg',
                                  height: 35.w,
                                  ),
                                ),
                                SizedBox(width: 10.w,),
                                Text(
                                  'Continue with google',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                  ),
                                )
                              ],
                            )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10,),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                            ),
                            onPressed: () {
                              context.read<AuthenticationCubit>().signInWithFacebook();
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Image.network('https://i.pinimg.com/736x/f7/8c/a3/f78ca316c03ed09eddefeb2096e76946.jpg',
                                    height: 35.w,
                                  ),
                                ),
                                SizedBox(width: 10.w,),
                                Text(
                                  'Continue',
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                  ),
                                )
                              ],
                            )
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          final email = emailController.text;
                          final password = passwordController.text;
                          context.read<AuthenticationCubit>().signUpUser(email, password);
                        },
                        child: Text(
                            'Register',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
