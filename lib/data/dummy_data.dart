import 'package:flutter/material.dart';

class DeviceIOT {
  String alias;
  String location;
  IconData icon;
  String ipAddress;
  String status;
  IotMode mode;
  IotType type;

  void Function() onSwitch;

  DeviceIOT({
    required this.alias,
    required this.location,
    required this.type,
    required this.icon,
    required this.ipAddress,
    required this.status,
    required this.mode,
    required this.onSwitch,
  });
  
  factory DeviceIOT.empty() {
    return DeviceIOT(
      alias: '',
      icon: Icons.abc,
      ipAddress: '',
      location: '',
      mode: IotMode.remote,
      onSwitch: () {},
      status: '',
      type: IotType.smartLamp,
    );
  }
}

enum IotMode {
  remote,
  auto,
  timer
}

enum IotType {
  smartLamp,
  smokeDetector,
  flameDetector,
  infrared
}