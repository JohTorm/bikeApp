
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:rxdart/subjects.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/app_routes.dart';
import '../model/view_model.abs.dart';
import '../model/datarow.dart';
import '../model/station.dart';



import '../service/webservice.dart';



class SecondPageState {
  final bool loadOk;
  final int countMay;
  final int countJune;
  final int countJuly;
  final int stationLength;
  final  datarows;
  final stations;


  SecondPageState({
    this.loadOk = false,
    this.countMay = 0,
    this.countJune = 0,
    this.countJuly = 0,
    this.datarows = List<Datarow>,
    this.stations = List<Station>,
    this.stationLength = 0,


  });

  SecondPageState copyWith({
    bool? loadOk,
    List<Datarow>? datarows,
    int? countMay,
    int? countJuly,
    int? countJune,
    List<Station>? stations,
    int? stationLength

  }) {
    return SecondPageState(
      loadOk: loadOk ?? this.loadOk,
      datarows: datarows ?? this.datarows,
      countMay: countMay ?? this.countMay,
      countJune: countJune ?? this.countJune,
      countJuly: countJuly ?? this.countJuly,
      stations: stations ?? this.stations,
      stationLength: stationLength ?? this.stationLength

    );
  }
}

class SecondPageViewModel extends ViewModel {
  final _stateSubject =
  BehaviorSubject<SecondPageState>.seeded(SecondPageState());
  Stream<SecondPageState> get state => _stateSubject;

  final _routesSubject = PublishSubject<AppRouteSpec>();
  Stream<AppRouteSpec> get routes => _routesSubject;

  SecondPageViewModel({required int countMay,required int countJune,required int countJuly, required int stationLength}) {
    _stateSubject.add(SecondPageState(countMay: countMay,countJune: countJune,countJuly: countJuly, stationLength: stationLength));
  }
  final List <String> groupNames = <String>[];
  List<bool> boolList = List.filled(99, true);
  List <Datarow> datarow = <Datarow>[];
  List <Station> station = <Station>[];
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

  Future<void> getStationInfo(context, String size, String pageNumber) async {
    final data = await Webservice().getStationInfo(size, pageNumber);

    if (data.length > 0) {

      station.clear();
      for(var i= 0; i<data.length; i++) {
        Station row = Station.fromJson(data[i]);
        station.add(row);
      }

      updateStateStation(station);






    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }

  Future<void> displayDialogStation(context, station) async {
    Station asema = station;
    final statioData = await Webservice().getStationData(asema.id);
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(asema.name),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.map),
                      Text(asema.osoite),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('Total Journeys starting: ',textScaleFactor: 0.8),
                      Text('${statioData[2][0]["n_dep"]}',textScaleFactor: 0.8),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('Total Journeys ending: ',textScaleFactor: 0.8),
                      Text('${statioData[3][0]["n_ret"]}',textScaleFactor: 0.8),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('Average distance starting (km): ',textScaleFactor: 0.8),
                      Text('${(statioData[0][0]["avg_dist_dep"]/1000).toStringAsFixed(2)}',textScaleFactor: 0.8),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('Average distance ending (km): ',textScaleFactor: 0.8),
                      Text('${(statioData[1][0]["avg_dist_ret"]/1000).toStringAsFixed(2)}',textScaleFactor: 0.8),
                    ],
                  )
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('close'),
                onPressed: () {
                  Navigator.of(context).pop();

                },
              ),
            ],
            actionsAlignment: MainAxisAlignment.spaceBetween
        );
      },
    );
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

  void updateStateStation(List<Station> data) {
    final state = _stateSubject.value;
    _stateSubject.add(
      state.copyWith(
        stations: data,
      ),
    );
  }

  @override
  void dispose() {
    _stateSubject.close();
    _routesSubject.close();
  }
}