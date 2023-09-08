import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sm3ly/components/custom_container.dart';
import 'package:sm3ly/components/custom_text.dart';
import '../cubits/register_cubit/register_cubit.dart';
import '../helpers/show_snack_bar.dart';
import '../helpers/validators.dart';
import '../screens/login_screen.dart';
import 'package:sm3ly/constant.dart';
import '../components/custom_text_form_field.dart';
import '../components/font.dart';
import '../cubits/register_cubit/register_states.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  static const String id = 'register screen';
  final GlobalKey<FormState> _registerFromKey =
      GlobalKey<FormState>(debugLabel: 'registerFormKey');

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is SuccessRegisterState) {
          showSnackBar(context, text: state.requestMessage);
          Navigator.pushNamed(context, LoginScreen.id);
        } else if (state is FailedRegisterState) {
          showSnackBar(context, text: state.requestMessage, isError: true);
        }
      },
      builder: (context, state) {
        var cubit = RegisterCubit.get(context);
        return ModalProgressHUD(
          inAsyncCall: state is RegisterLoadingState,
          child: SafeArea(
            child: Scaffold(
                backgroundColor: Colors.white,
                body: Form(
                    key: _registerFromKey,
                    child: SingleChildScrollView(
                      child: Column(children: [
                        CustomContainer(
                            child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                      text: "Register",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 25,
                                      color: Colors.white),
                                  CustomText(
                                    text: "Create your Account",
                                    color: Color(0xffAFB9C2),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Image.asset(
                                  "assets/images/re.png",
                                  height: 150,
                                  width: 150,
                                ),
                              )
                            ],
                          ),
                        )),
                        const SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              CustomTextFormField(
                                controller: cubit.usernameController,
                                labelText: "Full Name",
                                validator: validateUserName,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomTextFormField(
                                controller: cubit.emailController,
                                labelText: "Email",
                                validator: validateEmail,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 20),
                              CustomTextFormField(
                                obscureText: true,
                                controller: cubit.passwordController,
                                labelText: "Password",
                                validator: validatePassword,
                              ),
                              const SizedBox(height: 20),
                              CustomTextFormField(
                                obscureText: true,
                                controller: cubit.confirmController,
                                labelText: "Confirm Password",
                                validator: (value) {
                                  if (value != cubit.passwordController.text) {
                                    return "Passwords do not match";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: MyColors.textButton,
                                      minimumSize: const Size(250, 50)),
                                  onPressed: () async {
                                    if (_registerFromKey.currentState!
                                        .validate()) {
                                      await cubit.registerOnPressed(context);
                                    }
                                  },
                                  child: Text(
                                    "Register",
                                    style: MyFonts.englishFont(),
                                  )),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Already have an account?",
                                    style: MyFonts.englishFont(
                                        color: MyColors.gradient1),
                                  ),
                                  TextButton(
                                    child: Text(
                                      "Log in",
                                      style: MyFonts.englishFont(
                                          color: MyColors.textButton),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ]),
                    ))),
          ),
        );
      },
    );
  }
}
