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
  @override
  void initState() {
    super.initState();
    listenToRoutesSpecs(viewModel.routes);
    btnController.stateStream.listen((value) {
      print(value);
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
                title: const Text('Login Page'),
                automaticallyImplyLeading: false,
              ),
              body: Center(

                  child: ListView(
                    children: <Widget>[
                      Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          child: const Text(
                            'My Awesome App',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                                fontSize: 30),
                          )),
                      Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          child: const Text(
                            'Sign in',
                            style: TextStyle(fontSize: 20),
                          )),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: TextField(
                          obscureText: true,
                          controller: passwordController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          //forgot password screen
                        },
                        child: const Text('Forgot Password',),
                      ),
                      Container(
                          height: 50,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: RoundedLoadingButton(
                            child: const Text('Login'),
                            controller: btnController,
                            onPressed: () {
                              print("""Hello ${state.loadOk}""");
                              viewModel.login(context,nameController.text,passwordController.text);
                            },
                          )
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text('New user?'),
                          TextButton(
                            child: const Text(
                              'Sign up',
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              btnController.reset();
                            },
                          )
                        ],
                      ),
                    ],
                  )
              )
          );



        }

    );
  }

}