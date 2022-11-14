import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica_1_audio/bloc/home_bloc.dart';
import 'bloc/bloc/auth_bloc.dart';
import 'home_page.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc()..add(VerifyAuthenticationEvent()),
        ),
        BlocProvider(
          create: (context) => HomeBloc(),
        )
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorScheme: ColorScheme.dark()),
      home: BlocProvider(
        create: (context) => HomeBloc(),
        child: BlocConsumer<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthenticatedState || state is SuccessLoginState) {
              print(state);
              return HomePage();
            } else if (state is UnauthenticatedState ||
                state is SuccessLogoutState) {
              print(state);
              return Login();
            } else {
              print(state);
              return Login();
            }
          },
          listener: (context, state) {},
        ),
      ),
    );
  }
}
