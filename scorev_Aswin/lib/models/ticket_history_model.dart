import 'dart:convert';

Ticket_history_model welcomeFromJson(String str) =>
    Ticket_history_model.fromJson(json.decode(str));

String welcomeToJson(Ticket_history_model data) => json.encode(data.toJson());

class Ticket_history_model {
  String busname;
  String busnumber;
  DateTime dateandtime;
  String id;
  String qrnumber;

  Ticket_history_model({
    required this.busname,
    required this.busnumber,
    required this.dateandtime,
    required this.id,
    required this.qrnumber,
  });

  factory Ticket_history_model.fromJson(Map<String, dynamic> json) =>
      Ticket_history_model(
        busname: json["busname"],
        busnumber: json["busnumber"],
        dateandtime: DateTime.parse(json["dateandtime"]),
        id: json["id"],
        qrnumber: json["qrnumber"],
      );

  Map<String, dynamic> toJson() => {
        "busname": busname,
        "busnumber": busnumber,
        "dateandtime": dateandtime.toIso8601String(),
        "id": id,
        "qrnumber": qrnumber,
      };
}
