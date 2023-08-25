import 'dart:developer';

import 'dart:io';
import 'dart:math' as math;

import 'package:demo_2/Account.dart';
import 'package:demo_2/a1.dart';
import 'package:demo_2/apiService.dart';
import 'package:dio/dio.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Add_post extends StatefulWidget {
  const Add_post({super.key});

  @override
  State<Add_post> createState() => _Add_postState();
}

class _Add_postState extends State<Add_post>
    with SingleTickerProviderStateMixin {
  ApiService apiService = ApiService();
  var userid;
  var state_id;
  var city_id;
  late SharedPreferences pref;
  //Image from camera
  File? image;

  // final String valueChoose;
  bool loader = false;
  List state = [];
  String statechoose = '';

  List city = [];
  String citychoose = '';
  GlobalKey<FormState> _fromkey = GlobalKey<FormState>();
  //Multiple Image from gallery

  final ImagePicker picker = ImagePicker();
  bool _img = false;
  List<File> imageList = [];

  imageSelect() async {
    final List<XFile>? selectedImages = await picker.pickMultiImage();
    if (selectedImages != null &&
        selectedImages.length <= 10 &&
        imageList.length < 10) {
      log('${selectedImages.length}');
      for (var file in selectedImages) {
        imageList.add(File(file.path));
      }
      // imageList!.addAll(selectedImages);
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.info,
        text: 'Select only 10 Photos',
        confirmBtnColor: Color.fromRGBO(255, 200, 71, 1),
      );
    }

    _img = true;
    print("Image List Length:" + imageList.length.toString());
    setState(() {});
  }

  TextEditingController description = TextEditingController();
  TextEditingController location = TextEditingController();

  _uploadimage() async {
    if (imageList == null || imageList.isEmpty) {
      log('false');
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: 'Select Images for post',
          confirmBtnColor: Color.fromRGBO(223, 2, 56, 1));
    } else if (imageList != null) {
      setState(() {
        loader = true;
      });

      List uploadList = [];
      for (var file in imageList) {
        var multipartFile = await MultipartFile.fromFile(file.path);
        uploadList.add(multipartFile);
      }
      if (_fromkey.currentState!.validate()) {
        var param = new Map<String, dynamic>();
        param['userid'] = userid;
        param['state_id'] = statechoose;
        param['city_id'] = citychoose;
        param['image'] = uploadList;
        param['description'] = description.text;

        var response = await apiService.postCall('place', param);

        if (response['success'] == 1) {
          Navigator.pop(context);
        } else {
          // showDialog(
          //   context: context,
          //   builder: (ctxt) => new AlertDialog(
          //     actions: [
          //       Container(
          //         padding: EdgeInsets.all(0),
          //         child: Column(
          //           children: [
          //             Icon(
          //               Icons.post_add,
          //               color: Color.fromRGBO(55, 91, 70, 1),
          //               size: 30,
          //             ),
          //             Container(
          //               margin: EdgeInsets.only(top: 8),
          //               child: Text(
          //                 "Post is not Upload",
          //                 textAlign: TextAlign.center,
          //                 style: TextStyle(
          //                   fontSize: 20,
          //                   fontWeight: FontWeight.w500,
          //                   color: Color.fromRGBO(55, 91, 70, 1),
          //                 ),
          //               ),
          //             ),
          //             Container(
          //               margin: EdgeInsets.only(top: 5),
          //               child: Divider(
          //                 thickness: 2,
          //               ),
          //             ),
          //             Container(
          //               margin: EdgeInsets.only(bottom: 0),
          //               child: ElevatedButton(
          //                 onPressed: () {
          //                   Navigator.pop(context);
          //                 },
          //                 child: Text("OK"),
          //                 style: ElevatedButton.styleFrom(
          //                     primary: Color.fromRGBO(55, 91, 70, 1)),
          //               ),
          //             )
          //           ],
          //         ),
          //       )
          //     ],
          //   ),
          // );
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: 'Post is not Upload',
            title: 'Oops...',
            confirmBtnColor: Color.fromRGBO(223, 2, 56, 1),
          );
        }
        debugPrint(response.toString());
      }
      setState(() {
        loader = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // FacebookAudienceNetwork.init(
    //     testingId: "119f2e2f-bc8c-496f-ab75-165ce93a2343", //optional
    //     iOSAdvertiserTrackingEnabled: false);
    getstate();
  }

  List data = [];
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
      listener: (result, value) {
        print("Native Ad: $result --> $value");
      },
      keepExpandedWhileLoading: true,
      expandAnimationDuraion: 1000,
    );
  }

  getstate() async {
    pref = await SharedPreferences.getInstance();
    userid = pref.getString('id');
    log('${userid}');
    var resdata = await apiService.getCall('state');
    setState(() {
      state = resdata['data'];
    });
  }

  getcity() async {
    var resdata = await apiService.getCall('state/city/${statechoose}');
    setState(() {
      city = resdata['data'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Post"),
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
                    _uploadimage();
                  },
            child: Container(
                margin: EdgeInsets.only(right: 10), child: Icon(Icons.check)),
          )
        ],
      ),
      floatingActionButton: ExpandableFab(
        distance: 100,
        children: [
          FloatingActionButton(
            onPressed: () async {
              XFile? pickedcamera =
                  await picker.pickImage(source: ImageSource.camera);
              setState(() {
                if (imageList.length < 10) {
                  imageList.add(File(pickedcamera!.path));
                } else {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.info,
                    text: 'Select only 10 Photos',
                    confirmBtnColor: Color.fromRGBO(255, 200, 71, 1),
                  );
                }
              });
            },
            heroTag: "Camera",
            child: Icon(Icons.camera_alt),
            backgroundColor: Color.fromRGBO(55, 91, 70, 1),
          ),
          FloatingActionButton(
            onPressed: () async {
              // XFile? pickedgallery =
              //     await picker.pickImage(source: ImageSource.gallery);
              // setState(() {
              //   image = File(pickedgallery!.path);
              // });
              // Navigator.pop(context);
              imageSelect();
            },
            heroTag: "Image",
            child: Icon(Icons.image),
            backgroundColor: Color.fromRGBO(55, 91, 70, 1),
          )
        ],
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Form(
                key: _fromkey,
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height: 150,
                          margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                          child: imageList.length > 0
                              ? Wrap(
                                  spacing: 5,
                                  runSpacing: 5,
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  children: [
                                    for (var img in imageList)
                                      Image.file(
                                        File(img.path),
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                      )
                                    // GridView.builder(
                                    //   itemCount: imageList.length,
                                    //   gridDelegate:
                                    //       SliverGridDelegateWithFixedCrossAxisCount(
                                    //           crossAxisCount: 5,
                                    //           crossAxisSpacing: 5,
                                    //           mainAxisSpacing: 5),
                                    //   itemBuilder:
                                    //       (BuildContext context, int index) {
                                    //     return Image.file(
                                    //       File(imageList[index].path),
                                    //       height: 60,
                                    //       width: 60,
                                    //       fit: BoxFit.cover,
                                    //     );
                                    //   },
                                    // ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              border: Border.all(
                                                  color: Colors.black54),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5))),
                                        ),
                                        const Positioned(
                                            top: 35,
                                            left: 38,
                                            child: Icon(
                                              Icons.image,
                                              color:
                                                  Color.fromRGBO(55, 91, 70, 1),
                                              size: 25,
                                            )),
                                      ],
                                    ),
                                    Stack(
                                      children: [
                                        Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              border: Border.all(
                                                  color: Colors.black54),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5))),
                                        ),
                                        const Positioned(
                                            top: 35,
                                            left: 38,
                                            child: Icon(
                                              Icons.image,
                                              color:
                                                  Color.fromRGBO(55, 91, 70, 1),
                                              size: 25,
                                            )),
                                      ],
                                    ),
                                    Stack(
                                      children: [
                                        Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              border: Border.all(
                                                  color: Colors.black54),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5))),
                                        ),
                                        const Positioned(
                                            top: 35,
                                            left: 38,
                                            child: Icon(
                                              Icons.image,
                                              color:
                                                  Color.fromRGBO(55, 91, 70, 1),
                                              size: 25,
                                            )),
                                      ],
                                    ),
                                  ],
                                )),
                      // Row(
                      //   children: [
                      //     Container(
                      //         margin: EdgeInsets.only(left: 10),
                      //         child: image != null
                      //             ? Image.file(image!,
                      //                 height: 60, width: 60, fit: BoxFit.cover)
                      //             : Text("")),
                      //   ],
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                              child: DropdownButtonFormField<String>(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Select State";
                                    }
                                  },
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Color.fromRGBO(55, 91, 70, 1),
                                  ),
                                  hint: Text("Select State"),
                                  value:
                                      statechoose.isEmpty ? null : statechoose,
                                  style: TextStyle(
                                      color: Color.fromRGBO(55, 91, 70, 1),
                                      fontWeight: FontWeight.bold),
                                  onChanged: (String? newValue) async {
                                    setState(() {
                                      statechoose = newValue!;
                                      getcity();
                                      citychoose = '';
                                      print(statechoose);
                                    });
                                  },
                                  items: [
                                    for (var data in state)
                                      DropdownMenuItem<String>(
                                        value: '${data['id']}',
                                        child: Row(
                                          children: [
                                            Container(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              child: Text(
                                                "${data['statename']}",
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                  ]),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                              child: DropdownButtonFormField<String>(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Select City";
                                    }
                                  },
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Color.fromRGBO(55, 91, 70, 1),
                                  ),
                                  hint: Text("Select City"),
                                  value: citychoose.isEmpty ? null : citychoose,
                                  style: TextStyle(
                                      color: Color.fromRGBO(55, 91, 70, 1),
                                      fontWeight: FontWeight.bold),
                                  onChanged: (String? newValue) async {
                                    setState(() {
                                      citychoose = newValue!;
                                      print(citychoose);
                                    });
                                  },
                                  items: [
                                    for (var data in city)
                                      DropdownMenuItem<String>(
                                        value: '${data['id']}',
                                        child: Row(
                                          children: [
                                            Container(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              child: Text(
                                                "${data['name']}",
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                  ]),
                            ),
                          ),
                        ],
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: TextFormField(
                            controller: description,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter description";
                              }
                              return null;
                            },
                            textAlign: TextAlign.justify,
                            minLines: 1,
                            maxLines: 100,
                            cursorColor: Color.fromRGBO(55, 91, 70, 1),
                            autofocus: true,
                            decoration: InputDecoration(
                                hintText: "Write a caption",
                                focusColor: Color.fromRGBO(
                                  55,
                                  91,
                                  70,
                                  1,
                                ),
                                label: Text(
                                  "Description",
                                  style: TextStyle(
                                      color: Color.fromRGBO(55, 91, 70, 1),
                                      fontWeight: FontWeight.bold),
                                )),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (loader)
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Color.fromRGBO(55, 91, 70, 1),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomSheet: Container(
        // height: 50,
        // color: Colors.amber,
        width: MediaQuery.of(context).size.width,
        child: _bannerad(),
      ),
    );
  }

  basename(String imagepath) {}
}

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    super.key,
    this.initialOpen,
    required this.distance,
    required this.children,
  });

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    if (_controller != null) _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                color: Color.fromRGBO(55, 91, 70, 1),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.20, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                child: Container(
                    margin: EdgeInsets.only(bottom: 2),
                    child: Text(
                      "Add Post",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ),
              FloatingActionButton(
                splashColor: Colors.black,
                onPressed: _toggle,
                heroTag: "Add Post",
                tooltip: "Add Post",
                backgroundColor: Color.fromRGBO(55, 91, 70, 1),
                child: Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.onPressed,
    required this.icon,
  });

  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.secondary,
      elevation: 4.0,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        color: theme.colorScheme.onSecondary,
      ),
    );
  }
}

@immutable
class FakeItem extends StatelessWidget {
  const FakeItem({
    super.key,
    required this.isBig,
  });

  final bool isBig;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      height: isBig ? 128.0 : 36.0,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        color: Colors.grey.shade300,
      ),
    );
  }
}
