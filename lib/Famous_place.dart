import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_2/Comments_Gandhi_Ashram.dart';
import 'package:demo_2/DisplayUserAccount.dart';

import 'package:demo_2/apiService.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Famous_place extends StatefulWidget {
  Famous_place({Key? key}) : super(key: key);

  @override
  State<Famous_place> createState() => _Famous_placeState();
}

class _Famous_placeState extends State<Famous_place> {
  ApiService apiService = ApiService();
  List data = [];
  bool isLodar = true;
  var _selectedIndex = 0;
  final _pageController = PageController();
  late SharedPreferences pref;
  var userid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // FacebookAudienceNetwork.init(
    //     testingId: "119f2e2f-bc8c-496f-ab75-165ce93a2343", //optional
    //     iOSAdvertiserTrackingEnabled: false);
    getfamousplace();
  }

  getfamousplace() async {
    log('This is Famous Place');
    pref = await SharedPreferences.getInstance();
    userid = pref.getString('id');
    log('${userid}');
    var resdata =
        await apiService.getCall('place/Famous_place?loginuserid=${userid}');
    if (mounted)
      setState(() {
        int fdataindex = 0;
        // data = resdata['data'];

        for (var item in resdata['data']) {
          if (fdataindex % 4 == 0 && fdataindex != 0) {
            log('${fdataindex}');
            data.add(item);
          }
          data.add(item);
          fdataindex++;
        }
        isLodar = false;
      });
  }

  Widget _nativeAd() {
    return FacebookNativeAd(
      placementId: "696921858449418_749867633154840",
      adType: NativeAdType.NATIVE_AD_VERTICAL,
      width: double.infinity,
      listener: (result, value) {
        print("Native Ad: $result --> $value");
      },
      keepExpandedWhileLoading: true,
      expandAnimationDuraion: 1000,
    );
  }

  int view = 0;
  _showFavourite() async {
    OverlayState? overlaystate = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: MediaQuery.of(context).size.height / 3,
          right: MediaQuery.of(context).size.width / 2 - 30,
          child: Icon(
            Icons.favorite,
            size: 56,
            color: Colors.white,
          ),
        );
      },
    );
    overlaystate!.insert(overlayEntry);
    await Future.delayed(Duration(seconds: 1));
    overlayEntry.remove();
  }

  Future<void> _refresh() {
    getfamousplace();
    return Future.delayed(Duration(seconds: 0));
  }

  bool _isFavourite = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color.fromRGBO(55, 91, 70, 1),
          title: Text("Famous Place"),
          automaticallyImplyLeading: false,
        ),
        body: isLodar
            ? Center(
                child: CircularProgressIndicator(
                  color: Color.fromRGBO(55, 91, 70, 1),
                ),
              )
            : RefreshIndicator(
                triggerMode: RefreshIndicatorTriggerMode.onEdge,
                backgroundColor: Color.fromRGBO(55, 91, 70, 1),
                color: Colors.white,
                onRefresh: _refresh,
                child: ListView(children: [
                  ...List.generate(data.length, (index1) {
                    if (index1 % 5 == 0 && index1 != 0) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        child: _nativeAd(),
                      );
                    }
                    return Container(
                      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                child: data[index1]['profile_img'] == null
                                    ? CircleAvatar(
                                        radius: 20,
                                        backgroundColor:
                                            Color.fromRGBO(55, 91, 70, 1),
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        ),
                                      )
                                    : CircleAvatar(
                                        radius: 20,
                                        backgroundImage: NetworkImage(
                                            'http://164.68.109.26/~levelup/travel/' +
                                                data[index1]['profile_img']),
                                      ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DisplayUSerAccount(
                                                userid: data[index1]['userid'],
                                                username: data[index1]
                                                    ['username'],
                                                profile_img: data[index1]
                                                    ['profile_img'],
                                                email: data[index1]['email'],
                                              ),
                                            ));
                                      },
                                      child: RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                              text:
                                                  "${data[index1]['username']}",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromRGBO(
                                                      55, 91, 70, 1)))
                                        ]),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 2),
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  "${data[index1]['location']}",
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      55, 91, 70, 1),
                                                  fontSize: 12),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Stack(
                            children: [
                              Positioned(
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  height: 250,
                                  width: 380,
                                  child: GestureDetector(
                                    onDoubleTap: () async {
                                      setState(() {
                                        data[index1]['showlike'] = true;
                                      });
                                      var data1 = new Map<String, dynamic>();
                                      data1['userid'] = userid;
                                      data1['placeid'] = data[index1]['id'];
                                      var resData = await apiService.postCall(
                                          'user_place_like', data1);
                                      setState(() {
                                        data[index1]['total_like'] =
                                            resData['data'][0]['total_like'];

                                        data[index1]['user_like'] =
                                            data[index1]['user_like'] == 1
                                                ? 0
                                                : 1;

                                        data[index1]['showlike'] = false;
                                      });
                                      // _showFavourite();
                                    },
                                    child: PageView.builder(
                                      onPageChanged: (index) {
                                        setState(() {
                                          data[index1]['selectedIndex'] = index;
                                        });
                                      },
                                      itemCount: data[index1]['images'] == null
                                          ? 0
                                          : data[index1]['images'].length,
                                      controller: _pageController,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 2),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(2),
                                          ),
                                          child: CachedNetworkImage(
                                              imageUrl:
                                                  'http://164.68.109.26/~levelup/travel/' +
                                                      data[index1]['images']
                                                          [index]['image'],
                                              fit: BoxFit.cover),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              if (data[index1]['showlike'] == true)
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Icon(
                                    Icons.favorite,
                                    size: 56,
                                    color: data[index1]['user_like'] == 1
                                        ? Colors.white
                                        : Colors.pink,
                                  ),
                                )
                            ],
                          ),
                          if (data[index1]['images'] != null)
                            if (data[index1]['images'].length > 1)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ...List.generate(
                                      data[index1]['images'].length,
                                      (index) => Indicator(
                                          isActive: data[index1]
                                                          ['selectedIndex'] ==
                                                      index ||
                                                  (data[index1][
                                                              'selectedIndex'] ==
                                                          null &&
                                                      index == 0)
                                              ? true
                                              : false)).toList()
                                ],
                              ),
                          Container(
                            margin: EdgeInsets.only(top: 0),
                            child: Row(
                              children: [
                                GestureDetector(
                                    onTap: () async {
                                      var data2 = new Map<String, dynamic>();
                                      data2['userid'] = userid;
                                      data2['placeid'] = data[index1]['id'];
                                      var resData = await apiService.postCall(
                                          'user_place_like', data2);
                                      setState(() {
                                        _isFavourite = !_isFavourite;
                                        data[index1]['total_like'] =
                                            resData['data'][0]['total_like'];
                                        data[index1]['user_like'] =
                                            data[index1]['user_like'] == 1
                                                ? 0
                                                : 1;
                                      });
                                    },
                                    child: data[index1]['user_like'] == 1
                                        ? Icon(
                                            Icons.favorite,
                                            size: 28,
                                            color: Colors.pink,
                                          )
                                        : Icon(
                                            Icons.favorite_border,
                                            size: 28,
                                          )),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Comments_Gandhi_Ashram(
                                                  placeid: data[index1]['id']),
                                        ));
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Icon(
                                        Icons.chat_bubble_outline,
                                        size: 28,
                                      )),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 10, left: 5),
                                child:
                                    Text('${data[index1]['total_like']} Likes'),
                              ),
                            ],
                          ),
                          // Container(
                          //   margin: EdgeInsets.only(left: 5, top: 5),
                          //   child: RichText(
                          //       text: TextSpan(children: [
                          //     TextSpan(
                          //         text: "Liked by",
                          //         style: TextStyle(color: Colors.black)),
                          //     TextSpan(
                          //         text: " Anmol Sakhreliya",
                          //         style: TextStyle(
                          //             color: Colors.black,
                          //             fontWeight: FontWeight.bold)),
                          //     TextSpan(
                          //         text: " and ",
                          //         style: TextStyle(color: Colors.black)),
                          //     TextSpan(
                          //         text: "Others",
                          //         style: TextStyle(
                          //             color: Colors.black,
                          //             fontWeight: FontWeight.bold))
                          //   ])),
                          // ),
                          Container(
                            margin: EdgeInsets.only(left: 5, top: 5),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "${data[index1]['username']}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  TextSpan(
                                      text: " ${data[index1]['description']}",
                                      style: TextStyle(color: Colors.black))
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Comments_Gandhi_Ashram(
                                      placeid: data[index1]['id'],
                                    ),
                                  ));
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 5, top: 5),
                              child: Text(
                                "View all 688 comments",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  SizedBox(
                    height: 20,
                  ),
                  // body: ListView(
                  //   children: [
                  // Container(
                  //   margin: EdgeInsets.only(
                  //     top: 15,
                  //   ),
                  //   padding: EdgeInsets.only(top: 2, bottom: 2),
                  //   child: Row(
                  //     children: [
                  //       Container(
                  //         margin: EdgeInsets.only(left: 5),
                  //         child: Icon(Icons.language),
                  //       ),
                  //       Container(
                  //         margin: EdgeInsets.only(left: 10),
                  //         child: Text(
                  //           "Total Place (95)",
                  //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  //         ),
                  //       ),
                  //       Container(
                  //         margin: EdgeInsets.only(left: 120),
                  //         child: Icon(Icons.search),
                  //       ),
                  //       Container(
                  //         margin: EdgeInsets.only(left: 20),
                  //         child: GestureDetector(
                  //           onTap: () {
                  //             setState(() {
                  //               view = (view == 0) ? 1 : 0;
                  //             });
                  //           },
                  //           child: Icon(
                  //             Icons.view_list_rounded,
                  //             color: Colors.black,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // if (view == 0)
                  //   for (var item in [1, 1, 1, 1, 1])
                  //     Container(
                  //       margin: EdgeInsets.only(left: 5, right: 5, top: 10),
                  //       padding: EdgeInsets.only(bottom: 5),
                  //       decoration: BoxDecoration(
                  //           color: Colors.white,
                  //           boxShadow: [
                  //             BoxShadow(
                  //                 offset: Offset(3, 3),
                  //                 blurRadius: 2,
                  //                 color: Colors.grey)
                  //           ],
                  //           borderRadius: BorderRadius.circular(10)),
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Container(
                  //               child: ClipRRect(
                  //             borderRadius: BorderRadius.only(
                  //                 topLeft: Radius.circular(5),
                  //                 topRight: Radius.circular(5)),
                  //             child: Image.asset(
                  //               'assets/Taj_mahal.jpg',
                  //               height: 150,
                  //               width: 400,
                  //               fit: BoxFit.cover,
                  //             ),
                  //           )),
                  //           Container(
                  //             margin: EdgeInsets.only(top: 8, left: 10),
                  //             child: Text(
                  //               "Taj Mahal",
                  //               style: TextStyle(
                  //                   fontWeight: FontWeight.bold, fontSize: 18),
                  //             ),
                  //           ),
                  //           Row(
                  //             children: [
                  //               Container(
                  //                 margin: EdgeInsets.only(left: 5, top: 10),
                  //                 child: Icon(
                  //                   Icons.place,
                  //                   color: Colors.red,
                  //                   size: 20,
                  //                 ),
                  //               ),
                  //               Container(
                  //                 margin: EdgeInsets.only(left: 2, top: 8),
                  //                 child: Text(
                  //                   "Agra,Uttar Pradesh",
                  //                   style: TextStyle(
                  //                       fontWeight: FontWeight.bold, fontSize: 13),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //           Row(
                  //             children: [
                  //               Container(
                  //                 margin: EdgeInsets.only(left: 10, top: 8),
                  //                 child: Text(
                  //                   "5.0",
                  //                   style: TextStyle(color: Colors.grey),
                  //                 ),
                  //               ),
                  //               Container(
                  //                   margin: EdgeInsets.only(top: 8),
                  //                   child: Icon(
                  //                     Icons.star,
                  //                     color: Colors.amber,
                  //                     size: 19,
                  //                   )),
                  //               Container(
                  //                 margin: EdgeInsets.only(top: 8, left: 2),
                  //                 child: Text(
                  //                   "(200 Review)",
                  //                   style: TextStyle(color: Colors.grey),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //           Container(
                  //             margin: EdgeInsets.only(left: 10, top: 12),
                  //             child: Text(
                  //               "Mahal",
                  //               style: TextStyle(
                  //                   fontWeight: FontWeight.bold, fontSize: 16),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),

                  // if (view == 1)
                  //   Wrap(
                  //     children: [
                  //       for (var item in [1, 1, 1, 1, 1, 1])
                  //         InkWell(
                  //           onTap: () {
                  //             Navigator.push(
                  //                 context,
                  //                 MaterialPageRoute(
                  //                   builder: (context) => Taj_mahal(),
                  //                 ));
                  //           },
                  //           child: Stack(
                  //             children: [
                  //               Container(
                  //                 margin: EdgeInsets.only(left: 5, right: 5, top: 5),
                  //                 padding: EdgeInsets.only(),
                  //                 decoration: BoxDecoration(
                  //                     color: Colors.white,
                  //                     boxShadow: [
                  //                       BoxShadow(
                  //                           offset: Offset(2, 2),
                  //                           blurRadius: 2,
                  //                           color: Colors.grey)
                  //                     ],
                  //                     borderRadius: BorderRadius.circular(10)),
                  //                 child: Container(
                  //                   margin: EdgeInsets.only(
                  //                       top: 5, right: 5, left: 5, bottom: 5),
                  //                   child: ClipRRect(
                  //                     borderRadius: BorderRadius.circular(5),
                  //                     child: Image.asset(
                  //                       'assets/Taj_mahal.jpg',
                  //                       height: 240,
                  //                       width: 160,
                  //                       fit: BoxFit.cover,
                  //                       filterQuality: FilterQuality.none,
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //               Positioned(
                  //                 left: 15,
                  //                 bottom: 50,
                  //                 child: Text(
                  //                   "Taj Mahal",
                  //                   style: TextStyle(
                  //                       fontWeight: FontWeight.bold,
                  //                       fontSize: 20,
                  //                       color: Colors.white),
                  //                 ),
                  //               ),
                  //               Positioned(
                  //                 left: 15,
                  //                 bottom: 35,
                  //                 child: Text(
                  //                   "Mahal",
                  //                   style: TextStyle(
                  //                       fontWeight: FontWeight.bold,
                  //                       color: Colors.white),
                  //                 ),
                  //               ),
                  //               Positioned(
                  //                   bottom: 10,
                  //                   left: 10,
                  //                   child: Icon(
                  //                     Icons.place,
                  //                     color: Colors.white,
                  //                     size: 20,
                  //                   )),
                  //               Positioned(
                  //                   left: 30,
                  //                   bottom: 20,
                  //                   child: Text(
                  //                     "Agra,",
                  //                     style: TextStyle(
                  //                         fontWeight: FontWeight.bold,
                  //                         color: Colors.white,
                  //                         fontSize: 10),
                  //                   )),
                  //               Positioned(
                  //                 left: 30,
                  //                 bottom: 8,
                  //                 child: Text(
                  //                   "Uttar Pradesh",
                  //                   style: TextStyle(
                  //                       fontWeight: FontWeight.bold,
                  //                       color: Colors.white,
                  //                       fontSize: 10),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //     ],
                  //   ),
                  //   ],
                  // ),
                ]),
              ));
  }
}

class Indicator extends StatelessWidget {
  final bool isActive;
  const Indicator({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 3),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
          color: isActive ? Color.fromRGBO(55, 91, 70, 1) : Colors.grey,
          borderRadius: BorderRadius.circular(8)),
    );
  }
}
