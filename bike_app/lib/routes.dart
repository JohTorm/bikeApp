
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

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SecondPage(
            viewModel: SecondPageViewModel(),
          ),
        );


      default:
        throw Exception('Route ${settings.name} not implemented');
    }
  }
}