import 'package:permission_handler/permission_handler.dart';

class PermissionChecker{

  Future<bool> checkLocationPermission() async{
    if(await Permission.location.request().isGranted){
      return true;
    }
    else if( (await Permission.location.status)==PermissionStatus.permanentlyDenied){
        throw PermissionException('Please enable location permission through app settings.');
      }
    else{
      throw PermissionException('App needs location to fetch weather');
    }
  }
}

class PermissionException implements Exception{

  String message;

  PermissionException(this.message);

  @override
  String toString() {
    return message;
  }
}