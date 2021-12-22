import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weight_tracker/helpers/api_helper.dart';
import 'package:weight_tracker/model/api_services.dart';
import 'package:weight_tracker/model/user.dart';
import 'package:weight_tracker/providers/user_provider.dart';
import '../loading.dart';
import 'package:http/http.dart' as http;

import 'home.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //snackbar
  _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: Duration(seconds: 5),
      action: SnackBarAction(
        label: '',
        onPressed: () {},
      ),
    ));
  }

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String email = '';
  String name = '';
  String password = '';
  String confirmPassword = '';

  var _token;
  bool errorPassword = false;
  bool _isLoading = false;

  _createUser() async {
    dynamic data = {
      'name': nameController.text.trim(),
      'email': validateEmail(emailController),
      'password': passwordController.text.trim(),
    };
    print(data);
    var provider = Provider.of<UserProvider>(context, listen: false);
    var response = await APIHelper().createUser(data);
    print(response.message);
    if (response.isSuccessful) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('uid', response.data!.uid);
      provider.setUser(response.data as User);
      Navigator.popAndPushNamed(context, '/homepage');
    } else {
      _showMsg(response.message);
    }
  }

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

  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // signup("princeruz@gmail.com", "12345678");
    return _token != null
        ? Loading()
        : Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.black,
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(8, 50, 8, 8),
                color: Colors.teal[900],
                height: MediaQuery.of(context).size.height,
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
                        'Register',
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
                        padding: EdgeInsets.all(20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                    labelText: "Name", hintText: "Your name"),
                                controller: nameController,
                                onChanged: (value) => name = value,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                    labelText: "Email",
                                    hintText: "user@mail.co.za"),
                                controller: emailController,
                                onChanged: (value) => email = value,
                                validator: (value) => value!.isEmpty
                                    ? _showMsg('Please enter a valid email')
                                    : null,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                    labelText: "Password",
                                    hintText: "At least 8 characters"),
                                obscureText: true,
                                controller: passwordController,
                                onChanged: (value) => password = value,
                                validator: (value) => value!.length < 8
                                    ? _showMsg(
                                        'Password must contain at least 8 characters')
                                    : null,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                    labelText: "Confirm Password",
                                    hintText: "Must match first password"),
                                obscureText: true,
                                controller: confirmPasswordController,
                                onChanged: (value) => confirmPassword = value,
                                validator: (value) =>
                                    value!.length < 8 ? '' : null,
                              ),
                              password != confirmPassword
                                  ? Row(
                                      children: [
                                        Text(
                                          'Passwords do not match.',
                                        ),
                                      ],
                                    )
                                  : Text(''),
                              SizedBox(
                                height: 25,
                              ),
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
                                          //Action what should happened when button is clicked
                                          if (_formKey.currentState!
                                              .validate()) {
                                            if (password != confirmPassword) {
                                              _showMsg(
                                                  'Passwords do not match. Try again.');
                                            } else {
                                              _createUser();
                                            }
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            'Register',
                                          ),
                                        ),
                                      ),
                              ),
                              SizedBox(height: 20.0),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        'Already have an account?',
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          child: InkWell(
                                            onTap: () => Navigator.pop(
                                                context, '/login'),
                                            child: Text(
                                              'Login',
                                              style: TextStyle(
                                                color:Color(0xFF960E0E),
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
