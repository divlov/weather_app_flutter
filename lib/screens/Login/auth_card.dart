import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_flutter/screens/Login/LoginBloc/login_cubit.dart';
import 'package:weather_app_flutter/screens/Login/LoginBloc/login_state.dart';

enum AuthMode {
  signup,
  login,
}

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  AuthCardState createState() => AuthCardState();
}

class AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {};
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  late AnimationController _controller;
  late LoginBloc _loginBloc;

  // late Animation<Size> _heightAnimation;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));

    // BlocProvider.of<LoginBloc>(context).stream.listen((state) {
    //   //TODO: check working of navigation
    //   if (state.hasLoggedIn) {
    //     // Navigate to the home page
    //     // Navigator.of(context)
    //     //     .pushReplacement(MaterialPageRoute(builder: (_) => HomeView()));
    //   }
    // });

    super.initState();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    _loginBloc.submitForm(_authData, _authMode == AuthMode.login);
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _formKey.currentState!.reset();
        _authMode = AuthMode.signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _formKey.currentState!.reset();
        _authMode = AuthMode.login;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Center(
      child: BlocProvider(
        create: (_) {
          _loginBloc = LoginBloc();
          return _loginBloc;
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 8.0,
              //or use AnimatedContainer and change the height and constraints to the commented out one
              //and remove all animation
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.fastOutSlowIn,
                child: SizedBox(
                  // height: _authMode==AuthMode.Signup ?320 : 240,
                  width: deviceSize.width * 0.75,
                  child: ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'E-Mail'),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty || !value.contains('@')) {
                                  return 'Invalid email';
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.next,
                              onSaved: (value) {
                                _authData['email'] = value!;
                              },
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 350),
                              constraints: BoxConstraints(
                                  maxHeight:
                                      _authMode == AuthMode.login ? 0 : 70),
                              curve: Curves.fastOutSlowIn,
                              child: FadeTransition(
                                opacity: CurvedAnimation(
                                    parent: _controller,
                                    curve: Curves.fastOutSlowIn),
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                          begin: const Offset(0, -1.0),
                                          end: const Offset(0, 0))
                                      .animate(CurvedAnimation(
                                          parent: _controller,
                                          curve: Curves.fastOutSlowIn)),
                                  child: TextFormField(
                                    enabled: _authMode == AuthMode.signup,
                                    decoration: const InputDecoration(
                                        labelText: 'Name'),
                                    textInputAction: TextInputAction.next,
                                    validator: _authMode == AuthMode.signup
                                        ? (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter your name';
                                            }
                                            return null;
                                          }
                                        : null,
                                    controller: _usernameController,
                                    onSaved: (value) {
                                      _authData['name'] = value!;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Password'),
                              obscureText: true,
                              controller: _passwordController,
                              validator: (value) {
                                if (value!.isEmpty || value.length < 5) {
                                  return 'Password is too short';
                                }
                                return null;
                              },
                              textInputAction: _authMode == AuthMode.signup
                                  ? TextInputAction.next
                                  : TextInputAction.done,
                              onFieldSubmitted: _authMode == AuthMode.login
                                  ? (_) => _submit()
                                  : null,
                              onSaved: (value) {
                                _authData['password'] = value!;
                              },
                            ),
                            // if (_authMode == AuthMode.Signup)
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 350),
                              constraints: BoxConstraints(
                                  maxHeight:
                                      _authMode == AuthMode.login ? 0 : 70),
                              curve: Curves.fastOutSlowIn,
                              child: FadeTransition(
                                opacity: CurvedAnimation(
                                    parent: _controller,
                                    curve: Curves.fastOutSlowIn),
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                          begin: const Offset(0, -1.0),
                                          end: const Offset(0, 0))
                                      .animate(CurvedAnimation(
                                          parent: _controller,
                                          curve: Curves.fastOutSlowIn)),
                                  child: TextFormField(
                                    enabled: _authMode == AuthMode.signup,
                                    decoration: const InputDecoration(
                                        labelText: 'Confirm Password'),
                                    obscureText: true,
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (_) => _submit(),
                                    validator: _authMode == AuthMode.signup
                                        ? (value) {
                                            if (value !=
                                                _passwordController.text) {
                                              return 'Passwords do not match!';
                                            }
                                            return null;
                                          }
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            BlocBuilder<LoginBloc, LoginState>(
                                builder: (ctx, state) {
                              if (state.isLoading) {
                                return const CircularProgressIndicator();
                              } else {
                                return ElevatedButton(
                                  onPressed: () => _submit(),
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    )),
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(
                                            horizontal: 30.0, vertical: 8.0)),
                                    backgroundColor: MaterialStateProperty.all(
                                        Theme.of(context).primaryColor),
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    textStyle: MaterialStateProperty.all(
                                        const TextStyle(color: Colors.white)),
                                  ),
                                  child: Text(_authMode == AuthMode.login
                                      ? 'LOGIN'
                                      : 'SIGN UP'),
                                );
                              }
                            }),
                            TextButton(
                              onPressed: _switchAuthMode,
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(
                                        horizontal: 30.0, vertical: 4)),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                _authMode == AuthMode.login
                                    ? 'SIGNUP'
                                    : 'LOGIN',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            BlocBuilder<LoginBloc, LoginState>(builder: (ctx, state) {
              if (state.error != null) {
                return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey[800]!)),
                  margin: const EdgeInsets.all(30),
                  width: deviceSize.width * 0.75,
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error,
                        color: Colors.grey[800],
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                          child: Text(state.errorMessage!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black))),
                    ],
                  ),
                );
              } else {
                return const SizedBox();
              }
            }),
          ],
        ),
      ),
    );
  }
}
