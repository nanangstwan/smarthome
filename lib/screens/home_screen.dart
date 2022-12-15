import 'dart:async';
import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smarthome_app/widgets/device_widget.dart';
import 'package:smarthome_app/widgets/my_separator_widget.dart';

final GlobalKey<AnimatedFloatingActionButtonState> key =
    GlobalKey<AnimatedFloatingActionButtonState>();

class HomeScreen extends StatefulWidget {
  final String title;

  const HomeScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _timeString = '';
  String _dateString = '';

  @override
  void initState() {
    AlertDialog alert = AlertDialog(
      title: const Text(
        'WARNING',
        style: TextStyle(color: Colors.red),
      ),
      content: Container(
        child: const Text('please check your house immediately'),
      ),
      actions: [
        TextButton(
            onPressed: (() {
              Navigator.of(context).pop();
            }),
            child: const Text('OKE'))
      ],
    );

    _timeString = _formatTime(DateTime.now());
    _dateString = _formatDate(DateTime.now());
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getDate());

    super.initState();

    FirebaseDatabase.instance.ref().child('flame').onValue.listen((event) {
      final flame = event.snapshot.value?.toString() ?? 'ERROR';
      if (flame.toLowerCase() == 'warning') {
        showDialog(context: context, builder: ((context) => alert));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              // Header - Short Profile
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 1,
                    child: Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/smart_home.png'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _dateString,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _timeString,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade800),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.amber,
                  elevation: 5,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, left: 20, right: 20, bottom: 10),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: StreamBuilder(
                                  stream: FirebaseDatabase.instance
                                      .ref()
                                      .child('temperature')
                                      .onValue,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final dataTemperature =
                                          snapshot.data as DatabaseEvent?;
                                      final temperature = dataTemperature
                                              ?.snapshot.value
                                              ?.toString() ??
                                          'ERROR';
                                      return Text(
                                        temperature + '\u00b0C',
                                        style: TextStyle(
                                            color: Colors.grey.shade800,
                                            fontSize: 45,
                                            fontWeight: FontWeight.w900),
                                      );
                                    }
                                    return CircularProgressIndicator();
                                  }),
                              // Text(
                              //   '24\u00b0C',
                              //   style: TextStyle(
                              //     color: Colors.grey.shade800,
                              //     fontSize: 45,
                              //     fontWeight: FontWeight.w900,
                              //   ),
                              // ),
                            ),
                            const Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 30,
                                    child: Icon(
                                      Icons.thermostat,
                                      color: Colors.blueAccent,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const MySeparator(color: Colors.white),
                      // const Divider(color: Colors.grey),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20, left: 20, right: 20, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StreamBuilder(
                                    stream: FirebaseDatabase.instance
                                        .ref()
                                        .child('flame')
                                        .onValue,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        final dataFlame =
                                            snapshot.data as DatabaseEvent?;
                                        final flame = dataFlame?.snapshot.value
                                                ?.toString() ??
                                            'ERROR';

                                        return
                                            // flame == 'Safe' ?
                                            Text(
                                          flame.toUpperCase(),
                                          style: TextStyle(
                                              color: Colors.grey.shade800,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900),
                                        );
                                        // : showDialog(context: context, builder: (context){alert})
                                      }
                                      return CircularProgressIndicator();
                                    }),
                                // Text(
                                //   '29 AQI US',
                                //   style: TextStyle(
                                //       color: Colors.grey.shade800,
                                //       fontSize: 20,
                                //       fontWeight: FontWeight.w900),
                                // ),
                                Text(
                                  'Flame Status',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '48.2 %',
                                  style: TextStyle(
                                      color: Colors.grey.shade800,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900),
                                ),
                                Text(
                                  'Home Humidity',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Excellent',
                                  style: TextStyle(
                                      color: Colors.grey.shade800,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900),
                                ),
                                Text(
                                  'Air Quality',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const SizedBox(
                height: 500,
                child: DeviceWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void _temperature() {StreamBuilder(builder: builder)}

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  void _getDate() {
    final DateTime now = DateTime.now();

    final String formattedDateTime = _formatTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('EEEE, dd MMMM yyyy').format(dateTime);
  }
}
