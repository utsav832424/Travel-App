import 'dart:developer';

import 'package:demo_2/Login.dart';
import 'package:demo_2/a1.dart';
import 'package:demo_2/apiService.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:form_validator/form_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sign_up extends StatefulWidget {
  Sign_up({Key? key}) : super(key: key);

  @override
  State<Sign_up> createState() => _Sign_upState();
}

class _Sign_upState extends State<Sign_up> {
  ApiService apiService = ApiService();

  bool _Password = false;
  bool _ConfirmPassword = false;
  GlobalKey<FormState> _fromkey = GlobalKey<FormState>();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone_number = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirm_password = TextEditingController();
  var confirmpass;
  RegExp pass_valid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _fromkey,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                child: Image.asset(
                  'assets/signup.webp',
                  height: 150,
                  width: 160,
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text(
                    "Register",
                    style: TextStyle(
                        fontSize: 40,
                        color: Color.fromRGBO(55, 91, 70, 1),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Center(
                child: Container(
                  child: Text(
                    'Create your new account',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 15, left: 15, top: 20),
                      child: TextFormField(
                        controller: firstname,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter First Name";
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person_add_alt_sharp,
                              color: Color.fromRGBO(55, 91, 70, 1)),
                          hintText: "Enter First Name",
                          label: Text("First Name"),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 15, left: 15, top: 20),
                      child: TextFormField(
                        controller: lastname,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter Lastname";
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person_add_alt_sharp,
                              color: Color.fromRGBO(55, 91, 70, 1)),
                          hintText: "Enter last Name",
                          label: Text("Last Name"),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 15, left: 15, top: 20),
                      child: TextFormField(
                        controller: username,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter Username";
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person,
                              color: Color.fromRGBO(55, 91, 70, 1)),
                          hintText: "Full Name",
                          label: Text("Username"),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 15, left: 15, top: 20),
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
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email_rounded,
                              color: Color.fromRGBO(55, 91, 70, 1)),
                          hintText: "Enter Email",
                          label: Text("Email"),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 15, left: 15, top: 20),
                      child: IntlPhoneField(
                        controller: phone_number,
                        validator: (value) {
                          if (value == null) {
                            return "Enter PhoneNumber";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                        ),
                        initialCountryCode: 'IN',
                        onChanged: (phone) {
                          print(phone.completeNumber);
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 15, left: 15, top: 20),
                      child: TextFormField(
                        controller: password,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter password';
                          } else if (value.length < 8) {
                            return "Password must be atleast 8 characters long";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock,
                              color: Color.fromRGBO(55, 91, 70, 1)),
                          hintText: "Enter Password",
                          label: Text("Password"),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() => _Password = !_Password);
                            },
                            child: Icon(
                              _Password
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: this._Password
                                  ? Color.fromRGBO(55, 91, 70, 1)
                                  : Colors.grey,
                            ),
                          ),
                        ),
                        obscureText: !_Password,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          right: 15, left: 15, top: 20, bottom: 5),
                      child: TextFormField(
                        controller: confirm_password,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Password";
                          } else if (value.length < 8) {
                            return "Password must be atleast 8 characters long";
                          } else if (value != password.text) {
                            return "Password must be same as above";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock,
                                color: Color.fromRGBO(55, 91, 70, 1)),
                            hintText: "Enter Confirm Password",
                            label: Text("Confirm Password"),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                // setState(() =>
                                //     this._ConfirmPassword = !this._ConfirmPassword);
                                setState(() {
                                  _ConfirmPassword = !_ConfirmPassword;
                                });
                              },
                              child: Icon(
                                _ConfirmPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: this._ConfirmPassword
                                    ? Color.fromRGBO(55, 91, 70, 1)
                                    : Colors.grey,
                              ),
                            )),
                        obscureText: !_ConfirmPassword,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 15, left: 15, top: 40),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_fromkey.currentState!.validate()) {
                      var param = new Map<String, dynamic>();
                      param['firstname'] = firstname.text;
                      param['lastname'] = lastname.text;
                      param['username'] = username.text;
                      param['email'] = email.text;
                      param['phonenumber'] = phone_number.text;
                      param['password'] = password.text;
                      param['confirm_password'] = confirm_password.text;
                      var resdata = await apiService.postCall('users', param);
                      print(resdata);
                      if (resdata['success'] == 1) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Login(),
                            ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Email is Already Used."),
                          backgroundColor: Colors.red,
                        ));
                      }
                    }
                  },
                  child: Text("Sign Up"),
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(55, 91, 70, 1)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Text('Already have an account?'),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Login(),
                              ),
                              (route) => false);
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => Login(),
                          //     ));
                        },
                        child: Text(
                          "Login",
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
      ),
    );
  }
}
