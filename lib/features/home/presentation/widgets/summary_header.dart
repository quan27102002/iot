import 'package:bat_theme/bat_theme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../../core/navigation/navigator.dart';

class SummaryHeader extends StatelessWidget {
  SummaryHeader({
    Key? key,
  }) : super(key: key);
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  Future<void> getData() async {
    final snapshot = await ref.child('Home/HumTemp').get();
    if (snapshot.exists) {
      print(snapshot.value);
    } else {
      print('No data available.');
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = BatThemeData.of(context);

    return GestureDetector(
      onTap: () => AppNavigator.pushNamed(routineRoute),
      child: StreamBuilder<Object>(
          stream: null,
          builder: (context, snapshot) {
            return Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              decoration: BoxDecoration(
                color: BatPalette.primary,
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Temperature',
                          style: theme.typography.bodyCopy
                              .copyWith(color: BatPalette.white),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.thermostat,
                              size: 24,
                              color: BatPalette.white,
                            ),
                            Text(
                              '25°C',
                              style: theme.typography.bodyCopy
                                  .copyWith(color: BatPalette.white),
                            ),
                          ],
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Text('Humidity',
                            style: theme.typography.bodyCopy
                                .copyWith(color: BatPalette.white)),
                        Row(
                          children: [
                            const Icon(
                              Icons.water_drop_outlined,
                              size: 24,
                              color: BatPalette.white,
                            ),
                            Text(
                              '80%',
                              style: theme.typography.bodyCopy
                                  .copyWith(color: BatPalette.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Column(
                    //   children: [
                    //     Text(
                    //       'Energy Used',
                    //       style:
                    //           theme.typography.bodyCopy.copyWith(color: BatPalette.white),
                    //     ),
                    //     Row(
                    //       children: [
                    //         const Icon(
                    //           Icons.bolt_sharp,
                    //           size: 24,
                    //           color: BatPalette.white,
                    //         ),
                    //         Text(
                    //           '250 KWh',
                    //           style: theme.typography.bodyCopy
                    //               .copyWith(color: BatPalette.white),
                    //         ),
                    //       ],
                    //     )
                    //   ],
                    // ),
                  ]),
            );
          }),
    );
  }
}
