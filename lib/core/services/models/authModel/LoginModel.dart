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
    this.city,
    this.zipcode,
  });

  String parentId;
  String accessToken;
  String loginId;
  String firstName;
  String lastName;
  String displayAs;
  String email;
  String phone;
  String cell;
  String address1;
  String address2;
  String companyName;
  String country;
  String countryName;
  String state;
  dynamic stateName;
  String city;
  String zipcode;

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
        city: json["city"],
        zipcode: json["zipcode"],
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
        "city": city,
        "zipcode": zipcode,
      };
}
