import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:score/constants/constants.dart';
import 'package:score/models/boarding_pass_request.dart';
import 'package:score/models/bus_model.dart';
import 'package:score/models/bus_owner_model.dart';
import 'package:score/models/ticket.dart';
import 'package:score/models/ticket_history_model.dart';

import 'package:shared_preferences/shared_preferences.dart';

class FirebaseFirestoreHelper {
  static FirebaseFirestoreHelper instance = FirebaseFirestoreHelper();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  String studentid = "";
  String qr_number = "";

  Future<List<BoardingPassRequestModel>> getonbardings() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? action = prefs.getString('userid');
      QuerySnapshot<Map<String, dynamic>> querrysnapshot =
          await _firebaseFirestore
              .collection("users")
              .doc(action)
              .collection("boardingRequest")
              .get();

      List<BoardingPassRequestModel> boardingrequestdetails = querrysnapshot
          .docs
          .map((e) => BoardingPassRequestModel.fromJson(e.data()))
          .toList();
      return boardingrequestdetails;
    } catch (e) {
      showmessage(e.toString());
      print(e.toString());
      return [];
    }
  }

  Future<List<Bus_model>> getbusdetails(String from, String to) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querrysnapshot =
          await _firebaseFirestore
              .collection("buses")
              .where("from", isEqualTo: from)
              .where("to", isEqualTo: to)
              .get();

      List<Bus_model> boardingrequestdetails =
          querrysnapshot.docs.map((e) => Bus_model.fromJson(e.data())).toList();
      return boardingrequestdetails;
    } catch (e) {
      showmessage(e.toString());
      print(e.toString());
      return [];
    }
  }

//check if pass is active
  Future<bool> checkIsBoardingActive() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? action = prefs.getString('userid');
      var querrysnapshot = await _firebaseFirestore
          .collection("users")
          .doc(action)
          .collection("boardingRequest")
          .doc(action)
          .get();
      var imageUrl = querrysnapshot.data()?["status"];
      if (imageUrl == "approved") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  //adding data to the booked tickets
  Future<void> AddTicket(String from, String to, DateTime startdate,
      DateTime enddate, int tickets) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userid = prefs.getString('userid');
    Random random = Random();
    int id = random.nextInt(1000);

    _firebaseFirestore
        .collection("users")
        .doc(userid)
        .collection("activetickets")
        .add({
      "id": userid,
      "qrnumber": id.toString(),
      "startdate": startdate.toString(),
      "enddate": enddate.toString(),
      "status": "inactive",
      "from": from,
      "to": to,
      "tickets": tickets.toString()
    });
  }

//ticket model
  Future<List<ticket_model>> getticket() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? action = prefs.getString('userid');
      QuerySnapshot<Map<String, dynamic>> querrysnapshot =
          await _firebaseFirestore
              .collection("users")
              .doc(action)
              .collection("activetickets")
              .where("tickets", isNotEqualTo: "0")
              .get();

      List<ticket_model> boardingrequestdetails = querrysnapshot.docs
          .map((e) => ticket_model.fromJson(e.data()))
          .toList();
      return boardingrequestdetails;
    } catch (e) {
      showmessage(e.toString());
      print(e.toString());
      return [];
    }
  }

  Future<void> mapactivation() async {
    var querySnapshot = await _firebaseFirestore.collection("map").get();

    for (var doc in querySnapshot.docs) {
      await _firebaseFirestore
          .collection("map")
          .doc(doc.id)
          .update({"status": "active"});
    }
  }

  Future<bool> decrementTicket() async {
    var querySnapshot = await _firebaseFirestore
        .collection("users")
        .doc(studentid)
        .collection("activetickets")
        .where("qrnumber", isEqualTo: qr_number)
        .get();

    for (var doc in querySnapshot.docs) {
      String currentTicketsString = doc.get("tickets");

      int currentTickets = int.tryParse(currentTicketsString) ?? 0;

      if (currentTickets > 0) {
        int updatedTickets = currentTickets - 1;

        await _firebaseFirestore
            .collection("users")
            .doc(studentid)
            .collection("activetickets")
            .doc(doc.id)
            .update({"tickets": updatedTickets.toString()});
      } else {
        if (currentTickets <= 0) {
          return false;
        }
      }
    }

    return true;
  }

  Future<List<ticket_model>> studentget(String id, String qrnumber) async {
    studentid = id;
    qr_number = qrnumber;
    try {
      QuerySnapshot<Map<String, dynamic>> querrysnapshot =
          await _firebaseFirestore
              .collection("users")
              .doc(id)
              .collection("activetickets")
              .where("qrnumber", isEqualTo: qrnumber)
              .get();

      List<ticket_model> boardingrequestdetails = querrysnapshot.docs
          .map((e) => ticket_model.fromJson(e.data()))
          .toList();
      return boardingrequestdetails;
    } catch (e) {
      showmessage(e.toString());
      print(e.toString());
      return [];
    }
  }

  Future<String> studentphoto() async {
    var querrysnapshot =
        await _firebaseFirestore.collection("users").doc(studentid).get();
    var imageUrl = querrysnapshot.data()?["photo"];

    return imageUrl;
  }

  Future<List<bUS_Driver_model>> getBusDriver(String id) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querrysnapshot =
          await _firebaseFirestore
              .collection("busowner")
              .where("id", isEqualTo: id)
              .get();

      List<bUS_Driver_model> boardingrequestdetails = querrysnapshot.docs
          .map((e) => bUS_Driver_model.fromJson(e.data()))
          .toList();
      return boardingrequestdetails;
    } catch (e) {
      showmessage(e.toString());
      print(e.toString());
      return [];
    }
  }

  Future<void> AddTicket_History(
    String qrnumber,
    String id,
    String busname,
    String busnumber,
  ) async {
    final DateTime now = DateTime.now();

    String timedate =
        "${now.year}-${_formatNumber(now.month)}-${_formatNumber(now.day)} ${_formatNumber(now.hour)}:${_formatNumber(now.minute)}:${_formatNumber(now.second)}";

    _firebaseFirestore
        .collection("users")
        .doc(id)
        .collection("tickethistory")
        .add({
      "qrnumber": qrnumber.toString(),
      "id": id,
      "busname": busname,
      "busnumber": busnumber,
      "dateandtime": timedate,
    });
  }

  String _formatNumber(int number) {
    return number.toString().padLeft(2, '0');
  }

  Future<List<Ticket_history_model>> get_ticket_history() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? action = prefs.getString('userid');
      QuerySnapshot<Map<String, dynamic>> querrysnapshot =
          await _firebaseFirestore
              .collection("users")
              .doc(action)
              .collection("tickethistory")
              .get();

      List<Ticket_history_model> boardingrequestdetails = querrysnapshot.docs
          .map((e) => Ticket_history_model.fromJson(e.data()))
          .toList();
      return boardingrequestdetails;
    } catch (e) {
      showmessage(e.toString());
      print(e.toString());
      return [];
    }
  }

  Future<void> Register_Complaint(String title, String body) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userid = prefs.getString('userid');
    final String? emailid = prefs.getString('email');
    final DateTime now = DateTime.now();

    String timedate =
        "${now.year}-${_formatNumber(now.month)}-${_formatNumber(now.day)} ${_formatNumber(now.hour)}:${_formatNumber(now.minute)}:${_formatNumber(now.second)}";

    _firebaseFirestore.collection("complaints").add({
      "id": userid,
      "email": emailid,
      "title": title,
      "body": body,
      "datetime": timedate,
    });
  }

  Future<int> Boarding_ticket_cost() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? action = prefs.getString('userid');
      var querrysnapshot = await _firebaseFirestore
          .collection("users")
          .doc(action)
          .collection("boardingRequest")
          .doc(action)
          .get();
      var cost = querrysnapshot.data()?["price"];
      int price = int.parse(cost);
      return price;
    } catch (e) {
      return 0;
    }
  }

  Future<List<String>> fetchInstitutionNames() async {
    List<String> names = [];

    try {
      CollectionReference institutions =
          FirebaseFirestore.instance.collection('institutions');

      QuerySnapshot querySnapshot = await institutions.get();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        String name = data['institutionname'];
        names.add(name);
      }
    } catch (e) {
      print("Error fetching institution names: $e");
    }
    names.add('Select Institute');

    return names;
  }

  //ticket model
  Future<List<ticket_model>> getexpiredticket() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? action = prefs.getString('userid');
      QuerySnapshot<Map<String, dynamic>> querrysnapshot =
          await _firebaseFirestore
              .collection("users")
              .doc(action)
              .collection("activetickets")
              .where("tickets", isEqualTo: "0")
              .get();

      List<ticket_model> boardingrequestdetails = querrysnapshot.docs
          .map((e) => ticket_model.fromJson(e.data()))
          .toList();
      return boardingrequestdetails;
    } catch (e) {
      showmessage(e.toString());
      print(e.toString());
      return [];
    }
  }
   Future<void>Pricehistory(String from, String to, DateTime startdate,String price,String ticketnumber,
      DateTime enddate,String name,String email,String id) async {

   
  

    _firebaseFirestore
        .collection("pricehistory")
        .doc(id).set({
      "from": from,
      "to": to,
      "startdate": startdate.toString(),
      "enddate": enddate.toString(),
      "qrnumber":ticketnumber,
      "price": price,
      "name": name,
      "email": email,
      "id":id
    });
  }
}
