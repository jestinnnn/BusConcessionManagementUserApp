import 'dart:convert';

bUS_Driver_model welcomeFromJson(String str) =>
    bUS_Driver_model.fromJson(json.decode(str));

String welcomeToJson(bUS_Driver_model data) => json.encode(data.toJson());

class bUS_Driver_model {
  String id;
  String vehiclename;

  String vehiclenumber;

  bUS_Driver_model({
    required this.vehiclename,
    required this.id,
    required this.vehiclenumber,
  });

  factory bUS_Driver_model.fromJson(Map<String, dynamic> json) =>
      bUS_Driver_model(
        vehiclename: json["vehiclename"],
        id: json["id"],
        vehiclenumber: json["vehiclenumber"],
      );

  Map<String, dynamic> toJson() => {
        "vehiclename": vehiclename,
        "id": id,
        "vehiclenumber": vehiclenumber,
      };
}
