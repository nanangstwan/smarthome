// // ignore_for_file: non_constant_identifier_names

// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:smarthome_app/tools/result.dart';

// const String ipAddress = "http://192.168.0.119:8001/api/jammers";

// // class Jammer {
// //   final String id;
// //   final String alias_name;
// //   final String ip;
// //   final String port;
// //   final String location;
// //   final Map<String, double> geolocation;
// //   String status;

// //   Jammer({
// //     required this.id,
// //     required this.alias_name,
// //     required this.ip,
// //     required this.port,
// //     required this.location,
// //     required this.geolocation,
// //     required this.status,
// //   });

// class DeviceIOT {
//   String id;
//   String alias;
//   String location;
//   String type;
//   IconData icon;
//   String ipAddress;
//   bool status;
//   bool modeRemote;

//   DeviceIOT({
//     required this.id,
//     required this.alias,
//     required this.location,
//     required this.type,
//     required this.icon,
//     required this.ipAddress,
//     required this.status,
//     required this.modeRemote,
//   });

//   factory DeviceIOT.createDevice(Map<String, dynamic> object) {
//     return DeviceIOT(
//       id: object['id'],
//       alias: object['alias'],
//       location: object['location'],
//       type: object['type'],
//       icon: object['icon'],
//       ipAddress: object['ipAddress'],
//       status: object['status'],
//       modeRemote: object['modeRemote'],
//     );
//   }

//   get length => null;

//   // static Future<List<Jammer>> getJammer() async {
//   //   Uri url = Uri.parse(ipAddress);
//   //   var apiResult = await http.get(url);
//   //   var jsonObject = json.decode(apiResult.body);
//   //   List<dynamic> dataJammer =
//   //       await (jsonObject as Map<String, dynamic>)['data'];
//   //   return dataJammer.map((jammer) => Jammer.createJammer(jammer)).toList();
//   // }

//   static Future<Result<bool>> toggleJammer(String id, bool isOn) async {
//     // String username = 'admin';
//     // String password = 'esp8266';
//     // String basicAuth =
//     //     'Basic ' + base64.encode(utf8.encode('$username:$password'));
//     try {
//       Uri url = Uri.parse(isOn
//           ? ipAddress + "/switch/" + id + "/on"
//           : ipAddress + "/switch/" + id + "/off");
//       var apiResult = await http.get(
//         url,
//         // headers: <String, String>{
//         //   'authorization': basicAuth,
//         // },
//       );
//       var jsonObject = json.decode(apiResult.body);
//       if (apiResult.statusCode >= 500) {
//         String message = jsonObject['message'];
//         return Error(message: message);
//       } else {
//         return Success(data: true);
//       }
//     } catch (e) {
//       return Error(message: e.toString());
//     }
//   }

//   // static Future<Result<String>> addJammer(
//   //   String alias_name,
//   //   String ip,
//   //   String port,
//   //   double latitude,
//   //   double longitude,
//   //   String location,
//   // ) async {
//   //   Uri url = Uri.parse(ipAddress);
//   //   var test = {
//   //     'alias': alias_name,
//   //     'ip': ip,
//   //     'port': port,
//   //     'lat': latitude.toString(),
//   //     'long': longitude.toString(),
//   //     'location': location,
//   //   };
//   //   var apiResult = await http.post(url, body: test);
//   //   if (apiResult.statusCode == 400) {
//   //     var jsonObject = json.decode(apiResult.body);
//   //     return Error(message: jsonObject['message']);
//   //   } else if (apiResult.statusCode == 201) {
//   //     return Success(
//   //         message: "Berhasil menambahkan jammer",
//   //         data: "Jammer berhasil ditambahkan");
//   //   }
//   //   return Error();
//   // }

//   // static Future<dynamic> deleteJammer(String id) async {
//   //   try {
//   //     final response = await http.delete(Uri.parse(ipAddress + "/" + id));
//   //     if (response.statusCode == 200) {
//   //       return true;
//   //     } else {
//   //       return false;
//   //     }
//   //   } catch (e) {
//   //     print(e.toString());
//   //   }
//   // }
// }

// // class ToggleResult