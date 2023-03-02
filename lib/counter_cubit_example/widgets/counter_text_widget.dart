import 'package:flutter/material.dart';

class CounterTextWidget extends StatelessWidget {
  final int counter;
  const CounterTextWidget({Key? key, required this.counter,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      counter.toString(),
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }
}
