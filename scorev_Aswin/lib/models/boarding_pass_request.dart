import 'dart:convert';

BoardingPassRequestModel welcomeFromJson(String str) =>
    BoardingPassRequestModel.fromJson(json.decode(str));

String welcomeToJson(BoardingPassRequestModel data) =>
    json.encode(data.toJson());

class BoardingPassRequestModel {
  String id;
  String name;

  String phonenumber;
  String email;
  String adharcard;
  String institutionid;
  String incomecirtificate;
  String photo;
  String boardinglocation;
  String district;
  String institution;
  String bustype;
  String course;
  String collegebusstoplocation;
  String adress;
  String dob;
  String durationofcourse;
  String message;

  String status;
  String price;
  String accademicYear;

  String dateofissue;
  String dateofexpiry;

  BoardingPassRequestModel({
    required this.id,
    required this.name,
    required this.phonenumber,
    required this.email,
    required this.adharcard,
    required this.institutionid,
    required this.incomecirtificate,
    required this.photo,
    required this.boardinglocation,
    required this.district,
    required this.institution,
    required this.bustype,
    required this.course,
    required this.collegebusstoplocation,
    required this.adress,
    required this.dob,
    required this.durationofcourse,
    required this.message,
    required this.status,
    required this.price,
    required this.accademicYear,
    required this.dateofissue,
    required this.dateofexpiry,
  });

  factory BoardingPassRequestModel.fromJson(Map<String, dynamic> json) =>
      BoardingPassRequestModel(
        id: json["id"],
        name: json["name"],
        phonenumber: json["phonenumber"],
        email: json["email"],
        adharcard: json["adharcard"],
        institutionid: json["institutionid"],
        incomecirtificate: json["incomecirtificate"],
        photo: json["photo"],
        boardinglocation: json["boardinglocation"],
        district: json["district"],
        institution: json["institution"],
        bustype: json["bustype"],
        course: json["course"],
        collegebusstoplocation: json["collegebusstoplocation"],
        adress: json["adress"],
        dob: json["dob"],
        durationofcourse: json["durationofcourse"],
        message: json["message"],
        status: json["status"],
        price: json["price"],
        accademicYear: json["accademicYear"],
        dateofissue: json["dateofissue"],
        dateofexpiry: json["dateofexpiry"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": name,
        "phonenumber": phonenumber,
        "email": email,
        "adharcard": adharcard,
        "institutionid": institutionid,
        "incomecirtificate": incomecirtificate,
        "photo": photo,
        "boardinglocation": boardinglocation,
        "district": district,
        "institution": institution,
        "bustype": bustype,
        "course": course,
        "collegebusstoplocation": collegebusstoplocation,
        "adress": adress,
      };
}
