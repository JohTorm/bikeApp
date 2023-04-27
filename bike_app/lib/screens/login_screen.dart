import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:bike_app/viewModel/login_view_model.dart';
import '../model/view.abs.dart';

class LoginScreen extends View<LoginScreenViewModel> {
  LoginScreen({Key? key, required LoginScreenViewModel viewModel}) : super.model(LoginScreenViewModel(), key: key);

  static const String _title = 'Sample App';


  @override
  _LoginScreenState createState() => _LoginScreenState(viewModel);

}

class _LoginScreenState extends ViewState<LoginScreen, LoginScreenViewModel> {
  _LoginScreenState(LoginScreenViewModel viewModel) : super(viewModel);
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RoundedLoadingButtonController btnController = RoundedLoadingButtonController();

  bool loading = false;

  @override
  void initState() {
    super.initState();
    listenToRoutesSpecs(viewModel.routes);
    btnController.stateStream.listen((value) {
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LoginViewState>(
        stream: viewModel.state,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          final state = snapshot.data!;


          return Scaffold(
              appBar: AppBar(
                title: const Text('Bike Journey app'),
                automaticallyImplyLeading: false,
              ),
              body: Center(

                  child: ListView(
                    children: <Widget>[
                      Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          child: const Text(
                            'Bike route app',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                                fontSize: 30),
                          )),
                      Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          child: loading  ? Text(
                            'Loading data...',
                            style: TextStyle(fontSize: 20),
                          ) :
                          Text(
                            'Start with loading the data',
                            style: TextStyle(fontSize: 20),
                          )),
                      Container(
                          height: 50,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: RoundedLoadingButton(
                            child: const Text('Load data'),
                            controller: btnController,
                            onPressed: () {
                              setState(() {
                                loading = !loading;
                              });
                              viewModel.login(context,nameController.text,passwordController.text);
                            },
                          )
                      ),
                    ],
                  )
              )
          );



        }

    );
  }

}