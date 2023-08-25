import 'dart:developer';

import 'package:demo_2/Login.dart';
import 'package:demo_2/apiService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:quickalert/quickalert.dart';

class Newpass extends StatefulWidget {
  const Newpass({super.key});

  @override
  State<Newpass> createState() => _NewpassState();
}

class _NewpassState extends State<Newpass> {
  ApiService apiService = ApiService();
  bool passowrd = false;
  bool confirm_password = false;
  bool op = false;
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController pass = TextEditingController();
  TextEditingController confirmpass = TextEditingController();
  TextEditingController otp = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formkey,
          child: Container(
            margin: EdgeInsets.only(right: 20, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Image.asset(
                    "assets/key.png",
                    width: 500,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text(
                    "Create new password",
                    style: TextStyle(
                        fontSize: 24,
                        color: Color.fromRGBO(55, 91, 70, 1),
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    "Your new password must be different from previous used passwords.",
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: TextFormField(
                          controller: otp,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter Otp";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Enter Otp",
                            labelText: "Otp",
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  op = !op;
                                });
                              },
                              child: Icon(
                                op ? Icons.visibility : Icons.visibility_off,
                                color: this.op
                                    ? Color.fromRGBO(55, 91, 70, 1)
                                    : Colors.grey,
                              ),
                            ),
                          ),
                          obscureText: !op,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: TextFormField(
                          controller: pass,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter password";
                            } else if (value.length < 8) {
                              return "Password must be atleast 8 characters long";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Enter password",
                            labelText: "New Password",
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  passowrd = !passowrd;
                                });
                              },
                              child: Icon(
                                passowrd
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: this.passowrd
                                    ? Color.fromRGBO(55, 91, 70, 1)
                                    : Colors.grey,
                              ),
                            ),
                          ),
                          obscureText: !passowrd,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: TextFormField(
                          controller: confirmpass,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter confirm password";
                            } else if (value.length < 8) {
                              return "Password must be atleast 8 characters long";
                            } else if (value != pass.text) {
                              return 'Password must be same as above';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Enter confirm password",
                            labelText: "Confirm Password",
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  confirm_password = !confirm_password;
                                });
                              },
                              child: Icon(
                                confirm_password
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: this.confirm_password
                                    ? Color.fromRGBO(55, 91, 70, 1)
                                    : Colors.grey,
                              ),
                            ),
                          ),
                          obscureText: !confirm_password,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        var param = new Map<String, dynamic>();
                        param['forgot_code'] = otp.text;
                        param['password'] = pass.text;
                        param['confirm_password'] = confirmpass.text;
                        var resdata =
                            await apiService.postCall('users/verifyotp', param);
                        log('${resdata}');
                        if (resdata['success'] == 1) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Login(),
                              ));
                        } else {
                          QuickAlert.show(
                            context: context,
                            title: "Oops..",
                            type: QuickAlertType.error,
                            text: "Otp is incorrect.",
                            confirmBtnColor: Color.fromRGBO(223, 2, 56, 1),
                          );
                        }
                      }
                    },
                    child: Text("Submit"),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(55, 91, 70, 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
