import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:weather_app_flutter/Blocs/Auth/auth_cubit.dart';
import 'package:weather_app_flutter/Blocs/Auth/auth_state.dart';
import 'package:weather_app_flutter/helpers/internet_checker.dart';
import 'package:weather_app_flutter/screens/Home/home_view.dart';
import 'package:weather_app_flutter/screens/Login/login_screen.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    InternetChecker().checkNOConnectionAndShowToast();
    Connectivity().onConnectivityChanged.listen((connectivityResult) {
      if(connectivityResult==ConnectivityResult.none){
        Fluttertoast.showToast(msg: "No internet connection",toastLength: Toast.LENGTH_SHORT);
      }
    });
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_)=>AuthCubit(),
        child: BlocBuilder<AuthCubit,AuthState>(
          builder: (ctx,authState){
            if(authState.isLoggedIn){
              return HomeView();
            }
            else{
              return const AuthScreen();
            }
          },
        ),
      ),
    );
  }
}
