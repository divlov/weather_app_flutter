import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';

class InternetChecker{

  Future<bool> get hasConnection async{
    try{
      return (await Connectivity().checkConnectivity()) !=
          ConnectivityResult.none;
    }
    catch(e){
      return false;
    }
  }

  Future<void>  checkNOConnectionAndShowToast() async{
    try{
      if(await Connectivity().checkConnectivity()==ConnectivityResult.none){
        Fluttertoast.showToast(msg: "No internet connection",toastLength: Toast.LENGTH_SHORT);
      }
    }
    catch(e){
        Fluttertoast.showToast(msg: "No internet connection",toastLength: Toast.LENGTH_SHORT);
    }
  }

}