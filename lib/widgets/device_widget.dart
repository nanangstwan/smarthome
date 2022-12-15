import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smarthome_app/data/dummy_data.dart';
import 'package:smarthome_app/widgets/my_separator_widget.dart';

class DeviceWidget extends StatefulWidget {
  const DeviceWidget({Key? key}) : super(key: key);

  @override
  State<DeviceWidget> createState() => DeviceWidgetState();
}

class DeviceWidgetState extends State<DeviceWidget> {
  bool value = false;

  Future<bool> _getFuture() async {
    await Future.delayed(const Duration(seconds: 1));
    return !value;
  }

  @override
  Widget build(BuildContext context) {
    final wScreen = MediaQuery.of(context).size.width;
    final hScreen = MediaQuery.of(context).size.height;

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: [
          StreamBuilder(
            stream: FirebaseDatabase.instance.ref().child('lampMode1').onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final dataMode1 = snapshot.data as DatabaseEvent?;
                final modeLamp1 =
                    dataMode1?.snapshot.value?.toString() ?? "ERROR";
                return StreamBuilder(
                  stream: FirebaseDatabase.instance
                      .ref()
                      .child('statusLamp1')
                      .onValue,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final dataStatus1 = snapshot.data as DatabaseEvent?;
                      final statusLamp1 =
                          dataStatus1?.snapshot.value?.toString() ?? "ERROR";

                      final device = DeviceIOT(
                        alias: "",
                        icon: Icons.wc,
                        ipAddress: "",
                        location: "Kamar Mandi 1",
                        mode: modeLamp1 == 'remote'
                            ? IotMode.remote 
                            : IotMode.auto ,
                        status: statusLamp1 == "1" ? "HIDUP" : "MATI",
                        type: IotType.smartLamp,
                        onSwitch: () {
                          int targetStatus = statusLamp1 == "1" ? 0 : 1;
                          FirebaseDatabase.instance
                              .ref()
                              .update({"statusLamp1": targetStatus});
                        },
                      );

                      return IotCard(
                        isLoading: false,
                        device: device,
                        onModeChannge: (mode) {
                          FirebaseDatabase.instance
                              .ref()
                              .update({"lampMode1": mode});
                        },
                      );
                    }

                    return IotCard(isLoading: true, device: DeviceIOT.empty());
                  },
                );
              }

              return IotCard(isLoading: true, device: DeviceIOT.empty());
            },
          ),
          StreamBuilder(
            stream: FirebaseDatabase.instance.ref().child('lampMode2').onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final dataMode1 = snapshot.data as DatabaseEvent?;
                final modeLamp1 =
                    dataMode1?.snapshot.value?.toString() ?? "ERROR";
                return StreamBuilder(
                  stream: FirebaseDatabase.instance
                      .ref()
                      .child('statusLamp2')
                      .onValue,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final dataStatus1 = snapshot.data as DatabaseEvent?;
                      final statusLamp1 =
                          dataStatus1?.snapshot.value?.toString() ?? "ERROR";

                      final device = DeviceIOT(
                        alias: "",
                        icon: Icons.wc,
                        ipAddress: "",
                        location: "Kamar Mandi 2",
                        mode: modeLamp1 == 'remote'
                            ? IotMode.remote
                            : IotMode.auto,
                        status: statusLamp1 == "1" ? "HIDUP" : "MATI",
                        type: IotType.smartLamp,
                        onSwitch: () {
                          int targetStatus = statusLamp1 == "1" ? 0 : 1;
                          FirebaseDatabase.instance
                              .ref()
                              .update({"statusLamp2": targetStatus});
                        },
                      );

                      return IotCard(
                        isLoading: false,
                        device: device,
                        onModeChannge: (mode) {
                          FirebaseDatabase.instance
                              .ref()
                              .update({"lampMode2": mode});
                        },
                      );
                    }

                    return IotCard(isLoading: true, device: DeviceIOT.empty());
                  },
                );
              }

              return IotCard(isLoading: true, device: DeviceIOT.empty());
            },
          ),
          StreamBuilder(
            stream: FirebaseDatabase.instance.ref().child('statusAc').onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final dataAc = snapshot.data as DatabaseEvent?;
                final statusAc = dataAc?.snapshot.value?.toString() ?? 'ERROR';
                return StreamBuilder(
                    stream:
                        FirebaseDatabase.instance.ref().child('acTemp').onValue,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final dataAc = snapshot.data as DatabaseEvent?;
                        final acTemp = dataAc?.snapshot.value?.toString();

                        final device = DeviceIOT(
                          alias: '',
                          location: 'AC Ruang Tamu',
                          type: IotType.infrared,
                          icon: Icons.air,
                          status: statusAc == "0" ? 'Off' : acTemp! + "\u00b0C",
                          ipAddress: '',
                          mode: IotMode.remote,
                          onSwitch: (() {
                            int targetStatus = statusAc == '1' ? 0 : 1;
                            FirebaseDatabase.instance.ref().update(
                                {'statusAc': targetStatus, 'p': 0});
                          }),
                        );
                        return IotCardV2(isLoading: false, device: device);
                      }
                      return IotCardV2(
                          isLoading: false, device: DeviceIOT.empty());
                    });
              }

              return IotCardV2(isLoading: true, device: DeviceIOT.empty());
            },
          ),
        ],
      );
    });
  }
}

class IotCard extends StatelessWidget {
  final DeviceIOT device;
  final bool isLoading;
  final Function(String mode)? onModeChannge;
  const IotCard({
    Key? key,
    required this.isLoading,
    required this.device,
    this.onModeChannge,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.blueAccent,
      child: !isLoading
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 30,
                              child: Icon(
                                device.icon,
                                color: device.mode == IotMode.remote
                                    ? Colors.black
                                    : Colors.grey,
                                size: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            clipBehavior: Clip.hardEdge,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                            ),
                            builder: (context) => ModeModal(
                              mode: device.mode.name,
                              onModeChannge: onModeChannge,
                            ),
                          );
                        },
                        child: Text(
                          device.mode.name.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        device.alias,
                        style: TextStyle(
                          color: device.mode == IotMode.remote
                              ? device.status == "HIDUP"
                                  ? Colors.white
                                  : Colors.black
                              : Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        device.location,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                const MySeparator(color: Colors.grey),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          device.status == "HIDUP" ? 'On' : 'Off',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Switch(
                        value: device.status == "HIDUP",
                        onChanged: device.mode == IotMode.auto
                            ? null
                            : (v) {
                                device.onSwitch();
                              },
                      )
                    ],
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class IotCardV2 extends StatelessWidget {
  final DeviceIOT device;
  final bool isLoading;
  final Function(String mode)? onModeChannge;
  const IotCardV2({
    Key? key,
    required this.isLoading,
    required this.device,
    this.onModeChannge,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.blueAccent,
      child: !isLoading
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 30,
                              child: Icon(
                                device.icon,
                                color: device.mode == IotMode.remote
                                    ? Colors.black
                                    : Colors.grey,
                                size: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Switch(
                        value: device.status != 'Off',
                        onChanged: device.mode == IotMode.auto
                            ? null
                            : (v) {
                                device.onSwitch();
                              },
                      )
                      // InkWell(
                      //   onTap: () {
                      //     showModalBottomSheet(
                      //       context: context,
                      //       clipBehavior: Clip.hardEdge,
                      //       shape: const RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.only(
                      //             topLeft: Radius.circular(10),
                      //             topRight: Radius.circular(10)),
                      //       ),
                      //       builder: (context) => ModeModal(
                      //         mode: device.mode.name,
                      //         onModeChannge: onModeChannge,
                      //       ),
                      //     );
                      //   },
                      //   child: Text(
                      //     device.mode.name.toUpperCase(),
                      //     style: const TextStyle(
                      //       fontWeight: FontWeight.bold,
                      //       color: Colors.white,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        device.alias,
                        style: TextStyle(
                          color: device.mode == IotMode.remote
                              ? device.status == ""
                                  ? Colors.white
                                  : Colors.black
                              : Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        device.location,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                const MySeparator(color: Colors.grey),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(   
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              device.status,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Temperature',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                StreamBuilder(
                                    stream: FirebaseDatabase.instance
                                        .ref()
                                        .child('acTemp')
                                        .onValue,
                                    builder: (context, snapshot) {
                                      print(snapshot);
                                      if (snapshot.hasData) {
                                        final dataAc =
                                            snapshot.data as DatabaseEvent?;
                                        final acTemp =
                                            dataAc?.snapshot.value?.toString();
                                        return InkWell(
                                          onTap: () {
                                            int saksae =
                                                int.parse(acTemp ?? "0");
                                            // String targetStatus = acTemp == 'false' ? 'true' : 'false';
                                            FirebaseDatabase.instance
                                                .ref()
                                                .update({
                                              "acTemp": saksae - 1,
                                              'acTempStatus': true, 'p' : 0
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: 70,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            child: const Text(
                                              '-',
                                              style: TextStyle(
                                                  fontSize: 26,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        );
                                      }
                                      return const CircularProgressIndicator();
                                    }),
                                const SizedBox(width: 10),
                                StreamBuilder(
                                    stream: FirebaseDatabase.instance
                                        .ref()
                                        .child('acTemp')
                                        .onValue,
                                    builder: (context, snapshot) {
                                      print(snapshot);
                                      if (snapshot.hasData) {
                                        final dataAc =
                                            snapshot.data as DatabaseEvent?;
                                        final acTemp =
                                            dataAc?.snapshot.value?.toString();
                                        return InkWell(
                                          onTap: () {
                                            int saksae =
                                                int.parse(acTemp ?? "0");
                                            FirebaseDatabase.instance
                                                .ref()
                                                .update({
                                              "acTemp": saksae + 1,
                                              'acTempStatus': true, 'p' : 0
                                            });
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: 70,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            child: const Text(
                                              '+',
                                              style: TextStyle(
                                                  fontSize: 26,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        );
                                      }
                                      return const CircularProgressIndicator();
                                    }),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class ModeModal extends StatefulWidget {
  final String mode;
  final Function(String mode)? onModeChannge;
  const ModeModal({
    Key? key,
    required this.mode,
    this.onModeChannge,
  }) : super(key: key);

  @override
  _ModeModalState createState() => _ModeModalState();
}

class _ModeModalState extends State<ModeModal> {
  String mode = '';
  @override
  void initState() {
    super.initState();
    mode = widget.mode;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),
            const Text(
              "Mode",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            ListTile(
              title: const Text("Remote"),
              trailing: mode == 'remote' ? const Icon(Icons.check) : null,
              onTap: () {
                setState(() {
                  mode = 'remote';
                });
              },
            ),
            ListTile(
              title: const Text("Automatic"),
              trailing: mode == 'auto' ? const Icon(Icons.check) : null,
              onTap: () {
                setState(() {
                  mode = 'auto';
                });
              },
            ),
            ListTile(
              title: const Text('Timer'),
              trailing: mode == 'timer' ? const Icon(Icons.check) : null,
              onTap: () {
                setState(() {
                  mode = 'timer';
                });
              },
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      child: const Text('SAVE'),
                      onPressed: () {
                        widget.onModeChannge?.call(mode);
                        Navigator.of(context).pop();
                      }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
