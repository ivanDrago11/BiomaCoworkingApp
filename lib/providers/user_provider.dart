import 'package:flutter/material.dart';


class UserService extends ChangeNotifier {

  Object _activeUser = {};
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  Object get activeUser => _activeUser;
  
  set isLoading( bool value ) {
    _isLoading = value;
    notifyListeners();
  }

  set activeUser( Object value ) {
    _activeUser = value;
    notifyListeners();
  }

}