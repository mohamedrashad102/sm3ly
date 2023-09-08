import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sm3ly/cubits/login_cubit/login_states.dart';
import 'package:sm3ly/service/shared_preferences_helper.dart';
import '../../helpers/has_network.dart';
import '../../screens/register_screen.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());
  static LoginCubit get(context) => BlocProvider.of<LoginCubit>(context);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    emit(LoginLoadingState());
    if (!await hasNetwork()) {
      emit(LoginErrorState('No Internet Connection'));
      return;
    }
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      SharedPreferencesHelper.setIsLogin(true);

      emit(LoginSuccessState('Login complete successfully'));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(LoginErrorState('No user found.'));
      } else if (e.code == 'wrong-password') {
        emit(LoginErrorState('Invalid email or password.'));
      }
    }
  }

  Future<void> loginOnPressed(BuildContext context) async {
    
      await _login(
        context,
        email: emailController.text,
        password: passwordController.text,
      );
      clearTextEditingControllers();
    
  }

  void forgetPasswordOnPressed(BuildContext context) async {
    emit(LoginErrorState('Coming soon'));
    // Navigator.pushNamed(context, ChangePasswordScreen.id);
  }

  void registerOnPressed(BuildContext context) {
    clearTextEditingControllers();
    Navigator.pushNamed(context, RegisterScreen.id);
  }

  void clearTextEditingControllers() {
    emailController.clear();
    passwordController.clear();
  }

  // ############## out login #################

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    SharedPreferencesHelper.setIsLogin(false);
    emit(SignOutState());
  }

  Future<void> deleteAccount() async {
    await FirebaseAuth.instance.currentUser!.delete();
    emit(DeleteAccountState());
  }

  bool isUserLogin() {
    return SharedPreferencesHelper.isLogin();
  }
}
