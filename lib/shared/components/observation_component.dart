import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:trip_app_olsps/shared/database/database.dart';

Widget defaultButton({
  @required Widget child,
  @required Function onPressed,
  Color backgroundColor,
  Color textColor,
  ShapeBorder shape,
}) =>
    MaterialButton(
      child: child,
      color: backgroundColor,
      textColor: textColor,
      shape: shape,
      onPressed: onPressed,
    );

Widget buildTask({
  @required BuildContext context,
  @required Map model,
}) =>
    Dismissible(
      key: Key(model['id'].toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        AppCubit.get(context).deleteObservation(id: model['id']);
      },
      background: Container(
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete,
          color: Colors.blue,
          size: 35,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${model['observationDate']}'),
                    SizedBox(height: 10),
                    Text('${model['observationTime']}'),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 20),
          Flexible(
            flex: 2,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        child: Text(
                          '${model['observationlocation']}',
                          textAlign: TextAlign.start,
                          softWrap: true,
                        ),
                        width: 100,
                        margin: EdgeInsets.only(
                          left: 10.0,
                          top: 10,
                          bottom: 10,
                        ),
                      ),
                      Container(
                        child: Text(
                          '${model['animal']}',
                          textAlign: TextAlign.start,
                          softWrap: true,
                        ),
                        width: 100,
                        margin: EdgeInsets.only(
                          left: 10.0,
                          top: 10,
                          bottom: 10,
                        ),
                      ),
                      Container(
                        child: Text(
                          '${model['animalNumber']}',
                          textAlign: TextAlign.start,
                          softWrap: true,
                        ),
                        width: 100,
                        margin: EdgeInsets.only(
                          left: 10.0,
                          top: 10,
                          bottom: 10,
                        ),
                      ),
                      Container(
                        child: Text(
                          '${model['animalSize']}',
                          textAlign: TextAlign.start,
                          softWrap: true,
                        ),
                        width: 100,
                        margin: EdgeInsets.only(
                          left: 10.0,
                          top: 10,
                          bottom: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

Widget observationBuilder({
  @required List<Map> observation,
}) =>
    ConditionalBuilder(
      condition: observation.length > 0,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: ListView.separated(
          itemBuilder: (context, index) {
            return buildTask(context: context, model: observation[index]);
          },
          separatorBuilder: (context, index) => SizedBox(height: 40),
          itemCount: observation.length,
        ),
      ),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              size: 40,
              color: Colors.grey,
            ),
            Text(
              'No observation Yet, Please Add Some observation',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
