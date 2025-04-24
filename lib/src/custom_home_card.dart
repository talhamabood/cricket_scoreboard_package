import 'package:cricket_scoreboard/src/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'custom_home_card_widget.dart';
import 'models/fixtures_list_models.dart';
import 'notifiers/home_notifier.dart';

class CustomHomeCard extends StatelessWidget {
  final Team? teamA;
  final Team? teamB;
  final List<Inning>? teamAInnings;
  final List<Inning>? teamBInnings;
  final FixturesListModels fixture;
  final int length;
  const CustomHomeCard({
    super.key,
    this.teamA,
    this.teamB,
    this.teamAInnings,
    this.teamBInnings,
    required this.fixture,
    required this.length,
  });

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    return InkWell(
      onTap: () {
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 25),
        child: Container(
          width: 360,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: ColorManager.black.withOpacity(0.15),
                spreadRadius: 0,
                blurRadius: 18,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomHomeCardWidget(
                fixture: fixture,
                length: length,
                teamA: teamA,
                teamB: teamB,
                teamAInnings: teamAInnings,
                teamBInnings: teamBInnings,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  length, // Number of indicators
                  (index) => GestureDetector(
                    // onTap: () => _onIndicatorTapped(index),
                    child: Container(
                      height: 6,
                      width: 6,
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == homeProvider.currentIndex
                            ? ColorManager.primary
                            : ColorManager.primary.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
