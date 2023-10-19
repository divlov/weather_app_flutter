import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weather_app_flutter/helpers/get_error_message.dart';
import 'package:weather_app_flutter/screens/Login/LoginBloc/login_state.dart';

class LoginBloc extends Cubit<LoginState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  LoginBloc() : super(const LoginState());

  Future<void> submitForm(Map<String, dynamic> authData, bool isLogin) async {
    emit(const LoginState(isLoading: true));
    try {
      if (isLogin) {
        await _auth.signInWithEmailAndPassword(
            email: authData['email']!, password: authData['password']!);
      } else {
        await _auth.createUserWithEmailAndPassword(
            email: authData['email']!, password: authData['password']!);
      }
      emit(const LoginState(hasLoggedIn: true,isLoading: false));
    } catch (e) {
      final errorMessage=await ErrorMessages(e).getErrorMessage();
      emit(LoginState(error: e.toString(),isLoading: false, errorMessage: errorMessage));
    }
  }
}
