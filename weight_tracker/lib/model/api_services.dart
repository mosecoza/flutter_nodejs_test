import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weight_tracker/model/weight.dart';

class Api {
  _header() => {
        'Content-type': 'application/json',
        'Application': 'application/json',
      };

  final String _url = "http://10.0.2.2:8080/api/v1";
  //post data to server

  Future postData(data, route) async {
    print("Api route $route");
    print("Api data $data");
    String _fullApi = _url + route;
    dynamic body = json.encode(data);
    var response = await http.post(
      _fullApi,
      body: body,
      headers: _header(),
    );
    Map<String, dynamic> map = jsonDecode(response.body);
    print("Api res ${map.toString()}");
    return Weight.fromJson(map);
  }


  //post data to server
  updateData(data, route) async {
    String _fullApi = _url + route;

    var response = await http.put(
      _fullApi,
      body: json.encode(data),
      headers: _header(),
    );
    return response;
  }

  //get data from server
  getData(route) async {
    String _fullApi = _url + route;
    var response = await http.get(
      _fullApi,
      headers: _header(),
    );
    return response;
  }

  deleteData(route) async {
    String _fullApi = _url + route;
    var response = await http.delete(
      _fullApi,
      headers: _header(),
    );
    return response;
  }
}
