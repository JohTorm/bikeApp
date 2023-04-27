
import 'package:bike_app/screens/login_screen.dart';
import 'package:bike_app/screens/second.dart';



import 'package:bike_app/viewModel/login_view_model.dart';
import 'package:bike_app/viewModel/second_view_model.dart';

import 'package:flutter/material.dart';




class AppRouter {
  Route<dynamic>? route(RouteSettings settings) {
    final arguments = settings.arguments as Map<String, dynamic>? ?? {};

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => LoginScreen(viewModel: LoginScreenViewModel()),
        );
      case '/second':

        final countMay = arguments['countMay'] as int;
        final countJune = arguments['countJune'] as int;
        final countJuly = arguments['countJuly'] as int;
        final stationLength = arguments['stationLength'] as int;


        if (countMay == null) {
          throw Exception('Route ${settings.name} requires a count');
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SecondPage(
            viewModel: SecondPageViewModel(countMay: countMay,countJune: countJune,countJuly: countJuly, stationLength: stationLength),
          ),
        );


      default:
        throw Exception('Route ${settings.name} not implemented');
    }
  }
}