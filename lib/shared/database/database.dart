import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trip_app_olsps/modules/observations/observation_screen.dart';
import 'package:trip_app_olsps/modules/trips/trips_screen.dart';
import 'app_states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  Database database;
  int selectedIndex = 0;
  List<Map> newTrips = [];
  List<Map> userObservations = [];

  List<Widget> pages = [
    newTripscreen(),
    ObservationsScreen(),
  ];

  List<String> appBarTitle = [
    'Start Trip',
    'Observations',
  ];

  void changeIndex(int index) {
    selectedIndex = index;
    emit(AppBottomNavBarChangeIndexState());
  }

  void createDataBase() {
    openDatabase(
      'trip.db',
      version: 1,
      onCreate: (db, version) {
        print('database created');
        db
            .execute(
                'CREATE TABLE Trips (id INTEGER PRIMARY KEY, username TEXT, triptime TEXT, triplocation Text,tripdate Text, status TEXT)')
            .then((value) => print('table Created'));
        db
            .execute(
                'CREATE TABLE OBSERVATIONS(id INTEGER PRIMARY KEY,observationDate TEXT, observationTime TEXT, observationlocation TEXT,animal TEXT,animalNumber INT,animalSize TEXT, status TEXT)')
            .then((value) => print('table Created'));
      },
      onOpen: (db) {
        getDataFromDataBase(db);

        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDataBseState());
    });
  }

  Future insertIntoDataBase({
    @required String username,
    @required String triptime,
    @required String triplocation,
    @required String tripdate,
  }) async {
    await database.transaction(
      (txn) => txn
          .rawInsert(
        'INSERT INTO Trips(username, triptime, triplocation,tripdate, status) VALUES("$username", "$triptime", "$triplocation", "$tripdate", "new")',
      )
          .then((value) {
        print('$value Raw Inserted');
        emit(AppInsertIntoDataBseState());

        getDataFromDataBase(database);
      }),
    );
  }

  Future insertIntoDataBaseObservartions({
    @required String observationDate,
    @required String observationTime,
    @required String observationlocation,
    @required String animal,
    @required String animalNumber,
    @required String animalSize,
  }) async {
    await database.transaction(
      (txn) => txn
          .rawInsert(
        'INSERT INTO  OBSERVATIONS(observationDate, observationTime, observationlocation,animal,animalNumber,animalSize, status) VALUES("$observationDate", "$observationTime", "$observationlocation","$animal", "$animalNumber","$animalSize", "new")',
      )
          .then((value) {
        print('$value Raw Inserted');
        emit(AppInsertIntoDataBseState());

        getDataFromDataBase(database);
      }),
    );
  }

  void getDataFromDataBase(database) {
    newTrips = [];
    userObservations = [];
    emit(AppGetDataLoadingState());

    database.rawQuery("SELECT * FROM Trips").then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') newTrips.add(element);
      });

      emit(AppGetDataFromDataBseState());
    });
    database.rawQuery("SELECT * FROM OBSERVATIONS").then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') userObservations.add(element);
      });

      emit(AppGetDataFromDataBseState());
    });
  }

  void updateData({
    @required String status,
    @required int id,
  }) {
    database.rawUpdate('UPDATE Trips SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      print('$value updated');
      getDataFromDataBase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({
    @required int id,
  }) {
    database.rawDelete('DELETE FROM Trips WHERE id = ?', [id]).then((value) {
      getDataFromDataBase(database);

      emit(AppGetDataFromDataBseState());

      emit(AppDeleteDatabaseState());
    });
  }

  void deleteObservation({
    @required int id,
  }) {
    database
        .rawDelete('DELETE FROM OBSERVATIONS WHERE id = ?', [id]).then((value) {
      getDataFromDataBase(database);

      emit(AppGetDataFromDataBseState());

      emit(AppDeleteDatabaseState());
    });
  }
}
