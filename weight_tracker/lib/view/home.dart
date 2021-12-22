import 'dart:convert';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weight_tracker/helpers/api_helper.dart';
import 'package:weight_tracker/model/api_services.dart';
import 'package:weight_tracker/model/weight.dart';
import 'package:weight_tracker/providers/user_provider.dart';
import 'package:weight_tracker/providers/weight_provider.dart';
import '../nav_drawer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late bool _isLoading = false;
  late double weight;
  var color = Color(0xFF960E0E);

  TextEditingController weightController = TextEditingController();
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();

  _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: Duration(seconds: 2),
      action: SnackBarAction(
        label: '',
        onPressed: () {},
      ),
    ));
  }

  saveWeight() async {
    var provider = Provider.of<WeightProvider>(context, listen: false);
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    dynamic data = {
      'weight': weight,
    };
    var response = await APIHelper().addWeight(data, userProvider.user.token);
    if (response.isSuccessful) {
      provider.setWeight(response.data as Weight);
    } else {
      _showMsg(response.message);
    }
  }

  _getWeightHistory() async {
    var provider = Provider.of<WeightProvider>(context, listen: false);
    var userProvider = Provider.of<UserProvider>(context, listen: false);

    var response = await APIHelper().getWeights(userProvider.user.token);
    print("in _getWeightHistory response: ${response.data}");
    if (response.isSuccessful) {
      provider.setWeightHistory(response.data as List<Weight>);
    } else {
      _showMsg(response.message);
    }
    provider.isLoadingWeight(false);
  }

  getFormattedDateFromFormattedString(
      {required value,
      required String currentFormat,
      required String desiredFormat,
      isUtc = false}) {
    DateTime? dateTime = DateTime.now();
    if (value != null || value.isNotEmpty) {
      try {
        dateTime = DateFormat(currentFormat).parse(value, isUtc).toLocal();
      } catch (e) {
        print("$e");
      }
    }
    return dateTime;
  }

  void initState() {
    super.initState();
    _getWeightHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(0, 64, 0, 4),
          color: Colors.teal[50],
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Consumer<UserProvider>(
                builder: (cont, provider, wigd) => Text(
                      'Hi ${provider.user.name}',
                      style: TextStyle(color: Colors.teal[800], fontSize: 24),
                    )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 4.0),
                  margin: EdgeInsets.only(top: 12),
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: "Weight", hintText: "5.67"),
                      style: TextStyle(backgroundColor: Colors.teal[50]),
                      controller: weightController,
                      validator: (value) => value!.length == 0
                          ? _showMsg('Weight may not be empty')
                          : null,
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.only(top: 12),
                  padding: EdgeInsets.only(right: 4.0),
                  width: MediaQuery.of(context).size.width * 0.4,
                  color: Colors.black,
                  child: _isLoading
                      ? Center(
                          child: Text(
                          "Saving...",
                          style: TextStyle(color: Colors.white),
                        ))
                      : ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFF960E0E)),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                weight =
                                    double.parse(weightController.text.trim());
                                weight.toStringAsExponential();
                              });

                              if (weight <= 0) {
                                _showMsg('Weight must be greater than 0.');
                              } else if (weight.runtimeType != double) {
                                _showMsg('Incorrect format. Enter a number');
                              } else {
                                saveWeight();
                              }
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              'Save',
                            ),
                          ),
                        ),
                ),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Center(
                child: Consumer<WeightProvider>(
                    builder: (cont, provider, wigd) => provider == 0
                        ? Text(
                            "Add Weight",
                            style: TextStyle(
                              backgroundColor: color,
                            ),
                          )
                        : (Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Text(
                                  provider.weight.weight.toString(),
                                  style: TextStyle(
                                      fontSize: 60,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  " Kg",
                                  style: TextStyle(
                                      fontSize: 40,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold),
                                ),
                              ]))),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Consumer<WeightProvider>(
                  builder: (cont, provider, wigd) => provider.loadingWeight
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(itemBuilder: (_, i) {
                          itemCount:
                          provider.weightHistory.length;
                          Weight wght = provider.getWeightByIndex(i);
                          print("${wght}");
                          return ListTile(
                            title: Text('${wght.weight} kg', style: TextStyle(color: Colors.teal[900], fontSize: 16, fontWeight: FontWeight.w800)),
                            subtitle: Text(
                                "${getFormattedDateFromFormattedString(value: wght.createdAt, currentFormat: "yyyy-MM-ddTHH:mm:ssZ", desiredFormat: "dd-MMMM-yyyy HH:mm")}",
                                 style: TextStyle(color: Colors.teal[600], fontSize: 12)
                                ),
                          );
                        })),
            )
          ]),
        ),
      ),
    );
  }
}
