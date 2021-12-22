import 'package:flutter/cupertino.dart';
import 'package:weight_tracker/model/user.dart';

class UserProvider extends ChangeNotifier{
  bool _loading = true;
  // ignore: prefer_final_fields, unused_field
  late User _user;

  setIsProcessing(bool value){
    _loading = value;
    notifyListeners();
  }
  
  User get user => _user;

  setUser(User user){
    _user = user;
    notifyListeners();
  }

}
