import 'package:flutter/services.dart';
import 'package:weather_app_flutter/helpers/internet_checker.dart';

class ErrorMessages {
  Object error;

  ErrorMessages(this.error);

  Future<String> getErrorMessage() async {
    print(error.toString());
    switch (error.toString()) {
      case 'EMAIL_EXISTS':
        return 'The email address is already in use by another account';
      case 'TOO_MANY_ATTEMPTS_TRY_LATER':
        return 'We have blocked all requests from this device due to unusual activity. Try again later.';
      case 'INVALID_EMAIL':
        return 'This is not a valid email address';
      case 'WEAK_PASSWORD':
        return 'The password is too weak.';
      case 'INVALID_PASSWORD':
      case 'EMAIL_NOT_FOUND':
        return 'Incorrect email/password entered.';
      default:
        final value = await InternetChecker().hasConnection;

        if (error is PlatformException) {
          return (error as dynamic).message ?? 'Some error occurred';
        } else {
          return !value
              ? 'Please check your internet connection'
              : 'Some error occurred';
        }
    }
  }
}
