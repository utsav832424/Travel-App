import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_2/Ahmedabad.dart';
import 'package:demo_2/apiService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisplayUSerAccount extends StatefulWidget {
  const DisplayUSerAccount(
      {this.userid, this.username, this.profile_img, this.email, super.key});
  final userid;
  final username;
  final profile_img;
  final email;
  @override
  State<DisplayUSerAccount> createState() => _DisplayUSerAccountState();
}

class _DisplayUSerAccountState extends State<DisplayUSerAccount> {
  ApiService apiService = ApiService();
  List data = [];
  ScrollController controller = ScrollController();

  bool isLoader = true;
  bool loader = true;

  // var email;
  void initState() {
    super.initState();
    getposts();
  }

  getposts() async {
    log('${widget.profile_img}');
    log('${widget.userid}');
    log('${widget.username}');
    log('${widget.email}');
    var resdata =
        await apiService.getCall('place/accountpost/${widget.userid}');
    setState(() {
      data = resdata['data'];
      log('${data}');
      isLoader = false;
      loader = false;
    });
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
                      left: 10,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
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
                                        child: widget.profile_img != null
                                            ? ClipOval(
                                                child: CachedNetworkImage(
                                                    imageUrl:
                                                        'http://164.68.109.26/~levelup/travel/' +
                                                            widget.profile_img,
                                                    width: 120,
                                                    height: 120,
                                                    fit: BoxFit.cover),
                                              )
                                            : Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                100)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          offset: Offset(2, 2),
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
                                      margin:
                                          EdgeInsets.only(left: 10, top: 10),
                                      child: Row(
                                        children: [
                                          Text(
                                            '${widget.username}',
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
                                              text: TextSpan(children: [
                                            TextSpan(
                                                text: "${widget.email}",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 15))
                                          ])),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Positioned(
                    child: DraggableScrollableSheet(
                      initialChildSize: 0.50,
                      minChildSize: 0.50,
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
                                        margin:
                                            EdgeInsets.only(left: 15, top: 10),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Ahmedabad(
                                                          flag: 0,
                                                          account_id:
                                                              widget.userid,
                                                          username:
                                                              item['username'],
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
                ],
              );
            }),
    );
  }
}
