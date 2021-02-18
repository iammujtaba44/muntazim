// To parse this JSON data, do
//
//     final schoolModel = schoolModelFromJson(jsonString);

import 'dart:convert';

SchoolModel schoolModelFromJson(String str) =>
    SchoolModel.fromJson(json.decode(str));

String schoolModelToJson(SchoolModel data) => json.encode(data.toJson());

class SchoolModel {
  SchoolModel({
    this.country,
    this.cityName,
    this.schoolYears,
    this.schoolId,
    this.address2,
    this.address1,
    this.logo,
    this.schoolName,
    this.state,
    this.masjidId,
    this.status,
  });

  dynamic country;
  String cityName;
  // Map<dynamic, dynamic> schoolYears;
  Map<String, SchoolYear> schoolYears;
  dynamic schoolId;
  String address2;
  String address1;
  String logo;
  String schoolName;
  dynamic state;
  dynamic masjidId;
  dynamic status;

  factory SchoolModel.fromJson(Map<String, dynamic> json) => SchoolModel(
        country: json["country"],
        cityName: json["city_name"],
        schoolYears: Map.from(json["school_years"]).map(
            (k, v) => MapEntry<String, SchoolYear>(k, SchoolYear.fromJson(v))),
        schoolId: json["school_id"],
        address2: json["address2"],
        address1: json["address1"],
        logo: json["logo"],
        schoolName: json["school_name"],
        state: json["state"],
        masjidId: json["masjid_id"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "country": country,
        "city_name": cityName,
        "school_years": schoolYears,
        "school_id": schoolId,
        "address2": address2,
        "address1": address1,
        "logo": logo,
        "school_name": schoolName,
        "state": state,
        "masjid_id": masjidId,
        "status": status,
      };
}

// class Schoolyear {
//   Schoolyear({
//     this.schoolYears,
//   });
//
//   Map<String, SchoolYear> schoolYears;
//
//   factory Schoolyear.fromJson(Map<String, dynamic> json) => Schoolyear(
//     schoolYears: Map.from(json["school_years"]).map((k, v) => MapEntry<String, SchoolYear>(k, SchoolYear.fromJson(v))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "school_years": Map.from(schoolYears).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
//   };
// }

class SchoolYear {
  SchoolYear({
    this.schoolEvents,
  });

  Map<String, String> schoolEvents;

  factory SchoolYear.fromJson(Map<String, dynamic> json) => SchoolYear(
        schoolEvents: Map.from(json["school_events"])
            .map((k, v) => MapEntry<String, String>(k, v)),
      );

  Map<String, dynamic> toJson() => {
        "school_events": Map.from(schoolEvents)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}
