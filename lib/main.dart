import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/core/app_themes/app_themes.dart';
import 'package:todo_bloc/presentations/bloc/todo_bloc.dart';

import 'presentations/layout_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create:(context) => TodoBloc(),)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ToDo BloC',
        theme:AppTheme.lightTheme ,
        darkTheme: AppTheme.darkTheme,
        home: const LayoutScreen(),
      ),
    );
  }
}

