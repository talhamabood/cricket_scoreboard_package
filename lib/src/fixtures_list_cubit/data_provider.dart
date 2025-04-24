import 'dart:convert';

import 'package:cricket_scoreboard/src/models/fixtures_list_models.dart';
import 'package:cricket_scoreboard/src/resources/string_manager.dart';
import 'package:http/http.dart' as http;

class FixtureListDataProvider {

  Future<List<FixturesListModels>> fetchFixturesList({required int status}) async {
    final response = await http.get(
      Uri.parse("${StringManager.baseUrl}/api/fixtures?status=$status"),
      headers: {
        'Content-Type': 'application/json',

      },
    );
    print(response.statusCode);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(response.body);
      if (data['success'] == true) {
        return (data['data'] as List)
            .map((fixtureJson) => FixturesListModels.fromJson(fixtureJson))
            .toList();
      } else {
        print(data['message']);
        print(response.body);

        throw Exception(data['message'] ?? "Failed to fetch fixtures");
      }
    } else {
      print(response.body);

      throw Exception("Failed to fetch fixtures with status code ${response.statusCode}");
    }

  }
}
