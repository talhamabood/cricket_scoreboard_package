import 'dart:async';


import 'package:cricket_scoreboard/src/fixtures_list_cubit/repository.dart';
import 'package:cricket_scoreboard/src/fixtures_list_cubit/state.dart';
import 'package:cricket_scoreboard/src/notifiers/home_notifier.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FixtureListCubit extends Cubit<FixtureListState> {
  final FixtureListRepository repository = FixtureListRepository();

  FixtureListCubit() : super(FixtureListInitial());

  void fetchFixturesLiveList(int status1, HomeProvider homeProvider) async {
    try {
      emit(FixtureListLoading());
      // Timer.periodic(Duration(seconds: 15), (timer) async {

        final fixtures = await repository.getFixtures(status1);
      print('live=======================${fixtures.length}');
      homeProvider.getLiveFixtureListValue(fixtures);
        emit(FixtureListLiveLoaded(fixtures));

      // });

    } catch (e) {
      emit(FixtureListError(e.toString()));
    }
  }

  void fetchFixturesUpcomingList(int status2, HomeProvider homeProvider) async {
    try {
      emit(FixtureListLoading());
      final fixtures = await repository.getFixtures(status2);
      homeProvider.getUpcomingFixtureListValue(fixtures);
      print('upcoming=======================${fixtures.length}');

      emit(FixtureListUpcomingLoaded(fixtures));
    } catch (e) {
      emit(FixtureListError(e.toString()));
    }
  }

  void fetchFixturesRecentList(int status3, HomeProvider homeProvider) async {
    try {
      emit(FixtureListLoading());
      final fixtures = await repository.getFixtures(status3);
      homeProvider.getRecentFixtureListValue(fixtures);
      print('recent=======================${fixtures.length}');

      emit(FixtureListRecentLoaded(fixtures));
    } catch (e) {
      emit(FixtureListError(e.toString()));
    }
  }
}
