import 'dart:convert';

import 'package:http/http.dart' as http;

class Webservice {
  final ip = 'http://10.0.2.2:3001';

  loadData() async {
    final response = await http.get(
      Uri.parse('$ip/bikeRoutes/load'),

    );
    if (response.statusCode == 200) {
        print("TESTI");
      return 1;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');

    }
  }




}