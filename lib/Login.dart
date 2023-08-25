import 'dart:developer';

import 'package:demo_2/Forgot_password.dart';
import 'package:demo_2/Sign_up.dart';
import 'package:demo_2/a1.dart';
import 'package:demo_2/apiService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var user_id;
  ApiService apiService = ApiService();
  bool value = false;
  bool _showPassword = false;
  late SharedPreferences pref;
  final _formKey = GlobalKey<FormState>();
  RegExp pass_valid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  //A function that validate user entered password
  bool validatePassword(String pass) {
    String _password = pass.trim();
    if (pass_valid.hasMatch(_password)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    pref = await SharedPreferences.getInstance();
    user_id = pref.getString('id');
    if (user_id != null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => A1(),
          ),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              child: Image.asset(
                'assets/login.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Container(
                child: Text(
                  'Welcome Back',
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(55, 91, 70, 1)),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 15, left: 15, top: 25),
                    child: TextFormField(
                      controller: email,
                      validator: (value) {
                        String pattern =
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        RegExp regex = new RegExp(pattern);
                        if (value!.isEmpty || value == null) {
                          return "email is requird ";
                        } else if (!(regex.hasMatch(value))) {
                          return "Invalid Email";
                        }
                      },
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          prefixIcon: Icon(Icons.email_rounded,
                              color: Color.fromRGBO(55, 91, 70, 1)),
                          hintText: "Email"),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 15, left: 15, top: 15),
                    child: TextFormField(
                      controller: password,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter password';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock,
                              color: Color.fromRGBO(55, 91, 70, 1)),
                          hintText: "Enter Your Password",
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() =>
                                  this._showPassword = !this._showPassword);
                            },
                            child: Icon(
                              _showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: this._showPassword
                                  ? Color.fromRGBO(55, 91, 70, 1)
                                  : Colors.grey,
                            ),
                          )),
                      obscureText: !this._showPassword,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Checkbox(
                          value: value,
                          activeColor: Color.fromRGBO(55, 91, 70, 1),
                          hoverColor: Colors.red,
                          onChanged: (value) =>
                              setState(() => this.value = value!),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        child: Text(
                          "Remember Me",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 80, top: 15),
                        child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Forgot_password(),
                                  ));
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                  color: Color.fromRGBO(55, 91, 70, 1),
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15, top: 25),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          var param = new Map<String, dynamic>();
                          param['email'] = email.text;
                          param['password'] = password.text;
                          var resdata =
                              await apiService.postCall('users/login', param);
                          log('${resdata}');
                          if (resdata['success'] == 1) {
                            await pref.setString(
                                'id', resdata['data']['id'].toString());
                            await pref.setString(
                                'firstname', resdata['data']['firstname']);
                            await pref.setString(
                                'lastname', resdata['data']['lastname']);
                            await pref.setString(
                                'username', resdata['data']['username']);
                            await pref.setString(
                                'email', resdata['data']['email']);
                            await pref.setString(
                                'phonenumber', resdata['data']['phonenumber']);
                            await pref.setString(
                                'profile_img', resdata['data']['profile_img']);

                            await pref.setString('token', resdata['token']);

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Login Successfull"),
                              backgroundColor: Color.fromRGBO(55, 91, 70, 1),
                            ));
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => A1(),
                                ),
                                (route) => false);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(resdata['message']),
                              backgroundColor: Colors.red,
                            ));
                          }
                        }
                      },
                      child: Text(
                        "Login",
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(55, 91, 70, 1)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Text("Don't have an account?"),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Sign_up(),
                                  ));
                            },
                            child: Text(
                              "Sign up",
                              style: TextStyle(
                                  color: Color.fromRGBO(55, 91, 70, 1),
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
