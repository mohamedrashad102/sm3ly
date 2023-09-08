abstract class ChangePasswordStates {}


class ChangePasswordInitState extends ChangePasswordStates {}

class ChangePasswordLoadingState extends ChangePasswordStates {}

class SuccessChangePasswordState extends ChangePasswordStates {
  String requestMessage;
  SuccessChangePasswordState(this.requestMessage);
}

class FailedChangePasswordState extends ChangePasswordStates {
  String requestMessage;
  FailedChangePasswordState(this.requestMessage);
}
