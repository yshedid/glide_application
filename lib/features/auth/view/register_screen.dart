import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glide/core/shared/helper.dart';
import 'package:glide/features/auth/view/login_screen.dart';
import 'package:glide/features/home/view/layout_screen.dart';

import '../../../core/shared/widgets/widgets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../viewmodel/auth_cubit.dart';
import '../viewmodel/auth_state.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state){
          if(state is RegisterSuccess)
            {
              buildNavigatorPushReplacement(context, screen: LayoutScreen());
            }
          else if(state is RegisterFailure)
            {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Registration Failed: ${state.errorMessage}"),
                  backgroundColor: Colors.red,
                ),
              );

            }
        },
        builder: (context, state) => state is AuthLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/register_image.png",
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
                                'Create an Account',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineLarge,
                              ),
                            ),
                            SizedBox(height: 24),
                            buildTextFormField(
                              hintText: 'Full Name',
                              controller: fullNameController,
                              keyboardType: TextInputType.text,
                              obscureText: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your username';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
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
                              hintText: 'Password',
                              controller: passwordController,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if(value != confirmPasswordController.text)
                                {
                                  return "Passwords do not match";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            buildTextFormField(
                              hintText: 'Confirm Password',
                              controller: confirmPasswordController,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if(value != passwordController.text)
                                {
                                  return "Passwords do not match";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: buildMaterialButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    BlocProvider.of<AuthCubit>(context).signUp(
                                      name: fullNameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Please fill in all fields correctly',
                                        ),
                                      ),
                                    );
                                  }
                                },
                                label: 'Register',
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account? ",
                                  style: AppTextStyles.body2,
                                ),
                                TextButton(
                                  onPressed: () {
                                    buildNavigatorPush(
                                      context,
                                      screen: LoginScreen(),
                                    );
                                  },
                                  style: ButtonStyle(
                                    padding: WidgetStateProperty.all(
                                      EdgeInsets.zero,
                                    ),
                                  ),
                                  child: Text(
                                    "Sign in",
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
