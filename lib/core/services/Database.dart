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
      } else if (jsonDecode(response.body)['status'] == 402) {
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

  Future<ResponseState> signOut({BuildContext context}) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    String url = API.SIGNOUT_URL
        .replaceAll('[pId]', "${user.parentData.parentId}")
        .replaceAll('[mId]', "${user.parentData.masjidId}");
    try {
      Response response = await http.get(url,
          headers: {'access-token': user.parentData.accessToken.toString()});
      print(response.body);
      if (jsonDecode(response.body)['status'] == 200) {
        user.removeAs();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => LoginScreen()));
        // return LoadedState(data: loginModelFromJson(response.body));
      } else if (jsonDecode(response.body)['status'] == 402) {
        // print(jsonDecode(response.body)['message']);
        return ListError(
            error: ErrorResponse(jsonDecode(response.body)['message']));
      }
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
