import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_2/Account.dart';

import 'package:demo_2/Comments_Gandhi_Ashram.dart';
import 'package:demo_2/DisplayUSerAccount.dart';

import 'package:demo_2/Gujrat.dart';

import 'package:demo_2/apiService.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';

import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Ahmedabad extends StatefulWidget {
  Ahmedabad(
      {Key? key,
      this.city_id,
      this.city_name,
      required this.flag,
      this.account_id,
      this.username,
      this.id})
      : super(key: key);
  final city_id;
  final city_name;
  var flag;
  final account_id;
  final username;
  final id;
  @override
  State<Ahmedabad> createState() => _AhmedabadState();
}

class _AhmedabadState extends State<Ahmedabad> {
  ApiService apiService = ApiService();
  List data = [];
  int likeCount = 0;
  int index = 0;
  bool _isInterstitialAdLoaded = true;
  var userid;
  bool isLodar = true;
  late SharedPreferences pref;
  final _pageController = PageController();
  var _selectedIndex = 0;
  late ScrollController _scrollController;
  int offset = 0;
  bool moreData = true;

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController()..addListener(_loadMore);
    // FacebookAudienceNetwork.init(
    //     testingId: "119f2e2f-bc8c-496f-ab75-165ce93a2343", //optional
    //     iOSAdvertiserTrackingEnabled: false);
    _loadInterstitialAd();
    _showInterstitialAd();
    if (widget.flag == 1)
      getPostIncity();
    else if (widget.flag == 2)
      getAllPosts();
    else
      getPlaceidPosts();
  }

  _showInterstitialAd() {
    if (_isInterstitialAdLoaded == true)
      FacebookInterstitialAd.showInterstitialAd();
    else
      print("Interstial Ad not yet loaded!");
  }

  void _loadInterstitialAd() {
    FacebookInterstitialAd.loadInterstitialAd(
      // placementId: "YOUR_PLACEMENT_ID",
      placementId: "696921858449418_749867173154886",
      listener: (result, value) {
        print(">> FAN > Interstitial Ad: $result --> $value");
        if (result == InterstitialAdResult.LOADED)
          _isInterstitialAdLoaded = true;

        /// Once an Interstitial Ad has been dismissed and becomes invalidated,
        /// load a fresh Ad by calling this function.
        if (result == InterstitialAdResult.DISMISSED &&
            value["invalidated"] == true) {
          _isInterstitialAdLoaded = false;
          _loadInterstitialAd();
        }
      },
    );
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

  //This IS City Post
  getPostIncity() async {
    pref = await SharedPreferences.getInstance();
    userid = pref.getString('id');
    log('${userid}');
    log('This IS state');
    var resdata = await apiService.getCall(
      'place/city/${widget.city_id}?offset=0&length=5&loginuserid=${userid}',
    );
    if (mounted)
      setState(() {
        int dataindex = 0;
        // data = resdata['data'];
        data = [];
        for (var item in resdata['data']) {
          if (dataindex % 4 == 0 && dataindex != 0) {
            log('${dataindex}');
            data.add(item);
          }
          data.add(item);
          dataindex++;
        }
        isLodar = false;
      });
  } //This is a get all Account post(user)

  _loadMore() async {
    if (_scrollController.position.extentAfter < 300 && moreData == true) {
      moreData = false;
      log('Load  More${userid}');
      log('This IS state');
      offset = offset + 5;
      var resdata = await apiService.getCall(
        'place/city/${widget.city_id}?offset=${offset}&length=5&loginuserid=${userid}',
      );
      if (mounted)
        setState(() {
          int dataindex = 0;
          // data = resdata['data'];
          data.addAll(resdata['data']);

          // for (var item in resdata['data']) {
          //   if (dataindex % 4 == 0 && dataindex != 0) {
          //     log('${dataindex}');
          //     data.add(item);
          //   }
          //   data.add(item);
          //   dataindex++;
          // }

          if (resdata['data'].length > 0) moreData = true;
        });
    }
  }

  getAllPosts() async {
    pref = await SharedPreferences.getInstance();
    userid = pref.getString('id');
    log('true');
    var resdata = await apiService.getCall(
      'place/getAccountpostinAhemedabad/${widget.account_id}?loginuserid=${widget.account_id}',
    );

    log('${widget.id}');
    log('This is a get all Account post(user)');
    if (mounted)
      setState(() {
        int dataindex = 0;
        data = resdata['data'];
        // for (var item in resdata['data']) {
        //   if (dataindex % 4 == 0 && dataindex != 0) {
        //     log('${dataindex}');
        //     data.add(item);
        //   }
        //   data.add(item);
        //   dataindex++;
        // }
        isLodar = false;
      });
  }

  //This is a get select Account post(user)
  getPlaceidPosts() async {
    pref = await SharedPreferences.getInstance();
    userid = pref.getString('id');
    var resdata = await apiService.getCall(
      'place/getAccountpost/${widget.account_id}?loginuserid=${widget.account_id}&placeid=${widget.id}',
    );
    log('${widget.id}');
    log('This is a get select Account post(user)');
    if (mounted)
      setState(() {
        int dataindex = 0;
        data = resdata['data'];
        // for (var item in resdata['data']) {
        //   if (dataindex % 4 == 0 && dataindex != 0) {
        //     log('${dataindex}');
        //     data.add(item);
        //   }
        //   data.add(item);
        //   dataindex++;
        // }
        isLodar = false;
      });
  }

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
    moreData = true;
    offset = 0;
    if (widget.flag == 1) {
      getPostIncity();
    } else {
      getAllPosts();
    }
    return Future.delayed(Duration(seconds: 0));
  }

  bool _isFavourite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: widget.flag == 1 || widget.flag == 2
            ? Text("${widget.city_name}")
            : Text("${widget.username}"),
        backgroundColor: Color.fromRGBO(55, 91, 70, 1),
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
              child: ListView(
                controller: _scrollController,
                children: [
                  ...List.generate(data.length, (index1) {
                    if (index1 % 5 == 0 && index1 != 0) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          child: _nativeAd());
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
                                  child: Center(
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
                                            data[index1]['selectedIndex'] =
                                                index;
                                          });
                                        },
                                        itemCount:
                                            data[index1]['images'] == null
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
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        },
                                      ),
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
                                "View all comments",
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
                  )
                ],
              ),
            ),
    );
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
