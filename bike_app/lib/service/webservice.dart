import 'dart:convert';

import 'package:http/http.dart' as http;

class Webservice {
  final ip = 'http://10.0.2.2:3001';

  loadData() async {
    final response = await http.get(
      Uri.parse('$ip/bikeRoutes/load'),

    );
    if (response.statusCode == 200) {
      var sizeBikeJourneysMay = jsonDecode(response.body)["sizeBikeJourneyMay"];
      var sizeBikeJourneysJune = jsonDecode(response.body)["sizeBikeJourneyJune"];
      var sizeBikeJourneysJuly = jsonDecode(response.body)["sizeBikeJourneyJuly"];
      var sizeStationInfo = jsonDecode(response.body)["sizeStationInfo"];
      return [sizeBikeJourneysMay,sizeBikeJourneysJune,sizeBikeJourneysJuly, sizeStationInfo];
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
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');

    }
  }

  getStationData(String id) async {
    final response = await http.get(
      Uri.parse('$ip/station/info$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');

    }
  }


}