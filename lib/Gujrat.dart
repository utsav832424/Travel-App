import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_2/Ahmedabad.dart';

import 'package:demo_2/apiService.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Gujrat extends StatefulWidget {
  Gujrat({Key? key, required this.state_id, required this.state_name})
      : super(key: key);
  final state_id;
  final state_name;

  @override
  State<Gujrat> createState() => _GujratState();
}

class _GujratState extends State<Gujrat> {
  ApiService apiService = ApiService();
  List data = [];
  bool _isInterstitialAdLoaded = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // FacebookAudienceNetwork.init(
    //     testingId: "119f2e2f-bc8c-496f-ab75-165ce93a2343", //optional
    //     iOSAdvertiserTrackingEnabled: false);
    _loadInterstitialAd();
    _showInterstitialAd();
    getAllCity();
  }

  getAllCity() async {
    var resData = await apiService.getCall('state/city/${widget.state_id}');
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
      // log('$data');
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("${widget.state_name}"),
        backgroundColor: Color.fromRGBO(55, 91, 70, 1),
      ),
      body: ListView(
        children: [
          Wrap(
            spacing: 10,
            alignment: WrapAlignment.center,
            verticalDirection: VerticalDirection.down,
            direction: Axis.horizontal,
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
                            builder: (context) => Ahmedabad(
                                city_id: data[index]['id'],
                                city_name: data[index]['name'],
                                flag: 1),
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
                              )),
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
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          top: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              "${data[index]['name']}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 25),
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
                          builder: (context) => Ahmedabad(
                              city_id: data[index]['id'],
                              city_name: data[index]['name'],
                              flag: 1),
                        ));
                  },
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 0, top: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                              color: Color.fromRGBO(55, 91, 70, 1),
                            )),
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
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        top: 0,
                        right: 0,
                        child: Center(
                          child: Text(
                            "${data[index]['name']}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 25),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
