import 'dart:developer';

import 'package:demo_2/Account.dart';
import 'package:demo_2/a1.dart';
import 'package:demo_2/apiService.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Change_password extends StatefulWidget {
  const Change_password({this.userid, super.key});
  final userid;
  @override
  State<Change_password> createState() => _Change_passwordState();
}

class _Change_passwordState extends State<Change_password> {
  ApiService apiService = ApiService();
  bool _Password = false;
  bool _ConfirmPassword = false;
  bool _currentpass = false;
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  TextEditingController currentpassword = TextEditingController();
  GlobalKey<FormState> _fromkey = GlobalKey<FormState>();
  late SharedPreferences pref;
  bool loader = false;
  @override
  void initState() {
    super.initState();
    // FacebookAudienceNetwork.init(
    //     testingId: "119f2e2f-bc8c-496f-ab75-165ce93a2343", //optional
    //     iOSAdvertiserTrackingEnabled: false);
    getUserid();
  }

  Widget _bannerad() {
    return FacebookBannerAd(
      placementId: "696921858449418_749866313154972",
      bannerSize: BannerSize.STANDARD,
      listener: (result, value) {
        print("Banner Ad: $result -->  $value");
      },
    );
  }

  Widget _nativeAd() {
    return FacebookNativeAd(
      placementId: "696921858449418_749867633154840",
      adType: NativeAdType.NATIVE_AD_VERTICAL,
      width: double.infinity,
      backgroundColor: Colors.blue,
      titleColor: Colors.white,
      descriptionColor: Colors.white,
      buttonColor: Colors.deepPurple,
      buttonTitleColor: Colors.white,
      buttonBorderColor: Colors.white,
      listener: (result, value) {
        print("Native Ad: $result --> $value");
      },
      keepExpandedWhileLoading: true,
      expandAnimationDuraion: 1000,
    );
  }

  getUserid() async {
    log(widget.userid);
  }

  _updatepassword() async {
    if (_fromkey.currentState!.validate()) {
      setState(() {
        loader = true;
      });

      var param = new Map<String, dynamic>();
      param['current_password'] = currentpassword.text;
      param['password'] = password.text;
      param['confirm_password'] = confirmpassword.text;
      var resdata = await apiService.patchCall(
          'users/update_pass/${widget.userid}', param);
      log('${resdata}');
      if (resdata['success'] == 1) {
        Navigator.pop(context);
      } else {
        // showDialog(
        //   context: context,
        //   builder: (ctxt) => new AlertDialog(
        //     actions: [
        //       Column(
        //         children: [
        //           Center(
        //             child: Container(
        //               child: Text(
        //                 "Incorrect Password",
        //                 textAlign: TextAlign.center,
        //                 style: TextStyle(
        //                     fontSize: 20,
        //                     color: Color.fromRGBO(55, 91, 70, 1),
        //                     fontWeight: FontWeight.bold),
        //               ),
        //             ),
        //           ),
        //           Container(
        //             margin: EdgeInsets.only(top: 8),
        //             child: Text(
        //               "Current Password is incorrect.",
        //               textAlign: TextAlign.center,
        //               style: TextStyle(
        //                 fontSize: 15,
        //                 color: Color.fromRGBO(55, 91, 70, 1),
        //               ),
        //             ),
        //           ),
        //           Container(
        //             margin: EdgeInsets.only(top: 3),
        //             child: Text(
        //               "Please try again.",
        //               style: TextStyle(
        //                 fontSize: 15,
        //                 color: Color.fromRGBO(55, 91, 70, 1),
        //               ),
        //             ),
        //           ),
        //           Container(
        //             margin: EdgeInsets.only(top: 5),
        //             child: Divider(
        //               thickness: 2,
        //             ),
        //           ),
        //           ElevatedButton(
        //             onPressed: () {
        //               Navigator.pop(context);
        //             },
        //             child: Text("OK"),
        //             style: ElevatedButton.styleFrom(
        //                 primary: Color.fromRGBO(55, 91, 70, 1)),
        //           )
        //         ],
        //       )
        //     ],
        //   ),
        // );
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Current Password is incorrect.',
          title: 'Incorrect Password',
          confirmBtnColor: Color.fromRGBO(223, 2, 56, 1),
        );
        setState(() {
          loader = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password"),
        backgroundColor: Color.fromRGBO(55, 91, 70, 1),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            child: Icon(
              Icons.close_outlined,
              size: 25,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: loader
                ? null
                : () async {
                    _updatepassword();
                  },
            child: Container(
                margin: EdgeInsets.only(right: 10), child: Icon(Icons.check)),
          )
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text:
                                "Your password must be more than six characters long and include a combination of numbers,letters and special characters (!\$@%%).",
                            style:
                                TextStyle(color: Color.fromRGBO(55, 91, 70, 1)))
                      ],
                    ),
                  ),
                ),
                Form(
                  key: _fromkey,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: TextFormField(
                          controller: currentpassword,
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
                            hintStyle:
                                TextStyle(color: Color.fromRGBO(55, 91, 70, 1)),
                            labelStyle:
                                TextStyle(color: Color.fromRGBO(55, 91, 70, 1)),
                            label: Text("Current password"),
                            //hintText: "Enter New password"),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() => _currentpass = !_currentpass);
                              },
                              child: Icon(
                                _currentpass
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: this._currentpass
                                    ? Color.fromRGBO(55, 91, 70, 1)
                                    : Colors.grey,
                              ),
                            ),
                          ),
                          obscureText: !_currentpass,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
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
                            hintStyle:
                                TextStyle(color: Color.fromRGBO(55, 91, 70, 1)),
                            labelStyle:
                                TextStyle(color: Color.fromRGBO(55, 91, 70, 1)),
                            label: Text("New password"),
                            //hintText: "Enter New password"),
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
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: TextFormField(
                          controller: confirmpassword,
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
                              hintStyle: TextStyle(
                                  color: Color.fromRGBO(55, 91, 70, 1)),
                              labelStyle: TextStyle(
                                  color: Color.fromRGBO(55, 91, 70, 1)),
                              label: Text("Re-enter new password"),
                              // hintText: "Re-enter new password"),
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
              ],
            ),
          ),
          if (loader)
            Positioned(
                top: 0,
                right: 0,
                left: 0,
                bottom: 0,
                child: Container(
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(0.5)),
                  child: Center(
                      child: CircularProgressIndicator(
                    color: Color.fromRGBO(55, 91, 70, 1),
                  )),
                ))
        ],
      ),
      bottomSheet: Container(
        width: MediaQuery.of(context).size.width,
        child: _bannerad(),
      ),
    );
  }
}
