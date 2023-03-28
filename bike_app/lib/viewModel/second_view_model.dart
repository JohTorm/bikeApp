
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:rxdart/subjects.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/app_routes.dart';
import '../model/view_model.abs.dart';


import '../service/webservice.dart';



class SecondPageState {
  final bool loadOk;
  final String email;


  SecondPageState({
    this.loadOk = false,
    this.email = '',


  });

  SecondPageState copyWith({
    bool? loadOk,

    String? email,

  }) {
    return SecondPageState(
      loadOk: loadOk ?? this.loadOk,
      email: email ?? this.email,

    );
  }
}

class SecondPageViewModel extends ViewModel {
  final _stateSubject =
  BehaviorSubject<SecondPageState>.seeded(SecondPageState());
  Stream<SecondPageState> get state => _stateSubject;

  final _routesSubject = PublishSubject<AppRouteSpec>();
  Stream<AppRouteSpec> get routes => _routesSubject;

  SecondPageViewModel({required bool loadOk, required String email}) {
    _stateSubject.add(SecondPageState(loadOk: loadOk, email: email));
  }
  final List <String> groupNames = <String>[];
  List<bool> boolList = List.filled(99, true);
  int _selectedIndex = 0;








  void logOut() {
    _routesSubject.add(
      AppRouteSpec(
          name: '/'
      ),

    );
  }


  @override
  void dispose() {
    _stateSubject.close();
    _routesSubject.close();
  }
}