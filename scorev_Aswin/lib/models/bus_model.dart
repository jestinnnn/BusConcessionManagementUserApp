import 'dart:convert';

Bus_model welcomeFromJson(String str) => Bus_model.fromJson(json.decode(str));

String welcomeToJson(Bus_model data) => json.encode(data.toJson());

class Bus_model {
  String from;
  String mainroute;
  String to;

  Bus_model({
    required this.from,
    required this.mainroute,
    required this.to,
  });

  factory Bus_model.fromJson(Map<String, dynamic> json) => Bus_model(
        from: json["from"],
        mainroute: json["mainroute"],
        to: json["to"],
      );

  Map<String, dynamic> toJson() => {
        "from": from,
        "mainroute": mainroute,
        "to": to,
      };
}
