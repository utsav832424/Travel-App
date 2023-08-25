import 'dart:developer';

import 'package:demo_2/Login.dart';
import 'package:demo_2/Newpass.dart';
import 'package:demo_2/apiService.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class Forgot_password extends StatefulWidget {
  Forgot_password({Key? key}) : super(key: key);

  @override
  State<Forgot_password> createState() => _Forgot_passwordState();
}

class _Forgot_passwordState extends State<Forgot_password> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  ApiService apiService = ApiService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: Image.asset(
              'assets/signup.webp',
              height: 300,
              width: 300,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 15),
            child: Text(
              "Forgot Password?",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(55, 91, 70, 1),
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 15, top: 5),
              child: Text(
                  "Please enter your e-mail address below to receive your user and  a new password.")),
          Expanded(
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15, top: 20),
                  child: Text(
                    "Email Address",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(55, 91, 70, 1),
                    ),
                  ),
                ),
                Form(
                  key: _formkey,
                  child: Container(
                    margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: TextFormField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter Email";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email_rounded,
                            color: Color.fromRGBO(55, 91, 70, 1),
                          ),
                          hintText: "Enter Email"),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15, top: 105),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        var param = new Map<String, dynamic>();
                        param['email'] = email.text;
                        var resdata =
                            await apiService.postCall('users/sendmail', param);
                        log('${resdata}');
                        if (resdata['success'] == 1) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Newpass(),
                              ),
                              (route) => false);
                        } else {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.info,
                            text: 'First of all Create Account',
                            confirmBtnColor: Color.fromRGBO(255, 200, 71, 1),
                          );
                        }
                      }
                    },
                    child: Text("Send"),
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(55, 91, 70, 1)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text("Back to ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(55, 91, 70, 1))),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text("Login",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(55, 91, 70, 1))),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
