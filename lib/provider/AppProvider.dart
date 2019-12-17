import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class AppProvider with ChangeNotifier{

  ThemeData _appTheme;

  get getApptheme => this._appTheme;


  setThemeData(theme){
    this._appTheme = theme;
    notifyListeners();
  }

  List taskList = [];

  setTaskList(value){
    this.taskList.add(value);
    notifyListeners();
  }
}