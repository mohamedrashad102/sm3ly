
abstract class UserState {}

class UserInitialState extends UserState {}

class UserLoadingState extends UserState {}

class UserChangeVoiceTypeLoadingState extends UserState {}


class UserSuccessState extends UserState {}

class UserSuccessSignOutState extends UserState {}

class UserErrorState extends UserState {
  String errorMessage;
  UserErrorState(this.errorMessage);
}
