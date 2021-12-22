import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weight_tracker/model/http_response.dart';
import 'package:weight_tracker/model/user.dart';
import 'package:weight_tracker/model/weight.dart';

final String _url = "http://10.0.2.2:8081/api";

class APIHelper {
  _header() => {
        'Content-type': 'application/json',
        'Application': 'application/json',
      };
  // ignore: non_constant_identifier_names
  Future<HTTPResponse<User>> signInUser(dynamic data) async {
    String _fullApi = _url + "/login";
    dynamic body = json.encode(data);
    try {
      var response = await http.post(
        _fullApi,
        body: body,
        headers: _header(),
      );
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        User user = User.fromJson(body);
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('uid', user.uid);
        return HTTPResponse(true, user, response.statusCode, "Success");
      } else {
        return HTTPResponse(
            false, null, response.statusCode, "Invalid Response from server");
      }
    } on FormatException {
      return HTTPResponse(false, null, 400, "Invalid Response from server");
    } on SocketException {
      return HTTPResponse(
          false, null, 400, "Unable to connect to the internet");
    } catch (e) {
      return HTTPResponse(false, null, 400, "Something went wrong");
    }
  }

  // ignore: non_constant_identifier_names
  Future<HTTPResponse<User>> createUser(dynamic data) async {
    String _fullApi = _url + "/sign_up";
    dynamic body = json.encode(data);
    print(body);
    try {
      var response = await http.post(
        _fullApi,
        body: body,
        headers: _header(),
      );
      print(response.body);
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        User user = User.fromJson(body);
        return HTTPResponse(true, user, response.statusCode, "Success");
      } else {
        return HTTPResponse(
            false, null, response.statusCode, "Invalid Response from server");
      }
    } on FormatException {
      return HTTPResponse(false, null, 400, "Invalid Response from server");
    } on SocketException {
      return HTTPResponse(
          false, null, 400, "Unable to connect to the internet");
    } catch (e) {
      return HTTPResponse(false, null, 400, "Something went wrong");
    }
  }

  // ignore: non_constant_identifier_names
  Future<HTTPResponse<Weight>> addWeight(dynamic data, String token) async {
    print(data);
    String _fullApi = _url + "/save_weight";
    try {
      var response = await http.post(_fullApi,
          headers: {
        'Content-type': 'application/json',
        'Application': 'application/json',
        "x-token": token
      }, body: jsonEncode(data));
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        Weight weight = Weight.fromJson(body);

        return HTTPResponse(true, weight, response.statusCode, "Success");
        ;
      } else {
        return HTTPResponse(
            false, null, response.statusCode, "Invalid Response from server");
      }
    } on FormatException {
      return HTTPResponse(false, null, 400, "Invalid Response from server");
    } on SocketException {
      return HTTPResponse(false, null, 400, "Unable to connect to the internet");
    } catch (e) {print(e.toString());
      return HTTPResponse(false, null, 400, "Something went wrong");
    }
  }

  // ignore: non_constant_identifier_names
  Future<HTTPResponse<List<Weight>>> getWeights(String id) async {
    print("in getWeights");
    String _fullApi = _url + "/get_weight_history";
    try {
      var response = await http.get(
        _fullApi,
        headers: {
        'Content-type': 'application/json',
        'Application': 'application/json',
        "x-token": id
      },
      );
      
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        List<Weight> list = [];

        body.forEach((entry) {
          Weight weight = Weight.fromJson(entry);
          list.add(weight);
        });
        return HTTPResponse(true, list, response.statusCode, "Success");
        ;
      } else {
        return HTTPResponse(
            false, [], response.statusCode, "Invalid Response from server");
      }
    } on FormatException {
      return HTTPResponse(false, [], 400, "Invalid Response from server");
    } on SocketException {
      return HTTPResponse(false, [], 400, "Unable to connect to the internet");
    } catch (e) {
      return HTTPResponse(false, [], 400, "Something went wrong");
    }
  }
}
