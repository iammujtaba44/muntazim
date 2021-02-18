import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'package:muntazim/core/plugins.dart';

class Auth extends ResponseState {
  Future<ResponseState> login({String username, String password}) async {
    try {
      Response response = await http.post(API.LOGIN_URL,
          body: {'username': username, 'password': password});
      if (jsonDecode(response.body)['status'] == 200) {
        // print(jsonDecode(response.body)['message']);
        return LoadedState(data: loginModelFromJson(response.body));
      } else {
        // print(jsonDecode(response.body)['message']);
        return ListError(
            error: ErrorResponse(jsonDecode(response.body)['message']));
      }
      ;
    } on SocketException {
      // print('No Internet');
      return ListError(error: NoInternetException("No Internet"));
    } on HttpException {
      // print('No service');
      return ListError(error: HttpException("No Service found"));
      ;
    } on FormatException {
      return ListError(
        error: InvalidFormatException('Invalid Response format'),
      );
    } catch (e) {
      return ListError(
        error: UnknownException('Unknown Error'),
      );
    }
  }
}

class Database {}
