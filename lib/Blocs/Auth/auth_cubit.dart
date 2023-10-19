import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_flutter/Blocs/Auth/auth_state.dart';

class AuthCubit extends Cubit<AuthState>{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthCubit():super(AuthState(isLoggedIn: false)){
    _auth.authStateChanges().listen((user) {
      emit(AuthState(isLoggedIn: user!=null));
    });
  }

}