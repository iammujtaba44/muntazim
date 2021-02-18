// To parse this JSON data, do
//
//     final accountModel = accountModelFromJson(jsonString);

import 'dart:convert';

AccountModel accountModelFromJson(String str) =>
    AccountModel.fromJson(json.decode(str));

String accountModelToJson(AccountModel data) => json.encode(data.toJson());

class AccountModel {
  AccountModel({
    this.address1,
    this.address2,
    this.cell,
    this.cityName,
    this.country,
    this.email,
    this.firstName,
    this.lastName,
    this.loginId,
    this.masjidId,
    this.parentId,
    this.phone,
    this.schools,
    this.state,
    this.students,
    this.username,
    this.zipcode,
  });

  String address1;
  String address2;
  String cell;
  String cityName;
  dynamic country;
  String email;
  String firstName;
  String lastName;
  String loginId;
  dynamic masjidId;
  dynamic parentId;
  String phone;
  Map<String, String> schools;
  dynamic state;
  Map<String, String> students;
  String username;
  String zipcode;

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
        address1: json["address1"],
        address2: json["address2"],
        cell: json["cell"],
        cityName: json["city_name"],
        country: json["country"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        loginId: json["login_id"],
        masjidId: json["masjid_id"],
        parentId: json["parent_id"],
        phone: json["phone"],
        schools: Map.from(json["schools"])
            .map((k, v) => MapEntry<String, String>(k, v)),
        state: json["state"],
        students: Map.from(json["students"])
            .map((k, v) => MapEntry<String, String>(k, v)),
        username: json["username"],
        zipcode: json["zipcode"],
      );

  Map<String, dynamic> toJson() => {
        "address1": address1,
        "address2": address2,
        "cell": cell,
        "city_name": cityName,
        "country": country,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "login_id": loginId,
        "masjid_id": masjidId,
        "parent_id": parentId,
        "phone": phone,
        "schools":
            Map.from(schools).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "state": state,
        "students":
            Map.from(students).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "username": username,
        "zipcode": zipcode,
      };
}

class Schools {
  Schools({
    this.the37,
  });

  String the37;

  factory Schools.fromJson(Map<String, dynamic> json) => Schools(
        the37: json["37"],
      );

  Map<String, dynamic> toJson() => {
        "37": the37,
      };
}
