import 'package:flutter_bloc/flutter_bloc.dart';

import 'counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(CounterState(counter: 0));

  void increment(int currentCounter) {
    emit(CounterState(counter: currentCounter + 1));
  }

  void decrement(int currentCounter) {
    emit(CounterState(counter: currentCounter - 1));
  }
}
