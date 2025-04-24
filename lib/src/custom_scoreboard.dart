import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cricket_scoreboard/src/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'custom_home_card.dart';
import 'fixtures_list_cubit/cubit.dart';
import 'models/fixtures_list_models.dart';
import 'notifiers/home_notifier.dart';

class CustomScoreBoard extends StatefulWidget {

  const CustomScoreBoard({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomScoreBoard> createState() => _CustomScoreBoardState();
}

class _CustomScoreBoardState extends State<CustomScoreBoard> {
  List<FixturesListModels> totalList = [];
  Timer? _timer;
  late HomeProvider homeProvider;
  late FixtureListCubit fixtureListCubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homeProvider = HomeProvider();
    fixtureListCubit = FixtureListCubit();
    // final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fixtureListCubit.fetchFixturesUpcomingList(0, homeProvider);
      fixtureListCubit.fetchFixturesLiveList(1, homeProvider);
      fixtureListCubit.fetchFixturesRecentList(2, homeProvider);
    });

    // context.read<FixtureListCubit>().fetchFixturesUpcomingList(0, homeProvider);
    // context.read<FixtureListCubit>().fetchFixturesLiveList(1, homeProvider);

    // context.read<FixtureListCubit>().fetchFixturesRecentList(2, homeProvider);
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) {

      // context.read<FixtureListCubit>().fetchFixturesUpcomingList(0, homeProvider);
      // context.read<FixtureListCubit>().fetchFixturesLiveList(1, homeProvider);
      fixtureListCubit.fetchFixturesLiveList(1, homeProvider);

      // context.read<FixtureListCubit>().fetchFixturesRecentList(2, homeProvider);
    });
  }
  @override
  void dispose() {
    homeProvider.dispose(); // important to clean up
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // final homeProvider = Provider.of<HomeProvider>(context);

    final List<FixturesListModels> liveFixtureList =
    homeProvider.liveFixtureList.reversed.take(3).toList();
    final List<FixturesListModels> upcomingFixtureList =
    homeProvider.upcomingFixtureList.take(3).toList();
    final List<FixturesListModels> recentFixtureList =
    homeProvider.recentFixtureList.reversed.take(3).toList();

    print('totalList before=======================${totalList.length}');
    totalList = [
      ...liveFixtureList,
      ...upcomingFixtureList,
      ...recentFixtureList,
    ];
    print('totalList after=======================${totalList.length}');

    return BlocProvider.value(
      value: fixtureListCubit,
      child: ChangeNotifierProvider.value(
        value: homeProvider,
        child: Column(
          children: [
            totalList.isNotEmpty
                ? CarouselSlider.builder(
              itemCount: totalList.length,
              itemBuilder: (context, index, realIndex) {
                final FixturesListModels fixture =
                totalList[index];
            
                // Safety checks for team and innings data
                final Team? teamA = fixture.teams.isNotEmpty
                    ? fixture.teams[0]
                    : null;
                final Team? teamB = fixture.teams.isNotEmpty
                    ? fixture.teams[1]
                    : null;
            
                final List<Inning>? teamAInnings =
                teamA!.innings.isNotEmpty
                    ? teamA.innings.reversed.toList()
                    : null;
                final List<Inning>? teamBInnings =
                teamB!.innings.isNotEmpty
                    ? teamB.innings.reversed.toList()
                    : null;
                return CustomHomeCard(
                  teamA: teamA,
                  teamB: teamB,
                  teamAInnings: teamAInnings,
                  teamBInnings: teamBInnings,
                  fixture: fixture,
                  length: totalList.length,
                  homeProvider: homeProvider,
                );
              },
              options: CarouselOptions(
                  height: 250, // Adjust the height based on your design
                  viewportFraction:
                  1, // Adjust the fraction of the viewport shown
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval:
                  const Duration(seconds: 5),
                  enlargeStrategy:
                  CenterPageEnlargeStrategy.zoom,
                  enlargeCenterPage: true,
                  onPageChanged:
                      (value, carouselPageChangedReason) {
                    homeProvider.getCurrentIndexValue(value);
                  }),
            )
                : Center(
                child: CircularProgressIndicator(
                  color: ColorManager.primary,
                )),
          ],
        ),
      ),
    );
    // return Container(
    //   padding: const EdgeInsets.all(16),
    //   margin: const EdgeInsets.all(8),
    //   decoration: BoxDecoration(
    //     color: Colors.blueAccent,
    //     borderRadius: BorderRadius.circular(12),
    //   ),
    //   child: Text(
    //     text,
    //     style: const TextStyle(color: Colors.white, fontSize: 18),
    //   ),
    // );
  }
}
