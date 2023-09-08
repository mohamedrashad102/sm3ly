String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'You must enter an email';
  }

  final bool emailValid =
      RegExp(r"^[a-z0-9.]+@gmail\.com$")
          .hasMatch(value);

  if (!emailValid) {
    return 'Enter a valid email';
  }

  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'You must enter a password';
  }
  if (value.length < 6) {
    return 'Password must be at least 6 characters';
  }
  return null;
}


String? validateUserName(String? value) {
  if (value!.isEmpty) {
    return "Please enter your Full name";
  } else {
    return null;
  }
}
