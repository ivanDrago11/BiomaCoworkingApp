import 'package:flutter/material.dart';


class AreaService extends ChangeNotifier {

  Object _areas = {};
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  Object get areas => _areas;
  
  set isLoading( bool value ) {
    _isLoading = value;
    notifyListeners();
  }

  set areas( Object value ) {
    _areas = value;
  }

}