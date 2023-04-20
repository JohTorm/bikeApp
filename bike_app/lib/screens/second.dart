import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/datarow.dart';
import '../model/station.dart';
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
  int page = 1;
  bool isButtonDisabled = false;
  List<bool> boolList = List.filled(99, true);
  List<Datarow> events = <Datarow>[];
  List<Station> stations = <Station>[];

  final List<Map<String, String>> listOfColumns = [
    {"departure": "AAAAAA", "return": "1", "depStatID": "sd","depStatName": "2", "retStatID": "1", "retStatName": "Yes","duration": "AAAAAA", "distance": "1"},
    {"departure": "AAAAAA", "return": "1", "depStatID": "sd","depStatName": "2", "retStatID": "1", "retStatName": "Yes","duration": "AAAAAA", "distance": "1"},
    {"departure": "AAAAAA", "return": "1", "depStatID": "sd","depStatName": "2", "retStatID": "1", "retStatName": "Yes","duration": "AAAAAA", "distance": "1"},
  ];


  @override
  void initState() {
    super.initState();
    listenToRoutesSpecs(viewModel.routes);
    viewModel.getTableData(context, "5", "10", "1");
    viewModel.getStationInfo(context, "10", "1");


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
        events.clear();
        events.addAll(state.datarows);
        stations.clear();
        stations.addAll(state.stations);





        return MaterialApp(
          home: DefaultTabController(
            length: 2,
            child: Scaffold(

              appBar: AppBar(
                bottom: const TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.home)),
                    Tab(icon: Icon(Icons.group))
                  ],
                ),
                title: Text("""Hello ${state.count}"""),
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
                          await viewModel.getTableData(context, "5", "20", "1");
                          events.addAll(state.datarows);
                          print(state.datarows[0].id + "  jee");
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
                          const Text('Bike Journeys', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 32.0),textAlign: TextAlign.center,),
                  Scrollbar(
                      thumbVisibility: true, trackVisibility: true,//always show scrollbar
                      thickness: 10, //width of scrollbar
                      radius: Radius.circular(10), //corner radius of scrollbar
                    interactive: true,
                      scrollbarOrientation: ScrollbarOrientation.bottom,
                      child:
                      SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child:    DataTable(
                        columns: [
                          DataColumn(label: Text('Departure station name')),
                          DataColumn(label: Text('Return station name')),
                          DataColumn(label: Text('Distance')),
                          DataColumn(label: Text('Duration'))
                        ],
                        rows:
                        events.map(
                          ((element) => DataRow(
                            cells: <DataCell>[
                              DataCell(Text(element.depStatName!)),
                              DataCell(Text(element.retStatName!)),
                              DataCell(Text(element.distance!)),
                              DataCell(Text(element.duration!))
                            ],
                          )),
                        ).toList(),
                      )
                    ),
                  ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('1-10 of ${state.count}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 12.0),textAlign: TextAlign.center,),
                              IconButton(
                                  onPressed: () {
                                    events.clear();
                                    viewModel.getTableData(context, "5", "10", "1");
                                    page = 1;
                                    events.addAll(state.datarows);
                                    print(state.count);
                                    setState(() {
                                    });
                                    print(state.count);

                                  },
                                  icon: const Icon(Icons.first_page)),
                              IconButton(
                                  disabledColor: Colors.grey,
                                  onPressed: page > 1 ? () {
                                          events.clear();
                                          viewModel.getTableData(context, "5", "10", page.toString());
                                          page--;
                                          events.addAll(state.datarows);
                                          setState(() {
                                          });
                                          } : null,
                                  icon: const Icon(Icons.chevron_left)),
                              Text('${page}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 12.0),textAlign: TextAlign.center,),
                              IconButton(
                                  onPressed: () {
                                    events.clear();
                                    viewModel.getTableData(context, "5", "10", page.toString());
                                    page++;
                                    events.addAll(state.datarows);
                                    setState(() {
                                    });
                                  },
                                  icon: const Icon(Icons.chevron_right)),
                              IconButton(
                                  onPressed: () {
                                    events.clear();
                                    page = (state.count/10).floor();
                                    print("${page}  AND  ${state.count % 10}");
                                    viewModel.getTableData(context, "5", (state.count % 10).toString(), page.toString());
                                    events.addAll(state.datarows);
                                    setState(() {
                                    });
                                  },
                                  icon: const Icon(Icons.last_page)),

                            ],
                          )
                        ]

                    ),
                  ),
                  SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text('Station information', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 32.0),textAlign: TextAlign.center,),
                          Scrollbar(
                            thumbVisibility: true, trackVisibility: true,//always show scrollbar
                            thickness: 10, //width of scrollbar
                            radius: Radius.circular(10), //corner radius of scrollbar
                            interactive: true,
                            scrollbarOrientation: ScrollbarOrientation.bottom,
                            child:
                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child:    DataTable(
                                  columns: [
                                    DataColumn(label: Text('Station name')),
                                    DataColumn(label: Text('Station id')),
                                  ],
                                  rows:
                                  stations.map(
                                    ((element) => DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text(element.nimi!)),
                                        DataCell(Text(element.id!)),
                                      ],
                                    )),
                                  ).toList(),
                                )
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('1-10 of ${state.stations.length}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 12.0),textAlign: TextAlign.center,),
                              IconButton(
                                  onPressed: () {
                                    stations.clear();
                                    viewModel.getStationInfo(context,"10", "1");
                                    page = 1;
                                    stations.addAll(state.stations);
                                    print(state.count);
                                    setState(() {
                                    });
                                    print(state.count);

                                  },
                                  icon: const Icon(Icons.first_page)),
                              IconButton(
                                  disabledColor: Colors.grey,
                                  onPressed: page > 1 ? () {
                                    stations.clear();
                                    viewModel.getStationInfo(context,"10", page.toString());
                                    page--;
                                    stations.addAll(state.stations);
                                    setState(() {
                                    });
                                  } : null,
                                  icon: const Icon(Icons.chevron_left)),
                              Text('${page}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 12.0),textAlign: TextAlign.center,),
                              IconButton(
                                  onPressed: () {
                                    stations.clear();
                                    viewModel.getStationInfo(context,"10", page.toString());
                                    page++;
                                    stations.addAll(state.stations);
                                    setState(() {
                                    });
                                  },
                                  icon: const Icon(Icons.chevron_right)),
                              IconButton(
                                  onPressed: () {
                                    stations.clear();
                                    page = (state.stations.length/10).floor();
                                    print("${page}  AND  ${state.count % 10}");
                                    viewModel.getStationInfo(context,"10", page.toString());
                                    stations.addAll(state.stations);
                                    setState(() {
                                    });
                                  },
                                  icon: const Icon(Icons.last_page)),

                            ],
                          )

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