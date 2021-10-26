import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_app_olsps/shared/bloc_observer.dart';

import 'layouts/app_navigation.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OLSPS TRIP APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AppNavigation(),
    );
  }
}
