import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sm3ly/cubits/library_cubit/library_cubit.dart';
import 'package:sm3ly/cubits/register_cubit/register_states.dart';
import 'package:sm3ly/models/user_model.dart';
import 'package:sm3ly/service/shared_preferences_helper.dart';

import '../../helpers/has_network.dart';
import '../../service/firestore_helper.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(InitRegisterState());

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  static RegisterCubit get(context) => BlocProvider.of<RegisterCubit>(context);

  Future<void> _register(
    BuildContext context, {
    required String email,
    required String password,
    required String username,
  }) async {
    emit(RegisterLoadingState());
    if (!await hasNetwork()) {
      emit(FailedRegisterState('No Internet Connection'));
      return;
    }
    try {
      final auth = FirebaseAuth.instance;
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userId = auth.currentUser!.uid;
      UserModel newUser = UserModel(
        id: userId,
        username: username,
        email: email,
        totalNumberOfClasses: 0,
        totalNumberOfWords: 0,
        isArabic: false,
        isDarkMode: false,
        isMale: false,
        speakerSpeed: 4.0,
      );

      var currentVoice = {"name": "en-us-x-tpc-local", "locale": "en-US"};
      if (context.mounted) {
        LibraryCubit.get(context).flutterTts.setLanguage("en-US");
        LibraryCubit.get(context).flutterTts.setVoice(currentVoice);
        LibraryCubit.get(context).flutterTts.setSpeechRate(0.4);
        LibraryCubit.get(context).flutterTts.speak('');
      }

      await FirestoreHelper.createNewUserDocument(newUser);
      await SharedPreferencesHelper.setUserData(newUser);

      emit(SuccessRegisterState('Register complete successfully'));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(FailedRegisterState('The password is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        emit(FailedRegisterState('that email is already used.'));
      }
    } catch (e) {
      FailedRegisterState(e.toString());
    }
  }

  Future<void> registerOnPressed(BuildContext context) async {
    await _register(
      context,
      email: emailController.text,
      password: passwordController.text,
      username: usernameController.text,
    );
    clearTextEditingControllers();
  }

  clearTextEditingControllers() {
    usernameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmController.clear();
  }
}
