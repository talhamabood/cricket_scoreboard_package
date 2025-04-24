class FixturesListModels {
  final int id;
  final String title;
  final String seriesName;
  final int seriesTypeId;
  final String scheduleDate;
  final String scheduledTime;
  final String endTime;
  final String groundName;
  final dynamic matchResult;
  final dynamic reducedTarget;
  final dynamic winningTeamId;
  final dynamic tossWinnerTeamId;
  final dynamic firstBattingTeamId;
  final List<Team> teams;
  final int status;
  final String? imageFileName;

  FixturesListModels({
    required this.id,
    required this.title,
    required this.seriesName,
    required this.seriesTypeId,
    required this.scheduleDate,
    required this.scheduledTime,
    required this.endTime,
    required this.groundName,
    required this.matchResult,
    required this.reducedTarget,
    required this.winningTeamId,
    required this.tossWinnerTeamId,
    required this.firstBattingTeamId,
    required this.teams,
    required this.status,
    required this.imageFileName,
  });

  factory FixturesListModels.fromJson(Map<String, dynamic> json) {
    return FixturesListModels(
      id: json['id'],
      title: json['title'],
      seriesName: json['seriesName'],
      seriesTypeId: json['seriesTypeId'],
      scheduleDate: json['scheduleDate'],
      scheduledTime: json['scheduledTime'],
      endTime: json['endTime'],
      groundName: json['groundName'],
      matchResult: json['matchResult'],
      reducedTarget: json['reducedTarget'],
      winningTeamId: json['winningTeamId'],
      tossWinnerTeamId: json['tossWinnerTeamId'],
      firstBattingTeamId: json['firstBattingTeamId'],
      status: json['status'],
      imageFileName: json['imageFileName'] ?? '',
      teams: (json['teams'] as List)
          .map((teamJson) => Team.fromJson(teamJson))
          .toList(),
    );
  }
}

class Team {
  final String teamName;
  final int teamId;
  final String flagImageName;
  final List<Inning> innings;

  Team({
    required this.teamName,
    required this.teamId,
    required this.flagImageName,
    required this.innings,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      teamName: json['teamName'],
      teamId: json['teamId'],
      flagImageName: json['flagImageName'],
      innings: (json['inning'] as List)
          .map((inningJson) => Inning.fromJson(inningJson))
          .toList(),
    );
  }
}

class Inning {
  final int id;
  final int battingTeamId;
  final int maxOvers;
  final int totalRuns;
  final int oversBowled;
  final int ballsBowled;
  final int wicketsLost;
  final bool inningActive;
  final bool declared;
  final Session? currentSession;

  Inning({
    required this.id,
    required this.battingTeamId,
    required this.maxOvers,
    required this.totalRuns,
    required this.oversBowled,
    required this.ballsBowled,
    required this.wicketsLost,
    required this.inningActive,
    required this.declared,
    this.currentSession,
  });

  factory Inning.fromJson(Map<String, dynamic> json) {
    return Inning(
      id: json['id'],
      battingTeamId: json['battingTeamId'],
      maxOvers: json['maxOvers'],
      totalRuns: json['totalRuns'] ?? 0,
      oversBowled: json['oversBowled'],
      ballsBowled: json['ballsBowled'],
      wicketsLost: json['wicketsLost'],
      inningActive: json['inningActive'],
      declared: json['declared'],
      currentSession: json['currentSession'] != null
          ? Session.fromJson(json['currentSession'])
          : null,
    );
  }
}

class Session {
  final int id;
  final bool isBreak;
  final String sessionName;

  Session({
    required this.id,
    required this.isBreak,
    required this.sessionName,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'],
      isBreak: json['isBreak'],
      sessionName: json['sessionName'],
    );
  }
}
