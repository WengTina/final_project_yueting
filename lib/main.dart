import 'package:final_yueting/models/playlist_provider.dart';
import 'package:final_yueting/themes/dark_mode.dart';
import 'package:final_yueting/themes/light_mode.dart';
import 'package:final_yueting/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'logic/bloc/calendar_bloc.dart';
import 'logic/bloc/calendar_state.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => PlaylistProvider()),
        BlocProvider(create: (_) => MusicDumpBloc()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
