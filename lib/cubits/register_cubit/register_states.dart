abstract class RegisterState {}

class InitRegisterState extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class SuccessRegisterState extends RegisterState {
  String requestMessage;
  SuccessRegisterState(this.requestMessage);
}

class FailedRegisterState extends RegisterState {
  String requestMessage;
  FailedRegisterState(this.requestMessage);
}
