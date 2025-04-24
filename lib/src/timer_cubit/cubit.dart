import 'dart:async';

import 'package:cricket_scoreboard/src/timer_cubit/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimerCubit extends Cubit<TimerState> {
  TimerCubit() : super(const TimerInitialState(elapsed: 0));

  Timer? _timer;
  onTick(Timer timer) {
    if (state is TimerInProgressState) {
      TimerInProgressState wip = state as TimerInProgressState;
      if (wip.elapsed > 1) {
        emit(TimerInProgressState(wip.elapsed - 1));
      } else {
        endTimer();
      }
    }
  }

  startWorkout([int? index]) {
    emit(TimerInProgressState(index!));

    _timer = Timer.periodic(const Duration(seconds: 1), onTick);
  }

  endTimer() {
    if (_timer != null) {
      _timer!.cancel();

      emit(const TimerInEndState(1));
    }
  }

  @override
  Future<void> close() {
    // Dispose the timer if it exists
    if (_timer != null) {
      _timer!.cancel();
    }
    return super.close();
  }
}
