import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_2/Ahmedabad.dart';

import 'package:demo_2/Gujrat.dart';
import 'package:demo_2/apiService.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isInterstitialAdLoaded = true;
  ApiService apiService = ApiService();
  List data = [];
  Widget _currentAd = SizedBox(
    width: 0.0,
    height: 0.0,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // FacebookAudienceNetwork.init(
    //     testingId: "119f2e2f-bc8c-496f-ab75-165ce93a2343", //optional
    //     iOSAdvertiserTrackingEnabled: false);
    getAllState();
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

  getAllState() async {
    var resData = await apiService.getCall('state');
    // log('$resData');
    setState(() {
      int dataindex = 0;
      // data = resData['data'];
      for (var item in resData['data']) {
        if (dataindex % 4 == 0 && dataindex != 0) {
          log('${dataindex}');
          data.add(item);
        }
        data.add(item);
        dataindex++;
      }
      //log('$data');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(55, 91, 70, 1),
        title: Text("Best Places"),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          Wrap(
            spacing: 10,
            alignment: WrapAlignment.center,
            children: [
              ...List.generate(data.length, (index) {
                if (index % 5 == 0 && index != 0) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    child: _nativeAd(),
                  );
                } else if (index == 0) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Gujrat(
                              state_id: data[index]['id'],
                              state_name: data[index]['statename'],
                            ),
                          ));
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                  color: Color.fromRGBO(55, 91, 70, 1),
                                ),
                              ),
                              imageUrl:
                                  'http://164.68.109.26/~levelup/travel/' +
                                      data[index]['image'],
                              height: 150,
                              width: 160,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          top: 0,
                          right: 0,
                          child: Container(
                            margin:
                                EdgeInsets.only(left: 15, right: 15, top: 10),
                            decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          top: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              "${data[index]['statename']}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 25,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Gujrat(
                            state_id: data[index]['id'],
                            state_name: data[index]['statename'],
                          ),
                        ));
                  },
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 0, right: 0, top: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                                color: Color.fromRGBO(55, 91, 70, 1),
                              ),
                            ),
                            imageUrl: 'http://164.68.109.26/~levelup/travel/' +
                                data[index]['image'],
                            height: 150,
                            width: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        top: 0,
                        right: 0,
                        child: Container(
                          margin: EdgeInsets.only(left: 0, right: 0, top: 10),
                          decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        top: 0,
                        right: 0,
                        child: Center(
                          child: Text(
                            "${data[index]['statename']}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 25,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              })
            ],
          ),
        ],
      ),
    );
  }
}
