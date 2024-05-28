import 'dart:convert';

ticket_model welcomeFromJson(String str) =>
    ticket_model.fromJson(json.decode(str));

String welcomeToJson(ticket_model data) => json.encode(data.toJson());

class ticket_model {
  String id;
  String qrnumber;
  String startdate;
  String enddate;
  String status;
  String from;
  String to;
  String tickets;

  ticket_model({
    required this.id,
    required this.qrnumber,
    required this.startdate,
    required this.enddate,
    required this.status,
    required this.from,
    required this.to,
    required this.tickets,
  });

  factory ticket_model.fromJson(Map<String, dynamic> json) => ticket_model(
        id: json["id"],
        qrnumber: json["qrnumber"],
        startdate: json["startdate"],
        enddate: json["enddate"],
        status: json["status"],
        from: json["from"],
        to: json["to"],
        tickets: json["tickets"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "qrnumber": qrnumber,
        "startdate": startdate,
        "enddate": enddate,
        "status": status,
        "from": from,
        "to": to,
        "tickets": tickets,
      };
}
