
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cricket_scoreboard/src/resources/color_manager.dart';
import 'package:cricket_scoreboard/src/resources/font_manager.dart';
import 'package:cricket_scoreboard/src/resources/string_manager.dart';
import 'package:cricket_scoreboard/src/timer_cubit/cubit.dart';
import 'package:cricket_scoreboard/src/timer_cubit/state.dart';
import 'package:cricket_scoreboard/src/upcoming_detail_match_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'custom_text_widget.dart';
import 'home_utils.dart';
import 'models/fixtures_list_models.dart';

class CustomHomeCardWidget extends StatefulWidget {
  final Team? teamA;
  final Team? teamB;
  final List<Inning>? teamAInnings;
  final List<Inning>? teamBInnings;
  final FixturesListModels fixture;
  final int length;
  const CustomHomeCardWidget(
      {super.key,
      this.teamA,
      this.teamB,
      this.teamAInnings,
      this.teamBInnings,
      required this.fixture,
      required this.length});

  @override
  State<CustomHomeCardWidget> createState() => _CustomHomeCardWidgetState();
}

class _CustomHomeCardWidgetState extends State<CustomHomeCardWidget> {
  late DateTime matchDateTime;
  String displayDate = '';
  String displayTime = '';
  int? remainingTime;
  bool shouldStartTimer = false;

  @override
  void initState() {
    super.initState();
    _calculateMatchTime();
  }
  void _calculateMatchTime() {
    String scheduleDate = widget.fixture.scheduleDate;
    String scheduledTime = widget.fixture.scheduledTime;

    matchDateTime = DateTime.parse('$scheduleDate $scheduledTime');
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime tomorrow = today.add(const Duration(days: 1));

    if (matchDateTime.day == today.day) {
      if (matchDateTime.isAfter(now) &&
          matchDateTime.difference(now).inHours <= 6) {
        // If today and less than 6 hours away
        displayDate = 'Starts in:';
        remainingTime = matchDateTime.difference(now).inSeconds;
        // context.read<TimerCubit>().endTimer();
        // context.read<TimerCubit>().startWorkout(remainingTime!);
        shouldStartTimer = true;
      } else {
        displayDate = 'Today';
        displayTime = UpcomingDetailMatchUtils().formatApiTime(scheduledTime);
      }
    } else if (matchDateTime.day == tomorrow.day) {
      displayDate = 'Tomorrow';
      displayTime = UpcomingDetailMatchUtils().formatApiTime(scheduledTime);
    } else {
      displayDate = UpcomingDetailMatchUtils().formatApiDate(scheduleDate);
      displayTime = UpcomingDetailMatchUtils().formatApiTime(scheduledTime);
    }
    // Start timer if required
    if (shouldStartTimer && remainingTime != null) {
      context.read<TimerCubit>().endTimer();
      context.read<TimerCubit>().startWorkout(remainingTime!);
    }
    setState(() {}); // Update UI after calculations
  }


  @override
  Widget build(BuildContext context) {
    String fixtureTitle = widget.fixture.seriesName;
    String fixtureTeamAName = widget.teamA!.teamName.toUpperCase();
    String fixtureTeamAImage = widget.teamA!.flagImageName;
    String fixtureTeamBName = widget.teamB!.teamName.toUpperCase();
    String fixtureTeamBImage = widget.teamB!.flagImageName;
    Widget? card;
    if (widget.fixture.status == 0 || widget.fixture.status == 1) {

      // String scheduleDate = widget.fixture.scheduleDate;
      // String scheduledTime = widget.fixture.scheduledTime;

      // String scheduleDate = '2024-12-15';
      // String scheduledTime = '14:45:00';

      // matchDateTime = DateTime.parse('$scheduleDate $scheduledTime');
      // DateTime now = DateTime.now();
      // DateTime today = DateTime(now.year, now.month, now.day);
      // DateTime tomorrow = today.add(const Duration(days: 1));
      //
      // if (matchDateTime.day == today.day) {
      //   if (matchDateTime.isAfter(now) &&
      //       matchDateTime.difference(now).inHours <= 6) {
      //     // If today and less than 6 hours away
      //     displayDate = StringManager.startsIn;
      //     remainingTime = matchDateTime.difference(now).inSeconds;
      //     context.read<TimerCubit>().endTimer();
      //     context.read<TimerCubit>().startWorkout(remainingTime);
      //     // showTimer = true;
      //     // startTimer();
      //   } else {
      //     context.read<TimerCubit>().endTimer();
      //     displayDate = 'Today';
      //     displayTime = UpcomingDetailMatchUtils().formatApiTime(scheduledTime);
      //   }
      // } else if (matchDateTime.day == tomorrow.day &&
      //     matchDateTime.month == tomorrow.month &&
      //     matchDateTime.year == tomorrow.year) {
      //   context.read<TimerCubit>().endTimer();
      //
      //   // If tomorrow
      //   displayDate = 'Tomorrow';
      //   displayTime = UpcomingDetailMatchUtils().formatApiTime(scheduledTime);
      // } else {
      //   // Default full date format
      //   context.read<TimerCubit>().endTimer();
      //   displayDate = UpcomingDetailMatchUtils().formatApiDate(scheduleDate);
      //   displayTime = UpcomingDetailMatchUtils().formatApiTime(scheduledTime);
      //   print('displayTime==============$displayTime');
      //   print('displayDate==============$displayDate');
      // }
      card = Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                decoration: BoxDecoration(
                  color: ColorManager.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: CustomTextWidget(
                    text: 'Upcoming',
                    fontSize: FontSize.s12,
                    fontWeight: FontWeightManager.medium,
                    color: ColorManager.primary,
                    // fontFamily: StringManager.zongArcaHeavy,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  CachedNetworkImage(
                    imageUrl: '${StringManager.flagsBaseUrl}$fixtureTeamAImage',
                    height: 32,
                    width: 44,
                    fit: BoxFit.fill,
                    placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                      color: ColorManager.primary,
                    )),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  SizedBox(
                    width: 78,
                    child: CustomTextWidget(
                      text: fixtureTeamAName,
                      fontSize: FontSize.s12,
                      fontWeight: FontWeightManager.medium,
                      color: ColorManager.black,
                      fontFamily: StringManager.zongArcaBold,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  CustomTextWidget(
                    text: displayDate,
                    fontSize: FontSize.s13,
                    fontWeight: FontWeightManager.regular,
                    color: ColorManager.black.withOpacity(0.6),
                    fontFamily: StringManager.zongArcaBold,
                  ),

                  shouldStartTimer
                      ? BlocBuilder<TimerCubit, TimerState>(
                    builder: (context, state) {
                      if (state is TimerInProgressState) {
                        return CustomTextWidget(
                          text:
                          '${(state.elapsed ~/ 3600).toString().padLeft(2, '0')}h : ${((state.elapsed % 3600) ~/ 60).toString().padLeft(2, '0')}m',
                          fontSize: FontSize.s24,
                          fontWeight: FontWeightManager.semiBold,
                          color: ColorManager.black,
                          fontFamily: StringManager.zongArcaHeavy,
                        );
                      } else {
                        return CustomTextWidget(
                          text: displayTime,
                          fontSize: FontSize.s24,
                          fontWeight: FontWeightManager.semiBold,
                          color: ColorManager.black,
                          fontFamily: StringManager.zongArcaHeavy,
                        );
                      }
                    },
                  )
                      : CustomTextWidget(
                    text: displayTime,
                    fontSize: FontSize.s24,
                    fontWeight: FontWeightManager.semiBold,
                    color: ColorManager.black,
                    fontFamily: StringManager.zongArcaHeavy,
                  ),
                  // BlocBuilder<TimerCubit, TimerState>(
                  //     builder: (context, state) {
                  //   if (state is TimerInProgressState) {
                  //     return CustomTextWidget(
                  //       text:
                  //           '0${state.elapsed ~/ 3600}h : ${(state.elapsed % 3600) ~/ 60}m',
                  //       // text: displayTime,
                  //       fontSize: FontSize.s24,
                  //       fontWeight: FontWeightManager.semiBold,
                  //       color: ColorManager.black,
                  //       fontFamily: StringManager.telenorMedium,
                  //     );
                  //   } else {
                  //     return CustomTextWidget(
                  //       text: displayTime,
                  //       fontSize: FontSize.s24,
                  //       fontWeight: FontWeightManager.semiBold,
                  //       color: ColorManager.black,
                  //       fontFamily: StringManager.telenorMedium,
                  //     );
                  //   }
                  // }),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  CachedNetworkImage(
                    imageUrl: '${StringManager.flagsBaseUrl}$fixtureTeamBImage',
                    height: 32,
                    width: 44,
                    fit: BoxFit.fill,
                    placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                      color: ColorManager.primary,
                    )),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: 78,
                    child: CustomTextWidget(
                      text: fixtureTeamBName,
                      fontSize: FontSize.s12,
                      fontWeight: FontWeightManager.medium,
                      color: ColorManager.black,
                      fontFamily: StringManager.zongArcaBold,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          CustomTextWidget(
            text: fixtureTitle,
            fontSize: FontSize.s13,
            fontWeight: FontWeightManager.medium,
            color: ColorManager.black.withOpacity(0.6),
            fontFamily: StringManager.zongArcaHeavy,
          ),
        ],
      );
    }
    else if (widget.fixture.status == 2 || widget.fixture.status == 4) {
      String? teamARuns;
      String? teamAWkts;
      String? teamAOvers;
      String? teamABall;
      String? teamBRuns;
      String? teamBWkts;
      String? teamBOvers;
      String? teamBBall;
      Team? activeTeam;
      // Inning? activeInning;
      String? activeTeamRuns;
      String? activeTeamOvers;
      String? activeTeamBall;
      String matchDescription = '';
      double rrr = 0.00;
      double crr = 0.00;

      if (widget.fixture.seriesTypeId == 3) {
        for (var team in widget.fixture.teams) {
          for (var inning in team.innings) {
            if (inning.inningActive == true) {
              activeTeam = team;
              // activeInning = inning;
              break; // Exit loop once active inning team is found
            }
          }
        }

        if (activeTeam != null) {
          final List<Inning>? activeInning = activeTeam.innings.isNotEmpty
              ? activeTeam.innings.reversed.toList()
              : null;
          activeTeamRuns = activeInning![0].totalRuns.toString();
          activeTeamOvers = activeInning[0].oversBowled.toString();
          activeTeamBall = activeInning[0].ballsBowled.toString();
          crr = HomeUtils().calculateCurrentRunRate(
              int.parse(activeTeamRuns ?? '0'),
              int.parse(activeTeamOvers ?? '0') +
                  (int.parse(activeTeamBall ?? '0') / 6));
        }

        if (widget.fixture.tossWinnerTeamId != null &&
            widget.fixture.firstBattingTeamId != null) {
          final Team toosWinningTeam = widget.fixture.teams.firstWhere(
            (inning) => inning.teamId == widget.fixture.tossWinnerTeamId,
          );

          final Team firstBattingTeam = widget.fixture.teams.firstWhere(
            (inning) => inning.teamId == widget.fixture.firstBattingTeamId,
          );
          Team? nonActiveTeam;
          if (activeTeam != null) {
            nonActiveTeam = widget.fixture.teams.firstWhere(
              (inning) => inning.teamId != activeTeam!.teamId,
            );
          }
          if (widget.fixture.matchResult == null) {
            if (activeTeam != null && nonActiveTeam != null) {
              if (activeTeam.innings.length <= 1) {
                if (activeTeam.teamId == firstBattingTeam.teamId) {
                  String decidedTo = '';
                  if (toosWinningTeam.teamId == firstBattingTeam.teamId) {
                    decidedTo = 'bat';
                  } else {
                    decidedTo = 'bowl';
                  }

                  matchDescription =
                      '${toosWinningTeam.teamName} won the toss and decided to $decidedTo';
                } else {
                  int activeTeamRuns = 0;
                  int nonActiveTeamRuns = 0;

                  nonActiveTeamRuns = nonActiveTeam.innings[0].totalRuns;
                  activeTeamRuns = activeTeam.innings[0].totalRuns;
                  int trail = nonActiveTeamRuns - activeTeamRuns;
                  matchDescription =
                      '${activeTeam.teamName} trail by $trail runs';

                  if (trail <= 0) {
                    int lead = activeTeamRuns - nonActiveTeamRuns;

                    matchDescription =
                        '${activeTeam.teamName} lead by $lead runs';
                  }
                }
              } else {
                if (activeTeam.teamId == firstBattingTeam.teamId) {
                  int activeTeamRuns1 = 0;
                  int activeTeamRuns2 = 0;
                  int nonActiveTeamRuns1 = 0;
                  nonActiveTeamRuns1 = nonActiveTeam.innings[0].totalRuns;
                  activeTeamRuns1 = activeTeam.innings[0].totalRuns;
                  activeTeamRuns2 = activeTeam.innings[1].totalRuns;

                  int trail =
                      activeTeamRuns1 - nonActiveTeamRuns1 + activeTeamRuns2;

                  if (trail < 0) {
                    matchDescription =
                        '${activeTeam.teamName} trail by ${trail.abs()} runs';
                  } else if (trail > 0) {
                    matchDescription =
                        '${activeTeam.teamName} lead by $trail runs';
                  }
                } else if (activeTeam.teamId != firstBattingTeam.teamId) {
                  int activeTeamRuns1 = 0;
                  int activeTeamRuns2 = 0;
                  int nonActiveTeamRuns1 = 0;
                  int nonActiveTeamRuns2 = 0;

                  nonActiveTeamRuns1 = nonActiveTeam.innings[0].totalRuns;
                  nonActiveTeamRuns2 = nonActiveTeam.innings[1].totalRuns;
                  activeTeamRuns1 = activeTeam.innings[0].totalRuns;
                  activeTeamRuns2 = activeTeam.innings[1].totalRuns;

                  int target = (nonActiveTeamRuns1 + nonActiveTeamRuns2) -
                      activeTeamRuns1 +
                      1;
                  int remainingRuns = target - activeTeamRuns2;

                  matchDescription =
                      '${activeTeam.teamName} need $remainingRuns runs to win';
                }
              }
            }
          } else {
            matchDescription = widget.fixture.matchResult;
          }
        }
        if (widget.teamAInnings != null) {
            teamARuns = widget.teamAInnings![0].totalRuns.toString();
            teamAWkts = widget.teamAInnings![0].wicketsLost.toString();
            teamAOvers = widget.teamAInnings![0].oversBowled.toString();
            teamABall = widget.teamAInnings![0].ballsBowled.toString();
        }

        if (widget.teamBInnings != null) {
            teamBRuns = widget.teamBInnings![0].totalRuns.toString();
            teamBWkts = widget.teamBInnings![0].wicketsLost.toString();
            teamBOvers = widget.teamBInnings![0].oversBowled.toString();
            teamBBall = widget.teamBInnings![0].ballsBowled.toString();
        }

        card = Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                Container(),
                CustomTextWidget(
                  text: fixtureTitle,
                  fontSize: FontSize.s12,
                  fontWeight: FontWeightManager.regular,
                  color: ColorManager.black.withOpacity(0.6),
                  fontFamily: StringManager.zongArcaBold,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 9, vertical: 0),
                  decoration: BoxDecoration(
                    color: ColorManager.red,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: CustomTextWidget(
                      text: 'LIVE',
                      fontSize: FontSize.s12,
                      fontWeight: FontWeightManager.medium,
                      color: ColorManager.white,
                      fontFamily: StringManager.zongArcaHeavy,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl:
                              '${StringManager.flagsBaseUrl}$fixtureTeamAImage',
                          height: 32,
                          width: 44,
                          fit: BoxFit.fill,
                          placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                            color: ColorManager.primary,
                          )),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        SizedBox(
                          width: 78,
                          child: CustomTextWidget(
                            text: fixtureTeamAName,
                            // text: 'INDIA',
                            fontSize: FontSize.s12,
                            fontWeight: FontWeightManager.medium,
                            color: ColorManager.black,
                            fontFamily: StringManager.zongArcaBold,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    widget.teamAInnings != null
                        ? widget.teamAInnings!.length > 1
                            ? SizedBox(
                                width: 92,
                                child: ListView.builder(
                                    itemCount: widget.teamAInnings?.length,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      String separator = '';
                                      if (index != 0) {
                                        separator = '& ';
                                      }
                                      Widget? currentInningOver;

                                      if (activeTeam?.teamId == widget.teamA?.teamId) {
                                        if (index == 0) {
                                          currentInningOver = CustomTextWidget(
                                            text:
                                                '(${teamAOvers ?? ''}.${teamABall ?? ''})',
                                            fontSize: FontSize.s11,
                                            fontWeight:
                                                FontWeightManager.regular,
                                            color: ColorManager.black
                                                .withOpacity(0.6),
                                            fontFamily: StringManager.zongArcaBold,
                                          );
                                        }
                                      }

                                      return Row(
                                        children: [
                                          SizedBox(
                                            width: 4,
                                          ),
                                          CustomTextWidget(
                                            text:
                                                '$separator${widget.teamAInnings![index].totalRuns ?? ''}/${widget.teamAInnings![index].wicketsLost ?? ''}',
                                            fontSize: index == 0
                                                ? FontSize.s15
                                                : FontSize.s13,
                                            fontWeight: index == 0
                                                ? FontWeightManager.semiBold
                                                : FontWeightManager.medium,
                                            color: ColorManager.black,
                                            fontFamily: index == 0
                                                ? StringManager.zongArcaHeavy
                                                : StringManager.zongArcaBold,
                                          ),
                                          currentInningOver ?? Container(),
                                        ],
                                      );
                                    }),
                              )
                            : Row(
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomTextWidget(
                                        text:
                                            '${teamARuns ?? ''}/${teamAWkts ?? ''}',
                                        fontSize: FontSize.s16,
                                        fontWeight: FontWeightManager.semiBold,
                                        color: ColorManager.black,
                                        fontFamily: StringManager.zongArcaHeavy,
                                      ),
                                      CustomTextWidget(
                                        text:
                                            '(${teamAOvers ?? ''}.${teamABall ?? ''})',
                                        fontSize: FontSize.s13,
                                        fontWeight: FontWeightManager.regular,
                                        color: ColorManager.black.withOpacity(0.6),
                                        fontFamily: StringManager.zongArcaBold,
                                      ),
                                    ],
                                  ),
                              ],
                            )
                        : Container(),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    widget.teamBInnings != null
                        ? widget.teamBInnings!.length > 1
                            ? SizedBox(
                                width: 92,
                                child: ListView.builder(
                                    itemCount: widget.teamBInnings?.length,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      String separator = '';
                                      if (index != 0) {
                                        separator = '& ';
                                      }
                                      Widget? currentInningOver;
                                      if (activeTeam?.teamId == widget.teamB?.teamId) {
                                        if (index == 0) {
                                          currentInningOver = Row(
                                            children: [
                                              SizedBox(
                                                width: 2,
                                              ),
                                              CustomTextWidget(
                                                text:
                                                    "(${widget.teamBInnings![0].oversBowled ?? ''}.${widget.teamBInnings![0].ballsBowled ?? ''})",
                                                fontSize: FontSize.s12,
                                                fontWeight:
                                                    FontWeightManager.regular,
                                                color: ColorManager.black
                                                    .withOpacity(0.6),
                                                fontFamily:
                                                    StringManager.zongArcaBold,
                                              ),
                                            ],
                                          );
                                        }
                                      }
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          CustomTextWidget(
                                            text:
                                                '$separator${widget.teamBInnings![index].totalRuns ?? ''}/${widget.teamBInnings![index].wicketsLost ?? ''}',
                                            // '200/10',

                                            fontSize: index == 0
                                                ? FontSize.s15
                                                : FontSize.s13,
                                            fontWeight: index == 0
                                                ? FontWeightManager.semiBold
                                                : FontWeightManager.medium,
                                            color: ColorManager.black,
                                            fontFamily: index == 0
                                                ? StringManager.zongArcaHeavy
                                                : StringManager.zongArcaBold,
                                          ),
                                          currentInningOver ?? Container(),
                                          SizedBox(
                                            width: 1,
                                          ),
                                        ],
                                      );
                                    }),
                              )
                            : Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      CustomTextWidget(
                                        text:
                                            '${teamBRuns ?? ''}/${teamBWkts ?? ''}',
                                        fontSize: FontSize.s16,
                                        fontWeight: FontWeightManager.semiBold,
                                        color: ColorManager.black,
                                        fontFamily: StringManager.zongArcaHeavy,
                                      ),
                                      CustomTextWidget(
                                        text:
                                            '(${teamBOvers ?? ''}.${teamBBall ?? ''})',
                                        fontSize: FontSize.s13,
                                        fontWeight: FontWeightManager.regular,
                                        color:
                                            ColorManager.black.withOpacity(0.6),
                                        fontFamily: StringManager.zongArcaBold,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                ],
                              )
                        : Container(),
                    Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl:
                              '${StringManager.flagsBaseUrl}$fixtureTeamBImage',
                          height: 32,
                          width: 44,
                          fit: BoxFit.fill,
                          placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                            color: ColorManager.primary,
                          )),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: 78,
                          child: CustomTextWidget(
                            // text: 'PAKISTAN',
                            text: fixtureTeamBName,
                            fontSize: FontSize.s12,
                            fontWeight: FontWeightManager.medium,
                            color: ColorManager.black,
                            fontFamily: StringManager.zongArcaBold,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            CustomTextWidget(
              text: matchDescription,
              fontSize: FontSize.s13,
              fontWeight: FontWeightManager.regular,
              color: ColorManager.black.withOpacity(0.6),
              fontFamily: StringManager.zongArcaBold,
            ),
            CustomTextWidget(
              text: 'CRR: ${crr.toStringAsFixed(2)}',
              fontSize: FontSize.s12,
              fontWeight: FontWeightManager.regular,
              color: ColorManager.black.withOpacity(0.6),
              fontFamily: StringManager.zongArcaBold,
            ),
          ],
        );
      }
      else {
        if (widget.teamAInnings != null) {
          if (widget.teamAInnings!.length <= 1) {
            teamARuns = widget.teamAInnings![0].totalRuns.toString();
            teamAWkts = widget.teamAInnings![0].wicketsLost.toString();
            teamAOvers = widget.teamAInnings![0].oversBowled.toString();
            teamABall = widget.teamAInnings![0].ballsBowled.toString();
          }
        }

        if (widget.teamBInnings != null) {
          if (widget.teamBInnings!.length <= 1) {
            teamBRuns = widget.teamBInnings![0].totalRuns.toString();
            teamBWkts = widget.teamBInnings![0].wicketsLost.toString();
            teamBOvers = widget.teamBInnings![0].oversBowled.toString();
            teamBBall = widget.teamBInnings![0].ballsBowled.toString();
          }
        }

        for (var team in widget.fixture.teams) {
          for (var inning in team.innings) {
            if (inning.inningActive == true) {
              activeTeam = team;
              // activeInning = inning;
              break; // Exit loop once active inning team is found
            }
          }
        }

        if (activeTeam != null) {
          final List<Inning>? activeInning = activeTeam.innings.isNotEmpty
              ? activeTeam.innings.reversed.toList()
              : null;
          activeTeamRuns = activeInning![0].totalRuns.toString();
          activeTeamOvers = activeInning[0].oversBowled.toString();
          activeTeamBall = activeInning[0].ballsBowled.toString();
          crr = HomeUtils().calculateCurrentRunRate(
              int.parse(activeTeamRuns ?? '0'),
              int.parse(activeTeamOvers ?? '0') +
                  (int.parse(activeTeamBall ?? '0') / 6));
        }

        if (widget.fixture.tossWinnerTeamId != null &&
            widget.fixture.firstBattingTeamId != null) {
          final Team toosWinningTeam = widget.fixture.teams.firstWhere(
            (inning) => inning.teamId == widget.fixture.tossWinnerTeamId,
          );

          final Team firstBattingTeam = widget.fixture.teams.firstWhere(
            (inning) => inning.teamId == widget.fixture.firstBattingTeamId,
          );
          Team? nonActiveInningTeam;
          if (activeTeam != null) {
            nonActiveInningTeam = widget.fixture.teams.firstWhere(
              (inning) => inning.teamId != activeTeam!.teamId,
            );
          }

          if (activeTeam != null && nonActiveInningTeam != null) {
            if (activeTeam.teamId != widget.fixture.firstBattingTeamId) {
              int targetRuns = 0;
              int runsScored = 0;
              int totalOvers = 0;
              double oversFaced = 0;

              targetRuns = nonActiveInningTeam.innings[0].totalRuns + 1;
              runsScored = activeTeam.innings[0].totalRuns;
              totalOvers = activeTeam.innings[0].maxOvers;
              oversFaced = int.parse(
                      activeTeam.innings[0].oversBowled.toString() ?? '0') +
                  (int.parse(
                          activeTeam.innings[0].ballsBowled.toString() ?? '0') /
                      6);
              rrr = HomeUtils().calculateRequiredRunRate(
                  targetRuns, runsScored, totalOvers, oversFaced);
            }
          }

          if (widget.fixture.matchResult == null) {
            if (activeTeam != null && nonActiveInningTeam != null) {
              if (activeTeam.teamId != widget.fixture.firstBattingTeamId) {
                int targetRuns;
                targetRuns = nonActiveInningTeam.innings[0].totalRuns + 1;
                int remainingRuns =
                    targetRuns - activeTeam.innings[0].totalRuns;
                int maxOvers = activeTeam.innings[0].maxOvers;
                int ballsBowled = (activeTeam.innings[0].oversBowled * 6) +
                    activeTeam.innings[0].ballsBowled;
                int totalBalls = maxOvers * 6;
                int remainingBalls = totalBalls - ballsBowled;
                int remainingOvers = remainingBalls ~/ 6;
                int remainingFractionalBalls = remainingBalls % 6;
                matchDescription =
                    '${activeTeam.teamName} need $remainingRuns runs in $remainingOvers.$remainingFractionalBalls overs to win';
              } else {
                //PAKISTAN won the toss and decided to bowl.
                String decidedTo = '';
                if (toosWinningTeam.teamId == firstBattingTeam.teamId) {
                  decidedTo = 'bat';
                } else {
                  decidedTo = 'bowl';
                }

                matchDescription =
                    '${toosWinningTeam.teamName} won the toss and decided to $decidedTo';
              }
            }
          } else {
            matchDescription = widget.fixture.matchResult;
          }
        }

        card = Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                Container(),
                CustomTextWidget(
                  text: fixtureTitle,
                  fontSize: FontSize.s12,
                  fontWeight: FontWeightManager.regular,
                  color: ColorManager.black.withOpacity(0.6),
                  fontFamily: StringManager.zongArcaBold,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  decoration: BoxDecoration(
                    color: ColorManager.red,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: CustomTextWidget(
                      text: 'LIVE',
                      fontSize: FontSize.s12,
                      fontWeight: FontWeightManager.medium,
                      color: ColorManager.white,
                      fontFamily: StringManager.zongArcaHeavy,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl:
                              '${StringManager.flagsBaseUrl}$fixtureTeamAImage',
                          height: 32,
                          width: 44,
                          fit: BoxFit.fill,
                          placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                            color: ColorManager.primary,
                          )),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        SizedBox(
                          width: 78,
                          child: CustomTextWidget(
                            text: fixtureTeamAName,
                            // text: 'INDIA',
                            fontSize: FontSize.s12,
                            fontWeight: FontWeightManager.medium,
                            color: ColorManager.black,
                            fontFamily: StringManager.zongArcaBold,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),

                    widget.teamAInnings != null
                        ? widget.teamAInnings!.length > 1
                            ? SizedBox(
                      width: 87,
                                child: ListView.builder(
                                    itemCount: widget.teamAInnings?.length,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      String separator = '';
                                      if (index != 0) {
                                        separator = '& ';
                                      }
                                      Widget? currentInningOver;

                                      if (activeTeam?.teamId == widget.teamA?.teamId) {
                                        if (index == 0) {
                                          currentInningOver = CustomTextWidget(
                                            text:
                                            '(${teamAOvers ?? ''}.${teamABall ?? ''})',
                                            fontSize: FontSize.s11,
                                            fontWeight:
                                            FontWeightManager.regular,
                                            color: ColorManager.black
                                                .withOpacity(0.6),
                                            fontFamily: StringManager.zongArcaBold,
                                          );
                                        }
                                      }
                                      return Row(
                                        children: [
                                          SizedBox(
                                            width: 7,
                                          ),
                                          CustomTextWidget(
                                            text:
                                                '$separator${widget.teamAInnings![index].totalRuns ?? ''}/${widget.teamAInnings![index].wicketsLost ?? ''}',
                                            // text: '100/4',
                                            fontSize: index == 0
                                                ? FontSize.s15
                                                : FontSize.s13,
                                            fontWeight: index == 0
                                                ? FontWeightManager.semiBold
                                                : FontWeightManager.medium,
                                            color: ColorManager.black,
                                            fontFamily: index == 0
                                                ? StringManager.zongArcaHeavy
                                                : StringManager.zongArcaBold,
                                          ),
                                          currentInningOver ?? Container(),

                                        ],
                                      );
                                    }),
                              )
                            : Row(
                              children: [
                                // SizedBox(
                                //   width: 10,
                                // ),
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomTextWidget(
                                        text:
                                            '${teamARuns ?? ''}/${teamAWkts ?? ''}',
                                        fontSize: FontSize.s16,
                                        fontWeight: FontWeightManager.semiBold,
                                        color: ColorManager.black,
                                        fontFamily: StringManager.zongArcaHeavy,
                                      ),
                                      CustomTextWidget(
                                        text:
                                            '(${teamAOvers ?? ''}.${teamABall ?? ''})',
                                        fontSize: FontSize.s13,
                                        fontWeight: FontWeightManager.regular,
                                        color: ColorManager.black.withOpacity(0.6),
                                        fontFamily: StringManager.zongArcaBold,
                                      ),
                                    ],
                                  ),
                              ],
                            )
                        : Container(),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    widget.teamBInnings != null
                        ? widget.teamBInnings!.length > 1
                            ? SizedBox(
                      width: 87,
                                child: ListView.builder(
                                    itemCount: widget.teamBInnings?.length,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      String separator = '';
                                      if (index != 0) {
                                        separator = '& ';
                                      }

                                      Widget? currentInningOver;
                                      if (activeTeam?.teamId == widget.teamB?.teamId) {
                                        if (index == 0) {
                                          currentInningOver = Row(
                                            children: [
                                              SizedBox(
                                                width: 2,
                                              ),
                                              CustomTextWidget(
                                                text:
                                                "(${widget.teamBInnings![0].oversBowled ?? ''}.${widget.teamBInnings![0].ballsBowled ?? ''})",
                                                fontSize: FontSize.s12,
                                                fontWeight:
                                                FontWeightManager.regular,
                                                color: ColorManager.black
                                                    .withOpacity(0.6),
                                                fontFamily:
                                                StringManager.zongArcaBold,
                                              ),
                                            ],
                                          );
                                        }
                                      }
                                      return Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        children: [
                                          CustomTextWidget(
                                            text:
                                                '$separator${widget.teamBInnings![index].totalRuns ?? ''}/${widget.teamBInnings![index].wicketsLost ?? ''}',
                                            // text: '100/4',
                                            fontSize: index == 0
                                                ? FontSize.s15
                                                : FontSize.s13,
                                            fontWeight: index == 0
                                                ? FontWeightManager.semiBold
                                                : FontWeightManager.medium,
                                            color: ColorManager.black,
                                            fontFamily: index == 0
                                                ? StringManager.zongArcaHeavy
                                                : StringManager.zongArcaBold,
                                          ),
                                          currentInningOver ?? Container(),
                                          SizedBox(
                                            width: 1,
                                          ),
                                        ],
                                      );
                                    }),
                              )
                            : Row(
                              children: [
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      CustomTextWidget(
                                        text:
                                            '${teamBRuns ?? ''}/${teamBWkts ?? ''}',
                                        fontSize: FontSize.s16,
                                        fontWeight: FontWeightManager.semiBold,
                                        color: ColorManager.black,
                                        fontFamily: StringManager.zongArcaHeavy,
                                      ),
                                      CustomTextWidget(
                                        // text: '(6.2)',
                                        text:
                                            '(${teamBOvers ?? ''}.${teamBBall ?? ''})',
                                        fontSize: FontSize.s13,
                                        fontWeight: FontWeightManager.regular,
                                        color: ColorManager.black.withOpacity(0.6),
                                        fontFamily: StringManager.zongArcaBold,
                                      ),
                                    ],
                                  ),
                                // SizedBox(
                                //   width: 10,
                                // ),
                              ],
                            )
                        : Container(),
                    Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl:
                              '${StringManager.flagsBaseUrl}$fixtureTeamBImage',
                          height: 32,
                          width: 44,
                          fit: BoxFit.fill,
                          placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                            color: ColorManager.primary,
                          )),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: 78,
                          child: CustomTextWidget(
                            // text: 'PAKISTAN',
                            text: fixtureTeamBName,
                            fontSize: FontSize.s12,
                            fontWeight: FontWeightManager.medium,
                            color: ColorManager.black,
                            fontFamily: StringManager.zongArcaBold,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            CustomTextWidget(
              text: matchDescription,
              // text: 'PAK need 70 run in 13.4 overs to win',
              fontSize: FontSize.s13,
              fontWeight: FontWeightManager.regular,
              color: ColorManager.black.withOpacity(0.6),
              fontFamily: StringManager.zongArcaBold,
            ),
            CustomTextWidget(
              text:
                  'CRR: ${crr.toStringAsFixed(2)}    RRR: ${rrr.toStringAsFixed(2)}',
              fontSize: FontSize.s12,
              fontWeight: FontWeightManager.regular,
              color: ColorManager.black.withOpacity(0.6),
              fontFamily: StringManager.zongArcaBold,
            ),
          ],
        );
      }
    }
    else if (widget.fixture.status == 3) {
      String? teamARuns;
      String? teamAWkts;
      String? teamAOvers;
      String? teamABall;

      if (widget.teamAInnings != null) {
        teamARuns = widget.teamAInnings![0].totalRuns.toString();
        teamAWkts = widget.teamAInnings![0].wicketsLost.toString();
        teamAOvers = widget.teamAInnings![0].oversBowled.toString();
        teamABall = widget.teamAInnings![0].ballsBowled.toString();
      }

      String? teamBRuns;
      String? teamBWkts;
      String? teamBOvers;
      String? teamBBall;
      if (widget.teamBInnings != null) {
        teamBRuns = widget.teamBInnings![0].totalRuns.toString();
        teamBWkts = widget.teamBInnings![0].wicketsLost.toString();
        teamBOvers = widget.teamBInnings![0].oversBowled.toString();
        teamBBall = widget.teamBInnings![0].ballsBowled.toString();
      }

      String? matchDescription;

      if (widget.fixture.matchResult != null) {
        matchDescription = widget.fixture.matchResult;
      }
      card = Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Container(),
              CustomTextWidget(
                text: fixtureTitle,
                fontSize: FontSize.s12,
                fontWeight: FontWeightManager.regular,
                color: ColorManager.black.withOpacity(0.6),
                fontFamily: StringManager.zongArcaBold,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                decoration: BoxDecoration(
                  color: ColorManager.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: CustomTextWidget(
                    text: 'Recent',
                    fontSize: FontSize.s12,
                    fontWeight: FontWeightManager.medium,
                    color: ColorManager.primary,
                    fontFamily: StringManager.zongArcaHeavy,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      CachedNetworkImage(
                        imageUrl:
                            '${StringManager.flagsBaseUrl}$fixtureTeamAImage',
                        height: 32,
                        width: 44,
                        fit: BoxFit.fill,
                        placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                          color: ColorManager.primary,
                        )),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      SizedBox(
                        width: 78,
                        child: CustomTextWidget(
                          text: fixtureTeamAName,
                          fontSize: FontSize.s12,
                          fontWeight: FontWeightManager.medium,
                          color: ColorManager.black,
                          fontFamily: StringManager.zongArcaBold,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  widget.teamAInnings != null
                      ? widget.teamAInnings!.length > 1
                      ? SizedBox(
                    width: 87,
                    child: ListView.builder(
                        itemCount: widget.teamAInnings?.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics:
                        const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          String separator = '';
                          if (index != 0) {
                            separator = '& ';
                          }
                          return Row(
                            children: [
                              SizedBox(
                                width: 7,
                              ),
                              CustomTextWidget(
                                text:
                                '$separator${widget.teamAInnings![index].totalRuns ?? ''}/${widget.teamAInnings![index].wicketsLost ?? ''}',
                                fontSize: index == 0
                                    ? FontSize.s15
                                    : FontSize.s13,
                                fontWeight: index == 0
                                    ? FontWeightManager.semiBold
                                    : FontWeightManager.medium,
                                color: ColorManager.black,
                                fontFamily: index == 0
                                    ? StringManager.zongArcaHeavy
                                    : StringManager.zongArcaBold,
                                textAlign: TextAlign.start,
                              ),
                            ],
                          );
                        }),
                  ) : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextWidget(
                              text: '${teamARuns ?? ''}/${teamAWkts ?? ''}',
                              fontSize: FontSize.s16,
                              fontWeight: FontWeightManager.semiBold,
                              color: ColorManager.black,
                              fontFamily: StringManager.zongArcaHeavy,
                            ),
                            CustomTextWidget(
                              text: '(${teamAOvers ?? ''}.${teamABall ?? ''})',
                              fontSize: FontSize.s13,
                              fontWeight: FontWeightManager.regular,
                              color: ColorManager.black.withOpacity(0.6),
                              fontFamily: StringManager.zongArcaBold,
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.teamBInnings != null
                      ? widget.teamBInnings!.length > 1
                      ? SizedBox(
                    width: 87,
                    child: ListView.builder(
                        itemCount: widget.teamBInnings?.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics:
                        const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          String separator = '';
                          if (index != 0) {
                            separator = '& ';
                          }
                          return CustomTextWidget(
                            text:
                            '$separator${widget.teamBInnings![index].totalRuns ?? ''}/${widget.teamBInnings![index].wicketsLost ?? ''}',
                            fontSize: index == 0
                                ? FontSize.s15
                                : FontSize.s13,
                            fontWeight: index == 0
                                ? FontWeightManager.semiBold
                                : FontWeightManager.medium,
                            color: ColorManager.black,
                            fontFamily: index == 0
                                ? StringManager.zongArcaHeavy
                                : StringManager.zongArcaBold,
                            textAlign: TextAlign.end,
                          );
                        }),
                  ) : Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CustomTextWidget(
                              text: '${teamBRuns ?? ''}/${teamBWkts ?? ''}',
                              fontSize: FontSize.s16,
                              fontWeight: FontWeightManager.semiBold,
                              color: ColorManager.black,
                              fontFamily: StringManager.zongArcaHeavy,
                            ),
                            CustomTextWidget(
                              text: '(${teamBOvers ?? ''}.${teamBBall ?? ''})',
                              fontSize: FontSize.s13,
                              fontWeight: FontWeightManager.regular,
                              color: ColorManager.black.withOpacity(0.6),
                              fontFamily: StringManager.zongArcaBold,
                            ),
                          ],
                        )
                      : Container(),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  Column(
                    children: [
                      CachedNetworkImage(
                        imageUrl:
                            '${StringManager.flagsBaseUrl}$fixtureTeamBImage',
                        height: 32,
                        width: 44,
                        fit: BoxFit.fill,
                        placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                          color: ColorManager.primary,
                        )),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: 78,
                        child: CustomTextWidget(
                          text: fixtureTeamBName,
                          fontSize: FontSize.s12,
                          fontWeight: FontWeightManager.medium,
                          color: ColorManager.black,
                          fontFamily: StringManager.zongArcaBold,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          CustomTextWidget(
            text: matchDescription ?? '',
            fontSize: FontSize.s15,
            fontWeight: FontWeightManager.regular,
            color: ColorManager.black,
            fontFamily: StringManager.zongArcaBold,
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return card ?? Container();
  }
}
