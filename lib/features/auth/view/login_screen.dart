import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glide/core/shared/helper.dart';
import 'package:glide/core/theme/app_text_styles.dart';
import 'package:glide/features/auth/view/register_screen.dart';
import 'package:glide/features/home/view/layout_screen.dart';

import '../../../core/shared/widgets/widgets.dart';
import '../../../core/theme/app_colors.dart';
import '../viewmodel/auth_cubit.dart';
import '../viewmodel/auth_state.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state){
          if(state is LoginSuccess)
            {
              buildNavigatorPushReplacement(context, screen: LayoutScreen());
            }
        },
        builder: (context, state) => state is AuthLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/login_image.png",
                      height: (320 / 844) * MediaQuery.of(context).size.height,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Center(
                              child: Text(
                                'Welcome Back',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineLarge,
                              ),
                            ),
                            SizedBox(height: 12),
                            buildTextFormField(
                              hintText: 'Email',
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              obscureText: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            buildTextFormField(
                              controller: passwordController,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                              hintText: 'Password',
                            ),
                            SizedBox(height: 5),
                            TextButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                padding: WidgetStateProperty.all(
                                  EdgeInsets.zero,
                                ),
                              ),
                              child: Text(
                                "Forgot Password?",
                                style: AppTextStyles.body2,
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: buildMaterialButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    log(
                                      "Email: ${emailController.text}, Password: ${passwordController.text}",
                                    );
                                    BlocProvider.of<AuthCubit>(context).signIn(
                                      emailController.text,
                                      passwordController.text,
                                    );
                                  }
                                },
                                label: 'Login',
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Or continue with",
                              style: AppTextStyles.body2,
                            ),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: buildMaterialButton(
                                    onPressed: () {},
                                    label: 'Google',
                                    color: AppColors.accent,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: buildMaterialButton(
                                    onPressed: () {},
                                    label: 'Facebook',
                                    color: AppColors.accent,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height:
                                  (60 / 844) *
                                  MediaQuery.of(context).size.height,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account? ",
                                  style: AppTextStyles.body2,
                                ),
                                TextButton(
                                  onPressed: () {
                                    buildNavigatorPush(
                                      context,
                                      screen: RegisterScreen(),
                                    );
                                  },
                                  style: ButtonStyle(
                                    padding: WidgetStateProperty.all(
                                      EdgeInsets.zero,
                                    ),
                                  ),
                                  child: Text(
                                    "Sign Up",
                                    style: AppTextStyles.body2.copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
