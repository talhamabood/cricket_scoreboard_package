import 'package:cricket_scoreboard/src/models/fixtures_list_models.dart';
import 'package:equatable/equatable.dart';

abstract class FixtureListState extends Equatable {
  const FixtureListState();

  @override
  List<Object?> get props => [];
}

class FixtureListInitial extends FixtureListState {}

class FixtureListLoading extends FixtureListState {}

class FixtureListLiveLoaded extends FixtureListState {
  final List<FixturesListModels> liveFixtures;

  const FixtureListLiveLoaded(this.liveFixtures);

  @override
  List<Object?> get props => [liveFixtures];
}

class FixtureListUpcomingLoaded extends FixtureListState {
  final List<FixturesListModels> upcomingFixtures;

  const FixtureListUpcomingLoaded(this.upcomingFixtures);

  @override
  List<Object?> get props => [upcomingFixtures];
}

class FixtureListRecentLoaded extends FixtureListState {
  final List<FixturesListModels> recentFixtures;

  const FixtureListRecentLoaded(this.recentFixtures);

  @override
  List<Object?> get props => [recentFixtures];
}

class FixtureListError extends FixtureListState {
  final String error;

  const FixtureListError(this.error);

  @override
  List<Object?> get props => [error];
}
