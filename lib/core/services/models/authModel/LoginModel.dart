import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    this.status,
    this.message,
    this.data,
  });

  int status;
  String message;
  Data data;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.parentId,
    this.accessToken,
    this.loginId,
    this.firstName,
    this.lastName,
    this.displayAs,
    this.email,
    this.phone,
    this.cell,
    this.address1,
    this.address2,
    this.companyName,
    this.country,
    this.countryName,
    this.state,
    this.stateName,
    this.cityName,
    this.zipcode,
    this.masjidId,
    this.subdomainMapping,
  });

  dynamic parentId;
  String accessToken;
  String loginId;
  String firstName;
  String lastName;
  String displayAs;
  String email;
  dynamic phone;
  dynamic cell;
  dynamic address1;
  dynamic address2;
  dynamic companyName;
  dynamic country;
  dynamic countryName;
  dynamic state;
  String stateName;
  String cityName;
  String zipcode;
  dynamic masjidId;
  dynamic subdomainMapping;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        parentId: json["parent_id"],
        accessToken: json["access_token"],
        loginId: json["login_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        displayAs: json["display_as"],
        email: json["email"],
        phone: json["phone"],
        cell: json["cell"],
        address1: json["address1"],
        address2: json["address2"],
        companyName: json["company_name"],
        country: json["country"],
        countryName: json["country_name"],
        state: json["state"],
        stateName: json["state_name"],
        cityName: json["city_name"],
        zipcode: json["zipcode"],
        masjidId: json["masjid_id"],
        subdomainMapping: json["subdomain_mapping"],
      );

  Map<String, dynamic> toJson() => {
        "parent_id": parentId,
        "access_token": accessToken,
        "login_id": loginId,
        "first_name": firstName,
        "last_name": lastName,
        "display_as": displayAs,
        "email": email,
        "phone": phone,
        "cell": cell,
        "address1": address1,
        "address2": address2,
        "company_name": companyName,
        "country": country,
        "country_name": countryName,
        "state": state,
        "state_name": stateName,
        "city_name": cityName,
        "zipcode": zipcode,
        "masjid_id": masjidId,
        "subdomain_mapping": subdomainMapping,
      };
}

ParentData parentDataFromJson(String str) =>
    ParentData.fromJson(json.decode(str));

String parentDataToJson(ParentData data) => json.encode(data.toJson());

class ParentData {
  ParentData({
    this.parentId,
    this.accessToken,
    this.firstName,
    this.lastName,
    this.displayAs,
    this.masjidId,
  });

  dynamic parentId;
  dynamic accessToken;
  dynamic firstName;
  dynamic lastName;
  dynamic displayAs;
  dynamic masjidId;

  factory ParentData.fromJson(Map<String, dynamic> json) => ParentData(
        parentId: json["parent_id"],
        accessToken: json["access_token"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        displayAs: json["display_as"],
        masjidId: json["masjid_id"],
      );

  Map<String, dynamic> toJson() => {
        "parent_id": parentId,
        "access_token": accessToken,
        "first_name": firstName,
        "last_name": lastName,
        "display_as": displayAs,
        "masjid_id": masjidId,
      };

  String encode() => json.encode(this.toJson());

  static ParentData decode(String data) =>
      ParentData.fromJson(json.decode(data));
}
