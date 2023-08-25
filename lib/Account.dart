import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_2/Add_post.dart';
import 'package:demo_2/Ahmedabad.dart';
import 'package:demo_2/Change_password.dart';
import 'package:demo_2/Login.dart';
import 'package:demo_2/apiService.dart';
import 'package:dio/dio.dart';
// import 'package:dio/dio.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' as GET;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  File? image;
  final ImagePicker picker = ImagePicker();
  late SharedPreferences pref;

  Future<void> imagePickerOption() async {
    GET.Get.bottomSheet(
      SingleChildScrollView(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          child: Container(
            color: Colors.white,
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Pic Image From",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      XFile? pickedcamera =
                          await picker.pickImage(source: ImageSource.camera);
                      pickedcamera != null
                          ? setState(() {
                              image = File(pickedcamera.path);
                              uploadimage();
                            })
                          : '';
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("CAMERA"),
                    style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(55, 91, 70, 1)),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      XFile? pickedgallery =
                          await picker.pickImage(source: ImageSource.gallery);
                      pickedgallery != null
                          ? setState(() {
                              image = File(pickedgallery.path);
                              uploadimage();
                            })
                          : '';
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.image),
                    label: const Text("GALLERY"),
                    style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(55, 91, 70, 1)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      GET.Get.back();
                    },
                    icon: const Icon(Icons.close),
                    label: const Text("CANCEL"),
                    style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(55, 91, 70, 1)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  uploadimage() async {
    if (image != null) {
      var param = new Map<String, dynamic>();
      param['profile_img'] = await MultipartFile.fromFile(image!.path);
      var response =
          await apiService.patchCall('users/profile_pic/${userid}', param);
      // log('${response}');
      debugPrint(response.toString());
      if (response['success'] == 1) {
        await pref.setString('profile_img', response['data'][0]['profile_img']);
        // log('${response['data'][0]['profile_img']}');
        setState(() {
          profile_img = response['data'][0]['profile_img'];
        });
      }
    }
  }

  ApiService apiService = ApiService();
  List data = [];
  ScrollController controller = ScrollController();

  bool isLoader = true;
  bool loader = true;

  var userid;
  var username;
  var profile_img;
  var email;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getposts();
  }

  getposts() async {
    pref = await SharedPreferences.getInstance();
    userid = pref.getString('id');
    username = pref.getString('username');

    profile_img = pref.getString('profile_img');
    log('${profile_img}');
    email = pref.getString('email');
    log('${userid}');
    log('${username}');
    var resdata = await apiService.getCall('place/accountpost/${userid}');
    setState(() {
      data = resdata['data'];
      log('${data}');
      isLoader = false;
      loader = false;
    });
  }

  Future<void> _refresh() {
    getposts();

    return Future.delayed(Duration(seconds: 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoader
          ? Center(
              child: CircularProgressIndicator(
                color: Color.fromRGBO(55, 91, 70, 1),
              ),
            )
          : LayoutBuilder(builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    height: constraints.maxHeight * 0.291,
                    width: constraints.maxHeight * 0.6,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            "assets/profile6.png",
                          ),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                      top: 25,
                      right: 10,
                      child: GestureDetector(
                        onTap: () {
                          // showDialog(
                          //   context: context,
                          //   builder: (ctxt) => new AlertDialog(
                          //     actions: [
                          //       Column(
                          //         children: [
                          //           Container(
                          //             margin: EdgeInsets.only(
                          //                 top: 15, left: 10, right: 10),
                          //             child: Text(
                          //               "Are you sure you want to log out of this app?",
                          //               textAlign: TextAlign.center,
                          //               style: TextStyle(
                          //                 fontSize: 20,
                          //                 fontWeight: FontWeight.w500,
                          //                 color: Color.fromRGBO(
                          //                   55,
                          //                   91,
                          //                   70,
                          //                   1,
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //       Container(
                          //         margin: EdgeInsets.only(top: 10),
                          //         child: Row(
                          //           mainAxisAlignment:
                          //               MainAxisAlignment.spaceEvenly,
                          //           children: [
                          //             ElevatedButton(
                          //               onPressed: () {
                          //                 pref.clear();
                          //                 Navigator.pushAndRemoveUntil(
                          //                     context,
                          //                     MaterialPageRoute(
                          //                       builder: (context) => Login(),
                          //                     ),
                          //                     (route) => false);
                          //               },
                          //               child: Text("Yes"),
                          //               style: ElevatedButton.styleFrom(
                          //                   primary: Color.fromRGBO(
                          //                     55,
                          //                     91,
                          //                     70,
                          //                     1,
                          //                   ),
                          //                   shape: RoundedRectangleBorder(
                          //                       borderRadius:
                          //                           BorderRadius.circular(20))),
                          //             ),
                          //             ElevatedButton(
                          //               onPressed: () {
                          //                 Navigator.pop(context);
                          //               },
                          //               child: Text("No"),
                          //               style: ElevatedButton.styleFrom(
                          //                   primary: Color.fromRGBO(
                          //                     55,
                          //                     91,
                          //                     70,
                          //                     1,
                          //                   ),
                          //                   shape: RoundedRectangleBorder(
                          //                       borderRadius:
                          //                           BorderRadius.circular(20))),
                          //             )
                          //           ],
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // );
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.confirm,
                            text: 'Do you want to logout',
                            confirmBtnText: 'Yes',
                            cancelBtnText: 'No',
                            confirmBtnColor: Color.fromRGBO(50, 205, 187, 1),
                            // Color.fromARGB(255, 65, 197, 164),
                            onConfirmBtnTap: () {
                              pref.clear();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Login(),
                                  ),
                                  (route) => false);
                            },
                            onCancelBtnTap: () {
                              Navigator.pop(context);
                            },
                          );
                        },
                        child: Icon(
                          Icons.logout,
                          color: Colors.white,
                          size: 30,
                        ),
                      )),
                  Positioned(
                    top: 0,
                    // height: 500,
                    left: 0,
                    right: 0,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Column(
                          children: [
                            Container(
                              // height: constraints.maxHeight * 0.7,
                              // // width: constraints.maxHeight * 0.4,
                              // decoration: BoxDecoration(
                              //   image: DecorationImage(
                              //       image: AssetImage(
                              //         "assets/profile2.jpg",
                              //       ),
                              //       fit: BoxFit.contain),
                              // ),
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: 100, right: 5),
                                      child: Container(
                                        child: profile_img != ''
                                            ? GestureDetector(
                                                onTap: () =>
                                                    imagePickerOption(),
                                                child: ClipOval(
                                                  child: CachedNetworkImage(
                                                      imageUrl:
                                                          'http://164.68.109.26/~levelup/travel/' +
                                                              profile_img,
                                                      width: 120,
                                                      height: 120,
                                                      fit: BoxFit.cover),
                                                ),
                                              )
                                            : GestureDetector(
                                                onTap: () =>
                                                    imagePickerOption(),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  100)),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            offset:
                                                                Offset(2, 2),
                                                            blurRadius: 5,
                                                            color: Colors.grey)
                                                      ]),
                                                  padding: EdgeInsets.all(40),
                                                  child: Icon(
                                                    Icons.person,
                                                    size: 40,
                                                    color: Color.fromRGBO(
                                                        55, 91, 70, 1),
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ),

                                    // Container(
                                    //   margin: EdgeInsets.only(top: 10),
                                    //   child: GestureDetector(
                                    //     onTap: () => imagePickerOption(),
                                    //     child: Icon(
                                    //       Icons.camera_alt,
                                    //       size: 30,
                                    //       color: Color.fromRGBO(55, 91, 70, 1),
                                    //     ),
                                    //   ),
                                    // ),

                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: Text(
                                        ' Posts',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Add_post(),
                                                  ));
                                            },
                                            child: Text("Add Post"),
                                            style: ElevatedButton.styleFrom(
                                                primary: Color.fromRGBO(
                                                  55,
                                                  91,
                                                  70,
                                                  1,
                                                ),
                                                padding: EdgeInsets.only(
                                                    left: 45, right: 45),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100))),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Change_password(
                                                      userid: userid,
                                                    ),
                                                  ));
                                            },
                                            child: Text("Change Password"),
                                            style: ElevatedButton.styleFrom(
                                              primary:
                                                  Color.fromRGBO(55, 91, 70, 1),
                                              padding: EdgeInsets.only(
                                                  left: 20, right: 20),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 10, top: 10),
                                      child: Row(
                                        children: [
                                          Text(
                                            '${username}',
                                            style: TextStyle(
                                                fontSize: 22,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 10, top: 3),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                    text: "${email}",
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 15))
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Container(
                                    //   margin: EdgeInsets.only(left: 12, top: 10),
                                    //   child: Row(
                                    //     children: [
                                    //       Text(
                                    //         "Bio:",
                                    //         style: TextStyle(
                                    //             fontSize: 15,
                                    //             color: Color.fromRGBO(55, 91, 70, 1),
                                    //             fontWeight: FontWeight.w500),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    // Container(
                                    //   height: 1000,
                                    //   child: ListView(
                                    //     padding: EdgeInsets.zero,
                                    //     children: [
                                    //       Container(
                                    //         decoration: BoxDecoration(
                                    //             borderRadius:
                                    //                 BorderRadius.circular(5),
                                    //             border:
                                    //                 Border.all(color: Colors.grey)),
                                    //         margin: EdgeInsets.only(
                                    //             left: 10, right: 10, top: 5),
                                    //         padding: EdgeInsets.all(10),
                                    //         child: Text(
                                    //           'Flutter & Wordpress Devloper.Currently I am Student and Working as Freelancer based In Banglore,India.Flutter & Wordpress Devloper.Currently I am Student and Working as Freelancer based In Banglore,India.Currently I am Student and Working as Freelancer based In Banglore,India.Flutter & Wordpress Dev.',
                                    //           textAlign: TextAlign.justify,
                                    //           // trimCollapsedText: 'Read More',
                                    //           // trimExpandedText: 'Read Less',
                                    //           // style: TextStyle(
                                    //           //     fontSize: 15, color: Colors.grey),
                                    //           // moreStyle: TextStyle(
                                    //           //   color: Color.fromRGBO(55, 91, 70, 1),
                                    //           // ),
                                    //           // lessStyle: TextStyle(
                                    //           //   color: Color.fromRGBO(55, 91, 70, 1),
                                    //           // ),
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  RefreshIndicator(
                    triggerMode: RefreshIndicatorTriggerMode.onEdge,
                    backgroundColor: Color.fromRGBO(55, 91, 70, 1),
                    color: Colors.white,
                    onRefresh: _refresh,
                    child: Positioned(
                      child: DraggableScrollableSheet(
                        initialChildSize: 0.40,
                        minChildSize: 0.40,
                        maxChildSize: 1,
                        builder: (BuildContext context,
                            ScrollController scrollController) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(55, 91, 70, 1),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            child: ListView(
                              padding: EdgeInsets.zero,
                              controller: scrollController,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Icon(
                                          Icons.keyboard_arrow_up_sharp,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          "Posts",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: Colors.white,
                                ),
                                Container(
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    spacing: 10,
                                    children: [
                                      for (var item in data)
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 15, top: 10),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Ahmedabad(
                                                            flag: 0,
                                                            account_id: userid,
                                                            username: item[
                                                                'username'],
                                                            id: item['id']),
                                                  ));
                                            },
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: CachedNetworkImage(
                                                  placeholder: (context, url) =>
                                                      Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                                  color: Colors
                                                                      .white)),
                                                  imageUrl:
                                                      'http://164.68.109.26/~levelup/travel/' +
                                                          item['image'],
                                                  width: 150,
                                                  height: 150,
                                                  fit: BoxFit.cover,
                                                )),
                                          ),
                                        ),
                                      // Container(
                                      //   margin: EdgeInsets.only(left: 15, top: 10),
                                      //   child: ClipRRect(
                                      //     borderRadius: BorderRadius.circular(5),
                                      //     child: Image.asset(
                                      //       'assets/Udaipur.jpg',
                                      //       height: 150,
                                      //       width: 150,
                                      //       fit: BoxFit.cover,
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }),
    );
  }

  basename(String imagepath) {}
}
