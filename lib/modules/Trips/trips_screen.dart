import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:trip_app_olsps/shared/components/trip_components.dart';
import 'package:trip_app_olsps/shared/database/app_states.dart';
import 'package:trip_app_olsps/shared/database/database.dart';

class newTripscreen extends StatefulWidget {
  @override
  State<newTripscreen> createState() => _newTripscreenState();
}

class _newTripscreenState extends State<newTripscreen> {
  var _formKey = GlobalKey<FormState>();

  TextEditingController _textUsernameController = TextEditingController();

  TextEditingController _textLocationController = TextEditingController();

  String selectedDate = 'Pick Date';

  String selectedTime = 'Pick Time';

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
                            'Add New Trip',
                            style: TextStyle(fontSize: 22),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: _textUsernameController,
                            keyboardType: TextInputType.text,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Values can\'t be empty';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'username',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
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
                              hintText: 'triplocation',
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
                                    cubit.insertIntoDataBase(
                                      username: _textUsernameController.text,
                                      triplocation:
                                          _textLocationController.text,
                                      triptime: selectedTime,
                                      tripdate: selectedDate,
                                    );
                                    _textUsernameController.text = '';
                                    _textLocationController.text = '';
                                    selectedTime = 'Pick Date';
                                    selectedDate = 'Pick Time';
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
          body: taskBuilder(tasks: cubit.newTrips),
        );
      },
    );
  }
}
