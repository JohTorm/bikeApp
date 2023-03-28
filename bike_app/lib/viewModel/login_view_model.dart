import 'package:bike_app/model/view_model.abs.dart';
import 'package:flutter/material.dart';

import 'package:rxdart/rxdart.dart';

import '../model/app_routes.dart';
import '../service/webservice.dart';


class LoginViewState {
  final bool loadOk;
  final String password;
  final int count;
  LoginViewState({this.loadOk = false, this.password = 'jee', this.count = 0});

  LoginViewState copyWith({
    bool? loadOk,
    String? password,
    int? count,

  }) {
    return LoginViewState(
      loadOk: loadOk ?? this.loadOk,
      password: password ?? this.password,
      count: count ?? this.count,
    );
  }


}


class LoginScreenViewModel extends ViewModel {
  final _stateSubject = BehaviorSubject<LoginViewState>.seeded(LoginViewState());
  Stream<LoginViewState> get state => _stateSubject;

  final _routesSubject = PublishSubject<AppRouteSpec>();
  Stream<AppRouteSpec> get routes => _routesSubject;

  Future<void> login(context, String email, String pwd) async {
    final loadData = await Webservice().loadData();

    if(loadData == 1) {
      updateState(true);


      _routesSubject.add(
        AppRouteSpec(
          name: '/second',
          arguments: {
            'loadOk': _stateSubject.value.loadOk,
            'email': email
          },
        ),
      );
    } else {
      displayDialog(context);
    }
  }

  Future<void> displayDialog(context) async {

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invalid login information'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[

                Text('The email or password you gave was invalid')


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
        );
      },
    );
  }

  void signup() {
    _routesSubject.add(
      AppRouteSpec(
        name: '/signup',
      ),
    );

  }



  void updateState(bool newLoadOk) {
    final state = _stateSubject.value;
    _stateSubject.add(
      state.copyWith(
        loadOk: newLoadOk,
      ),
    );
  }

  @override
  void dispose() {
    _stateSubject.close();
  }
}