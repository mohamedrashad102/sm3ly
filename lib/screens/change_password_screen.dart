import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sm3ly/constant.dart';
import '../components/custom_text.dart';
import '../cubits/change_password_cubit/change_password_cubit.dart';
import '../cubits/change_password_cubit/change_password_states.dart';
import '../helpers/validators.dart';
import '../components/custom_text_button.dart';
import '../components/custom_text_form_field.dart';
import '../components/font.dart';
import '../helpers/show_snack_bar.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});
  static const String id = 'change password screen';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangePasswordCubit, ChangePasswordStates>(
      listener: (context, state) {
        if (state is SuccessChangePasswordState) {
          showSnackBar(
            context,
            text: state.requestMessage,
          );
        } else if (state is FailedChangePasswordState) {
          showSnackBar(
            context,
            text: state.requestMessage,
            isError: true,
          );
        }
      },
      builder: (context, state) {
        var cubit = ChangePasswordCubit.get(context);
        return ModalProgressHUD(
          inAsyncCall: state is ChangePasswordLoadingState,
          child: Scaffold(
            appBar: AppBar(
                backgroundColor: MyColors.textButton,
                leading: const Icon(Icons.key),
                title: Center(
                  child: Text(
                    "Change password",
                    style: MyFonts.englishFont(),
                  ),
                )),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Form(
                  key: cubit.formKey,
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/change-removebg-preview.png",
                        height: 200,
                        width: 200,
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: cubit.currentPasswordController,
                        labelText: "Current Password",
                        validator: validatePassword,
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        obscureText: true,
                        controller: cubit.newPasswordController,
                        labelText: "New Password",
                        validator: validatePassword,
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        obscureText: true,
                        controller: cubit.confirmPasswordController,
                        labelText: "Confirm Password",
                        validator: (value) {
                          if (value != cubit.newPasswordController.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomText(
                            text: "Forget Password ?",
                            color: Colors.indigo,
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CustomTextButton(
                        onPressed: () async =>
                            await cubit.changePasswordOnPressed(context),
                        text: "Change",
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
