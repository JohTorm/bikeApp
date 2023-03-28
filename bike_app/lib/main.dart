import 'package:bike_app/routes.dart';
import 'package:flutter/material.dart';

import 'package:bike_app/screens/login_screen.dart';

import 'package:provider/provider.dart';

import 'model/view.abs.dart';
void main() => runApp(App());
class App extends StatelessWidget {
  final _router = AppRouter();

  App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Movies MVVM Example",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      navigatorObservers: [routeObserver],
      initialRoute: '/',
      onGenerateRoute: _router.route,
    );


  }
}
