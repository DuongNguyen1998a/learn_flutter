import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_flutter/long_text_example/long_text_page.dart';
import 'package:learn_flutter/timer_bloc_example/page/timer_page.dart';
import 'package:learn_flutter/video_player_example/page/video_player_page.dart';

import 'counter_cubit_example/counter_observer.dart';
import 'counter_cubit_example/page/counter_page.dart';

void main() {
  //Bloc.observer = const CounterObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learn Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const VideoPlayerPage(),
    );
  }
}
