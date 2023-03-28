import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/view.abs.dart';


import '../viewModel/second_view_model.dart';


class SecondPage extends View<SecondPageViewModel> {
  const SecondPage({required SecondPageViewModel viewModel, Key? key})
      : super.model(viewModel, key: key);

  @override
  _SecondPageState createState() => _SecondPageState(viewModel);
}

class _SecondPageState extends ViewState<SecondPage, SecondPageViewModel> {
  _SecondPageState(SecondPageViewModel viewModel) : super(viewModel);


  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;


  bool attend = false;
  List<bool> boolList = List.filled(99, true);
  List events = [];

  @override
  void initState() {
    super.initState();
    listenToRoutesSpecs(viewModel.routes);



    _selectedDay = _focusedDay;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return StreamBuilder<SecondPageState>(
      stream: viewModel.state,

      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();

        final state = snapshot.data!;
        try{
        }
        catch (e){
        }




        return MaterialApp(
          home: DefaultTabController(
            length: 3,
            child: Scaffold(

              appBar: AppBar(
                bottom: const TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.home)),
                    Tab(icon: Icon(Icons.group)),
                    Tab(icon: Icon(Icons.calendar_month)),
                  ],
                ),
                title: Text("""Hello ${state.loadOk}"""),
                automaticallyImplyLeading: false,
                actions: [

                  PopupMenuButton(
                    // add icon, by default "3 dot" icon
                    // icon: Icon(Icons.book)
                      itemBuilder: (context){
                        return [


                          PopupMenuItem<int>(
                            value: 1,
                            child: Text("Create new group"),
                          ),

                          PopupMenuItem<int>(
                            value: 4,
                            child: Text("Join a group"),
                          ),


                          PopupMenuItem<int>(
                            value: 2,
                            child: Text("Settings"),
                          ),

                          PopupMenuItem<int>(
                            value: 3,
                            child: Text("Logout"),
                          ),
                        ];
                      },
                      onSelected:(value) async{
                        if(value == 0){
                          print("My groups menu is selected.");


                        }
                        else if(value == 1){
                          print("Create new group menu is selected.");
                        }else if(value == 2){
                          print("Settings menu is selected.");
                        }else if(value == 3){
                          viewModel.logOut();
                          print("Logout menu is selected.");
                        }else if(value == 4){


                          print("Logout menu is selected.");
                        }
                      }
                  ),

                ],
              ),
              body: TabBarView(
                children: [
                  SingleChildScrollView(
                    child: ListBody(
                        children: <Widget>[
                          Text('My upcoming events', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 32.0),textAlign: TextAlign.center,),
                          Container(),
                        ]
                    ),
                  ),
                  SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text('My groups', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 32.0),textAlign: TextAlign.center,),
                          Container(),

                        ],
                      )
                  ),

                ],
              ),
            ),
          ),
        );
      },
    );
  }




}