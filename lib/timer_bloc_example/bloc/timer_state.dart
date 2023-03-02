part of 'timer_bloc.dart';

abstract class TimerState extends Equatable {
  final int duration;
  const TimerState(this.duration);
}

class TimerInitialState extends TimerState {
  const TimerInitialState(super.duration);

  @override
  List<Object> get props => [duration];
}

class TimerPauseState extends TimerState {
  const TimerPauseState(super.duration);

  @override
  String toString() => 'TimerRunPause { duration: $duration }';

  @override
  List<Object?> get props => [duration];
}

class TimerInProgressState extends TimerState {
  const TimerInProgressState(super.duration);

  @override
  String toString() => 'TimerRunInProgress { duration: $duration }';

  @override
  List<Object?> get props => [duration];
}

class TimerCompleteState extends TimerState {
  const TimerCompleteState() : super(0);

  @override
  List<Object?> get props => [];
}