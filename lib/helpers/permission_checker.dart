import 'dart:async';

import 'package:permission_handler/permission_handler.dart';

class PermissionChecker {

  String apiKey = 'a3628af7db30f675c26ad6c45bbff0c5';

  PermissionChecker._();

  static final PermissionChecker _instance = PermissionChecker._();

  factory PermissionChecker.getInstance() {
  return _instance;
  }

  Future<bool> _checkLocationPermission() async {
    if (await Permission.location.request().isGranted) {
      return true;
    } else if ((await Permission.location.status) ==
        PermissionStatus.permanentlyDenied) {
      throw PermissionException(
          'Please enable location permission through app settings.');
    } else {
      throw PermissionException('App needs location to fetch weather');
    }
  }

  Completer<void>? _ongoingOperation;

  Future<void> checkLocationPermission() async {
    if (_ongoingOperation != null && !_ongoingOperation!.isCompleted) {
      // If there's an ongoing operation, return its reference.
      return _ongoingOperation!.future;
    }

    // Start a new operation.
    _ongoingOperation = Completer<void>();

    try {
      // Your asynchronous code here.
      await _checkLocationPermission();
      _ongoingOperation!.complete(); // Mark the operation as completed.
    } catch (error) {
      _ongoingOperation!.completeError(error); // Handle any errors.
    }

    return _ongoingOperation!.future;
  }
}

class PermissionException implements Exception {
  String message;

  PermissionException(this.message);

  @override
  String toString() {
    return message;
  }
}
