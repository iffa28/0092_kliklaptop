import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliklaptop/core/build_context_ext.dart';
import 'package:kliklaptop/core/constants/colors.dart';
import 'package:kliklaptop/core/spaces.dart';
import 'package:kliklaptop/data/model/request/auth/login_request.dart';
import 'package:kliklaptop/presentation/admin/admin_home_screen.dart';
import 'package:kliklaptop/presentation/auth/bloc/loginbloc/login_bloc.dart';
import 'package:kliklaptop/presentation/auth/register_view.dart';
import 'package:kliklaptop/presentation/customer/customer_home_screen.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _key = GlobalKey<FormState>();
  bool isShowPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TemplateColors.backgroundAuth,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _key,
              child: Padding(
                padding: const EdgeInsets.all(25
                ),
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: MediaQuery.of(context).size.width * 0.4,
                        ),
                    
                        Text("Selamat Datang Kembali", style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold
                        ),),
                        Text("Silahkan masuk untuk melanjutkan", style: TextStyle(
                          fontSize: 16)),
                        SizedBox(height: 50),

                        
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Masukkan Email anda',
                            
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            prefixIcon: Icon(Icons.email_outlined),
                            fillColor: TemplateColors.fieldAuth, // Correct parameter
                            filled: true
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter your email';
                            }
                          },
                        ),
                        SizedBox(height: Spaces.medium),
                              
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Masukkan Password anda',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              
                            ),
                            prefixIcon: Icon(Icons.lock_outline),
                            fillColor: TemplateColors.fieldAuth, // Correct parameter
                            filled: true,
                            suffixIcon: IconButton(
                              icon: Icon(
                                isShowPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  isShowPassword = !isShowPassword;
                                });
                              },
                            ),
                          ),
                          obscureText: !isShowPassword,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter your password';
                            }
                          },
                        ),
                        SizedBox(height: Spaces.medium),
                        BlocConsumer<LoginBloc, LoginState>(
                          listener: (context, state) {
                            if (state is LoginFailure) {
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(SnackBar(content: Text(state.error)));
                            } else if (state is LoginSuccess) {
                              final role = state.responseModel.user?.role
                                  ?.toLowerCase();
                              if (role == 'admin') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.responseModel.message!)),
                                );
                                context.pushAndRemoveUntil(
                                  const AdminHomeScreen(),
                                  (route) => false,
                                );
                    
                              } else if (role == 'customer') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.responseModel.message!)),
                                );
                                context.pushAndRemoveUntil(
                                  const CustomerHomeScreen(),
                                  (route) => false,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Role tidak dikenal')),
                                );
                              }
                            }
                          },
                              
                          // TODO: implement listener
                          builder: (context, state) {
                            return FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: TemplateColors.buttonAuth,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                
                                minimumSize: Size(
                                  MediaQuery.of(context).size.width * 0.9,
                                  50,
                                ),
                              ),
                              child: state is LoginLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text('Masuk', style: TextStyle(
                                    fontSize: 16
                                  ),),
                              onPressed: () {
                                if (_key.currentState!.validate()) {
                                  final email = _emailController.text;
                                  final password = _passwordController.text;
                              
                                  context.read<LoginBloc>().add(
                                        LoginRequested(
                                          requestModel: LoginRequest(
                                            email: email,
                                            password: password,
                                          ),
                                        ),
                                      );
                                }
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 140),
                        Text.rich(
                          TextSpan(
                            text: 'Belum memiliki akun? Silahkan ',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: MediaQuery.of(context).size.width * 0.035,
                            ),
                            children: [
                              TextSpan(
                                text: 'Daftar disini!',
                                style: TextStyle(color: TemplateColors.regbut, fontSize: MediaQuery.of(context).size.width * 0.035,),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    context.push(const RegisterView());
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
