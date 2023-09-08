import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sm3ly/cubits/change_password_cubit/change_password_states.dart';

import '../../helpers/has_network.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordStates> {
  ChangePasswordCubit() : super(ChangePasswordInitState());

  final newPasswordController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  static ChangePasswordCubit get(context) =>
      BlocProvider.of<ChangePasswordCubit>(context);

  Future<void> _changePassword(
    BuildContext context, {
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(ChangePasswordLoadingState());
    if (!await hasNetwork()) {
      emit(FailedChangePasswordState('No Internet Connection'));
      return;
    }
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final cred = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(cred);
        await user.updatePassword(newPassword);
        emit(SuccessChangePasswordState('Update password successfully'));
      } else {
        emit(FailedChangePasswordState('You must login first'));
      }
    } catch (error) {
      emit(FailedChangePasswordState('Wrong password'));
    }
  }

  Future<void> changePasswordOnPressed(BuildContext context, ) async {
     if (formKey.currentState!.validate()) {
      await _changePassword(
        context,
        currentPassword:
            currentPasswordController.text,
        newPassword: newPasswordController.text,
      );
      clearTextEditingControllers();
    }
  }

  void clearTextEditingControllers() {
    newPasswordController.clear();
    currentPasswordController.clear();
    confirmPasswordController.clear();
  }
}
