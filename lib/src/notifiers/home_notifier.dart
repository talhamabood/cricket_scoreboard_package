
import 'package:cricket_scoreboard/src/models/fixtures_list_models.dart';
import 'package:flutter/foundation.dart';

class HomeProvider extends ChangeNotifier {
  String? _currentVideoTitle;

  List<FixturesListModels> _liveFixtureList = [];
  List<FixturesListModels> _upcomingFixtureList = [];
  List<FixturesListModels> _recentFixtureList = [];
  int _currentIndex = 0; // Tracks the active indicator


  void getCurrentVideoTitleValue(value) {
    _currentVideoTitle = value;
    notifyListeners();
  }





  void getCurrentIndexValue(value) {
    _currentIndex = value;
    notifyListeners();
  }

  void getLiveFixtureListValue(value) {
    _liveFixtureList = value;
    notifyListeners();
  }

  void getUpcomingFixtureListValue(value) {
    _upcomingFixtureList = value;
    notifyListeners();
  }

  void getRecentFixtureListValue(value) {
    _recentFixtureList = value;
    notifyListeners();
  }

  List<FixturesListModels> get upcomingFixtureList => _upcomingFixtureList;
  List<FixturesListModels> get liveFixtureList => _liveFixtureList;
  List<FixturesListModels> get recentFixtureList => _recentFixtureList;
  String? get currentVideoTitle => _currentVideoTitle;

  int get currentIndex => _currentIndex;
}
