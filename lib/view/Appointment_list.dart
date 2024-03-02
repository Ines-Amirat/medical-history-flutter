import 'package:flutter/material.dart';

import '../components/custom_appbar.dart';
import '../utils/config.dart';

class AppointmentPage extends StatefulWidget {
  static final pageRoute = '/appointmentlist';
  const AppointmentPage({Key? key}) : super(key: key);

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  List<String> yourListName = ['Apple', 'Banana', 'Cherry', 'Date'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Appointment Schedule',
            style: TextStyle(
              fontWeight: FontWeight.bold, // Rend le texte bold
              fontSize: 20, // Augmente la taille de la police si nécessaire
              // Vous pouvez également spécifier une famille de polices différente si vous le souhaitez
            ),
          ),
          centerTitle: true,
          // Cela centre le titre sur l'appBar
        ),
        body: Column(
          children: [
            Config.spaceSmall,
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Card(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.amber,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'rrrrrr',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'ggggggg',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            ScheduleCard()
                          ],
                        ),
                      ));
                },
              ),
            ),
          ],
        ));
  }
}

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 253, 252, 252),
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Icon(
            Icons.calendar_today,
            color: Color.fromARGB(255, 0, 0, 3),
            size: 15,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            'Monday , 11/28/2022',
            style: const TextStyle(
              color: Color.fromARGB(255, 0, 0, 10),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          const Icon(
            Icons.access_alarm,
            color: Colors.black,
            size: 17,
          ),
          const SizedBox(
            width: 5,
          ),
          Flexible(
              child: Text(
            '2:00 PM',
            style: const TextStyle(
              color: Colors.black,
            ),
          ))
        ],
      ),
    );
  }
}
