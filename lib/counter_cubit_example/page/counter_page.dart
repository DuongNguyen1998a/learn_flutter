import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../counter.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterCubit(),
      child: BlocBuilder<CounterCubit, CounterState>(
        builder: (context, state) {
          return Scaffold(
            body: Center(
              child: CounterTextWidget(counter: state.counter),
            ),
            floatingActionButton: CounterFabButtonWidget(
              onIncrement: () => context.read<CounterCubit>().increment(state.counter),
              onDecrement: () => context.read<CounterCubit>().decrement(state.counter),
            ),
          );
        },
      ),
    );
  }
}
