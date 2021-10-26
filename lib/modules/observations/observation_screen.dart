// ignore_for_file: missing_return

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:trip_app_olsps/Models/animals_model.dart';
import 'package:trip_app_olsps/shared/components/observation_component.dart';
import 'package:trip_app_olsps/shared/database/app_states.dart';
import 'package:trip_app_olsps/shared/database/database.dart';

class ObservationsScreen extends StatefulWidget {
  @override
  createState() => _DropDownAppState();
}

class _DropDownAppState extends State<ObservationsScreen> {
  var _formKey = GlobalKey<FormState>();
  List statesList = [];
  List animalsList = [];
  String _animals;
  TextEditingController _textLocationController = TextEditingController();
  TextEditingController _textLocationController2 = TextEditingController();
  TextEditingController _textAnimalNumberController = TextEditingController();
  TextEditingController _textAnimalSizeController = TextEditingController();
  String selectedDate = 'Observation Date';
  String selectedTime = 'Observation  Time';

  Future<String> loadStatesanimalsFromFile() async {
    return await rootBundle.loadString('json/animals.json');
  }

  Future<String> _populateDropdown() async {
    String getAnimals = await loadStatesanimalsFromFile();
    final jsonResponse = json.decode(getAnimals);

    Localization location = new Localization.fromJson(jsonResponse);

    setState(() {
      statesList = location.states;
      animalsList = location.animals;
    });
  }

  @override
  void initState() {
    super.initState();
    this._populateDropdown();
  }

  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppInsertIntoDataBseState) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);

        return Scaffold(
          backgroundColor: Colors.grey[200],
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => Dialog(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Add New observation',
                            style: TextStyle(fontSize: 22),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: _textLocationController,
                            keyboardType: TextInputType.text,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Values can\'t be empty';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'observation gps location',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          new DropdownButton(
                            isExpanded: true,
                            icon: const Icon(Icons.gps_fixed),
                            items: animalsList.map((item) {
                              return new DropdownMenuItem(
                                child: new Text(item.name),
                                value: item.name.toString(),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                _animals = newVal;
                              });
                            },
                            value: _animals,
                            hint: Text('Select an Animal'),
                          ),
                          TextFormField(
                            controller: _textAnimalNumberController,
                            keyboardType: TextInputType.text,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Values can\'t be empty';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'animalNumber',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: _textAnimalSizeController,
                            keyboardType: TextInputType.text,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Values can\'t be empty';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'animalSize',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          defaultButton(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.date_range,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(width: 10),
                                Text(selectedDate),
                              ],
                            ),
                            onPressed: () => showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate:
                                  DateTime.now().add(Duration(days: -365)),
                              lastDate: DateTime.now().add(Duration(days: 365)),
                            ).then((value) {
                              selectedDate = DateFormat()
                                  .add_yMMMd()
                                  .format(value)
                                  .toString();
                            }),
                          ),
                          const SizedBox(height: 15),
                          defaultButton(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(width: 10),
                                Text(selectedTime),
                              ],
                            ),
                            onPressed: () => showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ).then((value) {
                              selectedTime = value.format(context).toString();
                            }),
                          ),
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Close'),
                              ),
                              defaultButton(
                                child: Text('Save'),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: Theme.of(context).primaryColor,
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    cubit.insertIntoDataBaseObservartions(
                                      observationlocation:
                                          _textLocationController.text,
                                      animal: _animals,
                                      animalNumber:
                                          _textAnimalNumberController.text,
                                      animalSize:
                                          _textAnimalSizeController.text,
                                      observationTime: selectedTime,
                                      observationDate: selectedDate,
                                    );
                                    _textLocationController.text = '';
                                    _textLocationController2.text = '';
                                    _textAnimalNumberController.text = '';
                                    _textAnimalSizeController.text = '';
                                    selectedTime = 'Observation Date';
                                    selectedDate = 'Observation  Time';
                                  }
                                },
                                textColor: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            child: Icon(Icons.add),
          ),
          body: observationBuilder(observation: cubit.userObservations),
        );
      },
    );
  }
}
