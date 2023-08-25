import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_2/apiService.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:flutter/src/rendering/box.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Comments_Gandhi_Ashram extends StatefulWidget {
  Comments_Gandhi_Ashram({Key? key, required this.placeid}) : super(key: key);
  final placeid;
  @override
  State<Comments_Gandhi_Ashram> createState() => _Comments_Gandhi_AshramState();
}

class _Comments_Gandhi_AshramState extends State<Comments_Gandhi_Ashram> {
  ApiService apiService = ApiService();
  List data = [];
  var userid;
  var profile_img;
  late SharedPreferences pref;
  bool loader = true;
  TextEditingController addcomment = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcomments();
  }

  getcomments() async {
    log('${widget.placeid}');
    pref = await SharedPreferences.getInstance();
    userid = pref.getString('id');
    profile_img = pref.getString('profile_img');
    log('${profile_img}');
    log('${userid}');
    log('${widget.placeid}');
    var resdata = await apiService.getCall('comment?placeid=${widget.placeid}');

    setState(() {
      data = resdata['data'];
      loader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(55, 91, 70, 1),
        centerTitle: true,
        title: Text("Comments"),
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: 50),
        children: [
          for (var item in data)
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                          child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Color.fromRGBO(55, 91, 70, 1),
                              child: item['profile_img'] != null
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        'http://164.68.109.26/~levelup/travel/' +
                                            item['profile_img'],
                                      ),
                                    )
                                  : Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ))),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${item['username']}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    TextSpan(
                                        text: ' ${item['comment']}',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
        ],
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
            border: Border(top: BorderSide(width: 0.2, color: Colors.grey))),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 8),
              child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Color.fromRGBO(55, 91, 70, 1),
                  child: profile_img != '' && !loader
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(
                              'http://164.68.109.26/~levelup/travel/' +
                                  profile_img),
                        )
                      : Icon(
                          Icons.person,
                          color: Colors.white,
                        )),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: TextFormField(
                  controller: addcomment,
                  minLines: 1,
                  maxLines: 50,
                  decoration: InputDecoration(
                      hintText: "Add Comment...", border: InputBorder.none),
                ),
              ),
            ),
            TextButton(
                onPressed: () async {
                  var param = new Map<String, dynamic>();
                  param['userid'] = userid;
                  param['placeid'] = '${widget.placeid}';
                  param['comment'] = addcomment.text;
                  var resdata = await apiService.postCall('comment', param);
                  if (resdata['success'] == 1) {
                    addcomment.text = '';
                    getcomments();
                  }
                },
                child: Text(
                  "Post",
                  style: TextStyle(color: Color.fromRGBO(55, 91, 70, 1)),
                ))
          ],
        ),
      ),
    );
  }
}
