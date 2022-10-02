import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica_1_audio/bloc/home_bloc.dart';
import 'home_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorScheme: ColorScheme.dark()),
      home: BlocProvider(
        create: (context) => HomeBloc(),
        child: HomePage(),
      ),
    );
  }
}
