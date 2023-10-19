class LoginState {
  final bool hasLoggedIn;
  final bool isLoading;
  final String? error;
  final String? errorMessage;

  const LoginState({
    this.hasLoggedIn = false,
    this.isLoading = false,
    this.error,
    this.errorMessage
  });
}