import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_flutter/counter_cubit_example/counter.dart';

class CounterObserver extends BlocObserver {
  const CounterObserver();

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint(
      '${bloc.runtimeType} change, currentState: ${(change.currentState as CounterState).counter}, '
      'nextState: ${(change.nextState as CounterState).counter}',
    );
  }
}
