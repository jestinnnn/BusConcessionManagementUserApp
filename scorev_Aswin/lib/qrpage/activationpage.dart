import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:latlong2/latlong.dart';
import 'package:score/constants/constants.dart';
import 'package:score/firebase_helper/firebase_firestore_helper/firestore_helper.dart';
import 'package:score/models/bus_owner_model.dart';
import 'package:score/models/ticket.dart';
import 'package:score/pages/home_page.dart';
import 'package:score/services/map_service.dart';
import 'package:score/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class studentlist extends StatefulWidget {
  final String qr_number;
  final String id;
  final String busid;
  const studentlist(
      {super.key,
      required this.qr_number,
      required this.id,
      required this.busid});

  @override
  // ignore: library_private_types_in_public_api
  _studentlistState createState() => _studentlistState();
}

class _studentlistState extends State<studentlist> {
  bool isloading = false;
  List<ticket_model> studentlist = [];
  ticket_model? a;
  List<String>? both_id_and_Qr;
  String? studentPhoto;
  var singlestudent;
  List<bUS_Driver_model> driver = [];
  var singledriver;
  final _controller = ConfettiController();

  @override
  void initState() {
    super.initState();
    getstudentlist();
    AwesomeNotifications().requestPermissionToSendNotifications();
  }

  void getstudentlist() async {
    setState(() {
      isloading = true;
    });
    studentlist = await FirebaseFirestoreHelper.instance
        .studentget(widget.id, widget.qr_number);

    studentPhoto = await FirebaseFirestoreHelper.instance.studentphoto();
    ticket_model a = studentlist[0];
    singlestudent = a;
    driver = await FirebaseFirestoreHelper.instance.getBusDriver(widget.busid);
    bUS_Driver_model b = driver[0];
    singledriver = b;

    setState(() {
      isloading = false;
    });
  }

  sendnotification(String title, String subtitle) {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 10, channelKey: "basic_channel", title: title, body: subtitle),
        actionButtons: [
          NotificationActionButton(
            label: 'OK',
            enabled: true,
            key: 'test',
          )
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text("CONFIRM TICKET",style: TextStyle(
                    color:  Color.fromARGB(255, 15, 66, 107),
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),),
          ),
          body: isloading
              ? Center(
                  child: Container(
                    color: Colors.white,
                    height: 150,
                    width: 300,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                    alignment: Alignment.center,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Container(
                    height: 500,
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2.0),
                      border: Border.all(color: Colors.black, width: 3),
                    ),
                    child: Column(
                      //mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 50,
                          backgroundColor:
                               const Color.fromARGB(255, 134, 191, 220),
                          foregroundColor: Color.fromARGB(255, 15, 66, 107),
                          child: Icon(Icons.airplane_ticket),
                        ),
                        SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Ticket Number:',
                                      style: const TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 10.0),
                                  Text('From:',
                                      style: const TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text('To:',
                                      style: const TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 10.0),
                                  Text('Total Tickets Available:',
                                      style: const TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 10.0),
                                  Text('StartDate:',
                                      style: const TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 10.0),
                                  Text('EndDate:',
                                      style: const TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            const SizedBox(
                                width: 16.0), // Add space between columns
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  singlestudent.qrnumber,
                                  style: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  singlestudent.from,
                                  style: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  singlestudent.to,
                                  style: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  singlestudent.tickets,
                                  style: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  singlestudent.startdate.substring(0, 11),
                                  style: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  singlestudent.enddate.substring(0, 11),
                                  style: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: ElevatedButton(
                                    style:ElevatedButton.styleFrom(backgroundColor: 
                  
                  Color.fromARGB(255, 15, 66, 107)),
                                    onPressed: () async {
                                      bool a = await FirebaseFirestoreHelper
                                          .instance
                                          .decrementTicket();
                                      if (a) {
                                        await FirebaseFirestoreHelper.instance
                                            .mapactivation();
                                        await FirebaseFirestoreHelper.instance
                                            .AddTicket_History(
                                                singlestudent.qrnumber,
                                                singlestudent.id,
                                                singledriver.vehiclename,
                                                singledriver.vehiclenumber);
                                        ShowLoaderDialog(context);

                                        var tolatlng = await getLatLngFromPlace(
                                            singlestudent.to);
                                        var fromlatlng =
                                            await getcurrentlocation(context);
                                        storeLatLng("fromlatlng", fromlatlng);
                                        storeLatLng("tolatlng", tolatlng!);
                                        Navigator.pop(context);

                                        _controller.play();
                                        String location = singlestudent.from +
                                            " - " +
                                            singlestudent.to;
                                        sendnotification(
                                            "ticket activated sucessfully",
                                            location);

                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("sucessful"),
                                              content: Text(
                                                  "ticket activated sucessfully"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    _controller.stop();

                                                    Navigator.of(context).pop();
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              mapa()),
                                                    );
                                                  },
                                                  child: Text("OK"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                      if (a == false) {
                                        showCustomDialog(
                                            context: context,
                                            content: "NO TICKETS FOUND",
                                            buttonText: "CLOSE",
                                            navigateFrom: HomePage(),
                                            title: "ALERT");
                                      }
                                    },
                                    child: const Text(
                                      'APPROVE',
                                      style: TextStyle(
                                          color: wh,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        ),
        ConfettiWidget(
          confettiController: _controller,
          blastDirection: pi / 2,
          colors: [
             Color.fromARGB(255, 15, 66, 107),const Color.fromARGB(255, 134, 191, 220),
            Colors.white,
          ],
          emissionFrequency: 0.1,
          gravity: 0.1,
        )
      ],
    );
  }

  Future<void> storeLatLng(String preferencename, LatLng latLng) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final encodedString = encodeLatLng(latLng);
    await prefs.setString(preferencename, encodedString);
  }

  String encodeLatLng(LatLng latLng) {
    final latString = jsonEncode(latLng.latitude.toDouble());
    final lngString = jsonEncode(latLng.longitude.toDouble());
    return '$latString,$lngString';
  }

  Future<LatLng> getcurrentlocation(BuildContext content) async {
    ShowLoaderDialog(context);
    await Geolocator.checkPermission();
    // ignore: unused_local_variable
    LocationPermission ask = await Geolocator.requestPermission();

    Position currentposition = await Geolocator.getCurrentPosition();
    Navigator.pop(content);
    return LatLng(currentposition.latitude, currentposition.longitude);
  }

  Future<LatLng?> getLatLngFromPlace(String placeName) async {
    try {
      final locations = await locationFromAddress(placeName);
      if (locations.isNotEmpty) {
        final location = locations.first;
        return LatLng(location.latitude, location.longitude);
      } else {
        print('No results found for $placeName');
        return null;
      }
    } catch (e) {
      print('Error fetching location: $e');
      return null;
    }
  }
}
