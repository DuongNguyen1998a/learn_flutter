import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_flutter/timer_bloc_example/bloc/timer_bloc.dart';
import 'package:learn_flutter/timer_bloc_example/ticker.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('TimerPage build');
    return BlocProvider(
      create: (context) => TimerBloc(ticker: const Ticker()),
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: _TimerTextWidget(),
            ),
            const SizedBox(
              height: 20,
            ),
            BlocBuilder<TimerBloc, TimerState>(
              buildWhen: (prev, state) => prev.runtimeType != state.runtimeType,
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (state is TimerInitialState) ...[
                      FloatingActionButton(
                        child: const Icon(Icons.play_arrow),
                        onPressed: () => context.read<TimerBloc>().add(TimerStarted(duration: state.duration)),
                      ),
                    ],
                    if (state is TimerInProgressState) ...[
                      FloatingActionButton(
                        child: const Icon(Icons.pause),
                        onPressed: () => context.read<TimerBloc>().add(const TimerPaused()),
                      ),
                      FloatingActionButton(
                        child: const Icon(Icons.replay),
                        onPressed: () => context.read<TimerBloc>().add(const TimerReset()),
                      ),
                    ],
                    if (state is TimerPauseState) ...[
                      FloatingActionButton(
                        child: const Icon(Icons.play_arrow),
                        onPressed: () => context.read<TimerBloc>().add(const TimerResumed()),
                      ),
                      FloatingActionButton(
                        child: const Icon(Icons.replay),
                        onPressed: () => context.read<TimerBloc>().add(const TimerReset()),
                      ),
                    ],
                    if (state is TimerCompleteState) ...[
                      FloatingActionButton(
                        child: const Icon(Icons.replay),
                        onPressed: () => context.read<TimerBloc>().add(const TimerReset()),
                      ),
                    ]
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TimerTextWidget extends StatelessWidget {
  const _TimerTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('_TimerTextWidget build');
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    final minutesStr = ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');
    return Text(
      '$minutesStr:$secondsStr',
      style: Theme.of(context).textTheme.headline1,
    );
  }
}
