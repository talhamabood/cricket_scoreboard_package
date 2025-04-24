


import 'package:cricket_scoreboard/src/models/fixtures_list_models.dart';

import 'data_provider.dart';

class FixtureListRepository {
  final FixtureListDataProvider dataProvider = FixtureListDataProvider();


  Future<List<FixturesListModels>> getFixtures(int status) async {
    return await dataProvider.fetchFixturesList(status: status);
  }
}
