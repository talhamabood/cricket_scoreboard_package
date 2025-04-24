// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class TimerState extends Equatable {
  final int elapsed;
  const TimerState({
    required this.elapsed,
  });

  @override
  List<Object?> get props => [elapsed];
}

@immutable
class TimerInitialState extends TimerState {
  const TimerInitialState({required super.elapsed});
}

@immutable
class TimerInProgressState extends TimerState {
  const TimerInProgressState(int elapsed) : super(elapsed: elapsed);
}

@immutable
class TimerInEndState extends TimerState {
  const TimerInEndState(int elapsed) : super(elapsed: elapsed);
}
