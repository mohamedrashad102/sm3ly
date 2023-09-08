abstract class LoginState {}

class LoginLoadingState extends LoginState {}

class LoginInitialState extends LoginState {}

class LoginSuccessState extends LoginState {
  LoginSuccessState(this.requestMessage);
  String requestMessage;
}

class LoginErrorState extends LoginState {
  LoginErrorState(this.requestMessage);
  String requestMessage;
}

class SignOutState extends LoginState {}

class DeleteAccountState extends LoginState {}


