
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:rxdart/subjects.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/app_routes.dart';
import '../model/view_model.abs.dart';
import '../model/datarow.dart';



import '../service/webservice.dart';



class SecondPageState {
  final bool loadOk;
  final int count;
  final  datarows;


  SecondPageState({
    this.loadOk = false,
    this.count = 0,
    this.datarows = List<Datarow>


  });

  SecondPageState copyWith({
    bool? loadOk,
    List<Datarow>? datarows,
    int? count,

  }) {
    return SecondPageState(
      loadOk: loadOk ?? this.loadOk,
      datarows: datarows ?? this.datarows,
      count: count ?? this.count,

    );
  }
}

class SecondPageViewModel extends ViewModel {
  final _stateSubject =
  BehaviorSubject<SecondPageState>.seeded(SecondPageState());
  Stream<SecondPageState> get state => _stateSubject;

  final _routesSubject = PublishSubject<AppRouteSpec>();
  Stream<AppRouteSpec> get routes => _routesSubject;

  SecondPageViewModel({required int count}) {
    _stateSubject.add(SecondPageState(count: count));
  }
  final List <String> groupNames = <String>[];
  List<bool> boolList = List.filled(99, true);
  List <Datarow> datarow = <Datarow>[];
  int _selectedIndex = 0;



Future<void> getTableData(context,String month, String size, String pageNumber) async {
  final data = await Webservice().getDataForTable(month,size,pageNumber);

  if (data.length > 0) {

    datarow.clear();
    for(var i= 0; i<data.length; i++) {
      Datarow row = Datarow.fromJson(data[i]);
      datarow.add(row);
    }

    updateStateDatarows(datarow);






  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}



  void logOut() {
    _routesSubject.add(
      AppRouteSpec(
          name: '/'
      ),

    );
  }

  void updateStateDatarows(List<Datarow> data) {
    final state = _stateSubject.value;
    _stateSubject.add(
      state.copyWith(
        datarows: data,
      ),
    );
  }



  @override
  void dispose() {
    _stateSubject.close();
    _routesSubject.close();
  }
}