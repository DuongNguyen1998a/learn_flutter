import 'package:flutter/material.dart';

class CounterFabButtonWidget extends StatelessWidget {
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CounterFabButtonWidget({
    Key? key,
    required this.onIncrement,
    required this.onDecrement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingActionButton(
          key: const Key('counterView_increment_floatingActionButton'),
          child: const Icon(Icons.add),
          onPressed: () {
            onIncrement();
          },
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          key: const Key('counterView_decrement_floatingActionButton'),
          child: const Icon(Icons.remove),
          onPressed: () {
            onDecrement();
          },
        ),
      ],
    );
  }
}
