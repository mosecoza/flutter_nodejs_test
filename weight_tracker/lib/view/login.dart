import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weight_tracker/helpers/api_helper.dart';
import 'package:weight_tracker/model/api_services.dart';
import 'package:weight_tracker/model/user.dart';
import 'package:weight_tracker/providers/user_provider.dart';
import 'package:weight_tracker/view/sign_up.dart';

import '../loading.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
  void onLoad(BuildContext context) {}
}

class _LoginState extends State<Login> {
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

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String email = '';
  String password = '';
  var _token;

  String? validateEmail(TextEditingController eController) {
    String e;
    e = eController.text.trim().toLowerCase();
    if (e.contains('@') &&
        (e.endsWith('.com') || e.endsWith('.co.za') || e.endsWith('.bw'))) {
      return e;
    } else {
      return null;
    }
  }

  bool _isLoading = false;

  _getUser() async {
    dynamic data = {
      'email': validateEmail(emailController),
      'password': passwordController.text.trim(),
    };
    var provider = Provider.of<UserProvider>(context, listen: false);
    var response = await APIHelper().signInUser(data);
    if (response.isSuccessful) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('uid', response.data!.uid);
      provider.setUser(response.data as User);
      Navigator.popAndPushNamed(context, '/homepage');
    } else {
      _showMsg(response.message);
    }
  }

  void initState() {
    super.initState();
    _isLoggedIn();
  }

  _isLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = localStorage.getString("uid");
    if (user!.isNotEmpty) {
      print(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenH = MediaQuery.of(context).size.height;

    return _token != null
        ? Loading()
        : Scaffold(
            key: _scaffoldKey,
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(8, 50, 8, 8),
                color: Colors.teal[900],
                height: screenH,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 12),
                    Column(children: [
                        Text(
                          'Weight Tracker',
                          style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              color: Colors.white),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ]),
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                           
                            borderRadius:
                                BorderRadius.all(Radius.circular(24))),
                        alignment: AlignmentDirectional.bottomCenter,
                        margin: EdgeInsets.only(top: 25.0),
                        padding: EdgeInsets.all(20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                color: Colors.white,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      labelText: "Email",
                                      hintText: "user@mail.co.za"),
                                  controller: emailController,
                                  onChanged: (value) => email = value,
                                  validator: (value) => value!.isEmpty
                                      ? _showMsg('Enter a valid email.')
                                      : null,
                                ),
                              ),
                              SizedBox(height: 4),
                              Container(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      labelText: "Password",
                                      hintText: "At least 8 characters"),
                                  controller: passwordController,
                                  obscureText: true,
                                  validator: (value) => value!.length < 8
                                      ? _showMsg(
                                          'Password must contain at least 8 characters.')
                                      : null,
                                  onChanged: (value) => password = value,
                                ),
                              ),
                              SizedBox(height: 50),
                              Container(
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                ),
                                child: _isLoading == true
                                    ? Text("Loading")
                                    : ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Color(0xFF960E0E)),
                                        ),
                                        onPressed: () async {
                                          // Action what should happened when button is clicked
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _getUser();
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            'Login',
                                          ),
                                        ),
                                      ),
                              ),
                              SizedBox(height: 25),
                              Container(
                                padding: EdgeInsets.only(top: 10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'Do not have an account?',
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    //Action what should happen when link is pressed
                                                    Navigator.push(
                                                      context,
                                                      new MaterialPageRoute(
                                                          builder: (context) =>
                                                              SignUp()),
                                                    );
                                                  },
                                                  child: Container(
                                                    child: Text(
                                                      'Register',
                                                      style: TextStyle(
                                                        color: Color(0xFF960E0E),
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            ),
          );
  }
}
