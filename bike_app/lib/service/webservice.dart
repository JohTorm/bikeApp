import 'dart:convert';

import 'package:http/http.dart' as http;

class Webservice {
  final ip = 'http://10.0.2.2:3001';

  loadData() async {
    final response = await http.get(
      Uri.parse('$ip/bikeRoutes/size'),

    );
    if (response.statusCode == 200) {
      var sizeBikeJourneys = jsonDecode(response.body)[0];
        print("TESTI $sizeBikeJourneys");
      var sizeStationInfo = jsonDecode(response.body)[1];
      print("TESTI $sizeStationInfo");
      return [sizeBikeJourneys, sizeStationInfo];
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');

    }
  }

  getDataForTable(String month, String size, String pageNumber) async {
    final response = await http.get(
      Uri.parse('$ip/bikeRoutes/$month-$size-$pageNumber'),

    );
    if (response.statusCode == 200) {
      //print(response.body);
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');

    }
  }

  getStationInfo(String size, String pageNumber) async {
    final response = await http.get(
      Uri.parse('$ip/station/$size-$pageNumber'),

    );
    if (response.statusCode == 200) {
      //print(response.body);
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');

    }
  }


}