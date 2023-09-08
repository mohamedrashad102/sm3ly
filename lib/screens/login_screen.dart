import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sm3ly/cubits/library_cubit/library_cubit.dart';
import 'package:sm3ly/cubits/user_cubit/user_cubit.dart';
import 'package:sm3ly/screens/home.dart';
import '../components/custom_container.dart';
import '../cubits/login_cubit/login_cubit.dart';
import '../cubits/login_cubit/login_states.dart';
import 'package:sm3ly/constant.dart';
import '../components/custom_text.dart';
import '../components/custom_text_form_field.dart';
import '../helpers/show_snack_bar.dart';
import '../helpers/validators.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  static const String id = 'login screen';
  final GlobalKey<FormState> _loginFromKey =
      GlobalKey<FormState>(debugLabel: 'loginFormKey');

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            showSnackBar(
              context,
              text: state.requestMessage,
            );
            UserCubit.get(context).fetchUserData();
            LibraryCubit.get(context).fetchLibraryData();
            Navigator.pushNamed(context, Home.id);
          } else if (state is LoginErrorState) {
            showSnackBar(
              context,
              text: state.requestMessage,
              isError: true,
            );
          }
        },
        builder: (context, state) {
          var cubit = LoginCubit.get(context);
          return ModalProgressHUD(
            inAsyncCall: state is LoginLoadingState,
            child: SafeArea(
              child: Scaffold(
                  body: Form(
                key: _loginFromKey,
                child: SingleChildScrollView(
                  child: Column(children: [
                    const CustomContainer(
                        child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomText(
                            text: "Sign in to your",
                            fontSize: 25,
                          ),
                          CustomText(
                            text: "Account",
                            fontSize: 25,
                          ),
                          CustomText(
                            text: "Sign in your Account",
                            fontSize: 14,
                            color: Color(0xffAFB9C2),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CustomText(
                                text: "Sam3ly",
                              ),
                              Icon(
                                Icons.book,
                                color: Colors.white,
                                size: 26,
                              )
                            ],
                          )
                        ],
                      ),
                    )),
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Email FormField
                          CustomTextFormField(
                            prefixIcon: Icons.email_outlined,
                            labelText: "Email",
                            controller: cubit.emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: validateEmail,
                          ),
                          const SizedBox(height: 20),
                          // Password FormField
                          CustomTextFormField(
                            prefixIcon: Icons.lock_outlined,
                            labelText: "Password",
                            obscureText: true,
                            controller: cubit.passwordController,
                            validator: validatePassword,
                          ),
                          // Forget password?  # row to move it to the end
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Forget Password?
                              TextButton(
                                onPressed: () =>
                                    cubit.forgetPasswordOnPressed(context),
                                child: const CustomText(
                                  text: "Forget Password?",
                                  color: MyColors.textButton,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          // login button
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: MyColors.textButton,
                                  minimumSize: const Size(250, 50)),
                              onPressed: () async {
                                if (_loginFromKey.currentState!.validate()) {
                                  await cubit.loginOnPressed(context);
                                }
                              },
                              child: const CustomText(
                                text: "Login",
                                fontSize: 20,
                              )),
                          // "Don't have an account? Register"
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // "Don't have an account?"
                              const CustomText(
                                text: "Don't have an account?",
                                color: MyColors.gradient1,
                                fontSize: 14,
                              ),
                              // Register -- button
                              TextButton(
                                child: const CustomText(
                                  text: "Register",
                                  color: MyColors.textButton,
                                  fontSize: 14,
                                ),
                                onPressed: () =>
                                    cubit.registerOnPressed(context),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ]),
                ),
              )),
            ),
          );
        },
      ),
    );
  }
}
