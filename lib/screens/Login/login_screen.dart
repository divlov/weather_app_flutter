import 'package:flutter/material.dart';
import 'package:weather_app_flutter/screens/Login/auth_card.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: AuthCard(),
        ),
      ),
    );
  }
}
