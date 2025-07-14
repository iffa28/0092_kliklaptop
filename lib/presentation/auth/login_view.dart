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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/logo.png',
                    width: MediaQuery.of(context).size.width * 0.35,
                  ),
                  const SizedBox(height: 24),

                  // Welcome Text
                  Text(
                    "Selamat Datang Kembali",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Silahkan masuk untuk melanjutkan",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Masukkan email anda',
                      filled: true,
                      fillColor: TemplateColors.fieldAuth,
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Masukkan email' : null,
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Masukkan password anda',
                      filled: true,
                      fillColor: TemplateColors.fieldAuth,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isShowPassword ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey[700],
                        ),
                        onPressed: () {
                          setState(() {
                            isShowPassword = !isShowPassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    obscureText: !isShowPassword,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Masukkan password' : null,
                  ),
                  const SizedBox(height: 24),

                  // Login Button
                  BlocConsumer<LoginBloc, LoginState>(
                    listener: (context, state) {
                      if (state is LoginFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.error)),
                        );
                      } else if (state is LoginSuccess) {
                        final role = state.responseModel.user?.role?.toLowerCase();
                        final successMsg = state.responseModel.message ?? "Berhasil login";

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(successMsg)),
                        );

                        if (role == 'admin') {
                          context.pushAndRemoveUntil(const AdminHomeScreen(), (route) => false);
                        } else if (role == 'customer') {
                          context.pushAndRemoveUntil(const CustomerHomeScreen(), (route) => false);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Role tidak dikenal')),
                          );
                        }
                      }
                    },
                    builder: (context, state) {
                      return SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TemplateColors.buttonAuth,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            if (_key.currentState!.validate()) {
                              context.read<LoginBloc>().add(
                                    LoginRequested(
                                      requestModel: LoginRequest(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      ),
                                    ),
                                  );
                            }
                          },
                          child: state is LoginLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  'Masuk',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 80),

                  // Register Link
                  Text.rich(
                    TextSpan(
                      text: 'Belum punya akun? ',
                      style: TextStyle(color: Colors.grey[600]),
                      children: [
                        TextSpan(
                          text: 'Daftar disini!',
                          style: TextStyle(
                            color: TemplateColors.regbut,
                            fontWeight: FontWeight.bold,
                          ),
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
            ),
          ),
        ),
      ),
    ),
  );
}

}
