import 'dart:async';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:muntazim/core/plugins.dart';
import 'package:muntazim/utils/CustomColors.dart';
import 'package:muntazim/utils/Helper.dart';
import 'package:muntazim/utils/animatedDialogBox.dart';
import 'package:muntazim/utils/openDocument.dart';

class AnnouncementsScreen extends StatefulWidget {
  @override
  _AnnouncementsScreenState createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  final GlobalKey<ExpansionTileCardState> stCard = new GlobalKey();

  var schoolId;
  String schoolIdName;
  StreamController<bool> dataController = StreamController<bool>.broadcast();
  PermissionService _permissionService = PermissionService();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DrawerService _drawerService;
  bool isDrawerOpen = false;
  StreamController _drawerController = StreamController<bool>.broadcast();

  @override
  void initState() {
    var parent = Provider.of<AccountProvider>(context, listen: false);
    super.initState();

    _permissionService.requestStoragePermission();
    dataController.sink.add(false);
    initPlatformState();

    schoolId = parent.parents.schools.values.elementAt(0);
   // print("*******${schoolId}");
    schoolIdName = getSchoolId(value1: schoolId, parent: parent);
   // print("*******${schoolIdName}");
    parent.getSchoolYearForAnnouncement(
        selectedSchoolId: schoolIdName, primary: true, context: context);
    Future.delayed(Duration(seconds: 2), () {
      dataController.sink.add(true);

   //   print('**ANNOUNCEMENT --> ${parent.announcementList.length}');
    });
    _drawerController.add(false);
    _drawerService = Provider.of(context, listen: false);
    _listenDrawerService();
    Future.delayed(Duration(milliseconds: 200),(){
      _drawerController.sink.add(true);
    });

  }
  _listenDrawerService() {
    _drawerService.status.listen((status) {
      isDrawerOpen = status;
      _drawerController.sink.add(true);
    });
  }
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    var parent = Provider.of<AccountProvider>(context);

    return Stack(
      children: [
        Scaffold(
          key: _scaffoldKey,
          drawer: DrawerView(),
          appBar: myAppBar(_height),
          backgroundColor: CustomColors.lightBackgroundColor,
          body: Padding(
            padding: EdgeInsets.fromLTRB(25, _height * 0.01, 25, 0),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                //  height: _height,
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      // margin: EdgeInsets.only(left: 15, bottom: 2, right: 15),
                      padding: EdgeInsets.only(
                        left: 15,
                        right: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton<String>(
                                  value: schoolId,
                                  iconSize: 30,
                                  icon: (null),
                                  style: TextStyle(
                                    color: CustomColors.darkGreenColor,
                                    fontSize: 16,
                                  ),
                                  hint: Text('Select School'),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      schoolId = newValue;
                                      schoolIdName = getSchoolId(
                                          parent: parent, value1: schoolId);
                                    });
                                    dataController.sink.add(false);
                                    print(
                                        "****Selected School Id --> ${schoolIdName}");
                                    parent.getSchoolYearForAnnouncement(
                                        selectedSchoolId: schoolIdName,
                                        context: context);

                                    Future.delayed(Duration(seconds: 2), () {
                                      dataController.sink.add(true);

                                      print(
                                          '**ANNOUNCEMENT --> ${parent.announcementList.length}');
                                    });
                                  },
                                  items: parent.parents.schools.values
                                          ?.map((item) {
                                        return new DropdownMenuItem(
                                          child: new Text(item),
                                          value: item.toString(),
                                        );
                                      })?.toList() ??
                                      [],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: _height * 0.025,
                    ),
                    StreamBuilder<bool>(
                        stream: dataController.stream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Helper.CIndicator();
                          } else {
                            if (!snapshot.data)
                              return Helper.CIndicator();
                            else {
                              return ListView.builder(
                                  reverse: true,
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return AnnouncementBox(
                                        width: _width,
                                        height: _height,
                                        index: index,
                                        data: parent.announcementList[index]);
                                  },
                                  // separatorBuilder: (context, index) {
                                  //  return Divider(
                                  //    color: Colors.black45,
                                  //  );
                                  //   // return Padding(
                                  //   //   padding: EdgeInsets.only(
                                  //   //       bottom: _height * 0.01),
                                  //   //   child: Divider(
                                  //   //     color: Colors.black45,
                                  //   //   ),
                                  //   // );
                                  // },
                                  itemCount: parent.announcementList.length);
                            }
                          }
                        }),
                    SizedBox(
                      height: 50.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        StreamBuilder(
            stream: _drawerController.stream,
            builder: (context,drawerShot){
              if(!drawerShot.hasData)
                return Center();
              else
              {
                return Helper.myHeader(
                    text: 'Notifications',
                    height: _height,
                    isDrawerOpen: this.isDrawerOpen,
                    onTap: () {
                      _scaffoldKey.currentState.openDrawer();

                    });
              }
            })
        // Helper.myHeader(text: 'Notifications', height: _height,onTap: (){
        //   _scaffoldKey.currentState.openDrawer();
        // }),
      ],
    );
  }

  Widget AnnouncementBox({Map data, double width, double height, int index}) {
    print("***(${data['sent_date']})");
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.only(top: height * 0.01),
      width: width,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Helper.text(
            value: '${data['email_subject'] ?? "Title"}', fSize: height * 0.03),
        Row(children: [
          Column(children: [
            Helper.text(
                value: 'From : ${data['sender_name'] ?? "Sender"}',
                fSize: height * 0.02),
            Helper.text(value: '', fSize: height * 0.02)
          ]),
          Spacer(),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Helper.text(
                value: data['sent_date'] == null
                    ? "00-00-0000"
                    : '${Helper.dateFormat(DateTime.tryParse(data['sent_date'])) ?? "00-00-0000"}',
                fSize: height * 0.02),
            Helper.text(
                value: data['sent_date'] == null
                    ? "00-00"
                    : '${Helper.timeFormat(DateTime.tryParse(data['sent_date'])) ?? "00-00"}',
                fSize: height * 0.02)
          ])
        ]),
        Helper.text(
            value:
                '${data['email_message'] ?? "All students and staff invited. This is test announcement to be sent to all parents from Muntazim App"}',
            fSize: height * 0.019,
            fColor: Colors.black54,
            fWeight: FontWeight.w400),
        Row(children: [
          Spacer(),
          InkWell(
            onTap: () async {
              await animated_dialog_box.showScaleAlertBox(
                  title: Column(children: [
                    Helper.text(
                        value: '${data['email_subject'] ?? "Title"}',
                        fSize: height * 0.03),
                    Divider(
                      color: Colors.black45,
                    )
                  ]),
                  // IF YOU WANT TO ADD
                  context: context,
                  firstButton: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Helper.text(
                            value: data['sent_date'] == null
                                ? "00-00-0000"
                                : '${Helper.dateFormat(DateTime.tryParse(data['sent_date'])) ?? "00-00-0000"}',
                            fSize: height * 0.02),
                        Helper.text(
                            value: data['sent_date'] == null
                                ? "00-00"
                                : '${Helper.timeFormat(DateTime.tryParse(data['sent_date'])) ?? "00-00"}',
                            fSize: height * 0.02)
                      ]),
                  secondButton: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Column(children: [
                      Helper.text(value: '', fSize: height * 0.02),
                      Helper.text(value: 'Dismiss', fSize: height * 0.02),
                    ]),
                  ),
                  // IF YOU WANT TO ADD ICON
                  yourWidget: Container(
                    // height: height * 0.2,
                    margin: EdgeInsets.only(bottom: height * 0.05,left: height*0.017,right: height*0.017),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              '${data['email_message'] ?? "All students and staff invited. This is test announcement to be sent to all parents from Muntazim App"}',
                              style: TextStyle(
                                  fontSize: height * 0.019,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400)),
                          SizedBox(
                            height: height * 0.05,
                          ),
                          Helper.text(value: "Attachments"),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Wrap(
                              runSpacing: 5.0,
                              children: List.generate(data['attachment'].length,
                                  (index) {
                                List temp =
                                    data['attachment'][index].split('%');
                                return InkWell(
                                    onTap: () {
                                      openDocument(data['attachment'][index]);
                                    },
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: height * 0.021,
                                          backgroundColor:
                                              CustomColors.darkGreenColor,
                                          child: CircleAvatar(
                                            radius: height * 0.019,
                                            backgroundColor: Colors.white,
                                            child: Icon(
                                              Icons.download_rounded,
                                              color:
                                                  CustomColors.darkGreenColor,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Container(
                                          width: height*0.2,
                                          child: temp.length < 2
                                              ? Helper.text(
                                              value: '${temp[0]}',
                                              fSize: height * 0.02)
                                              : Helper.text(
                                              value:
                                              '${data['attachment'][index].split('%')[1].split('?')[0]}',
                                              fSize: height * 0.02),
                                        )
                                      ],
                                    )
                                    // child: Helper.text(
                                    //     value: data['attachment'][index],
                                    //     fSize: height * 0.016,
                                    //     fColor: CustomColors.darkGreenColor,
                                    //     fWeight: FontWeight.bold),
                                    );
                              }))

                          // Helper.text(
                          //     value: data['attachment'][0],
                          //     fSize: height * 0.016,
                          //     fColor: Colors.black45,
                          //     fWeight: FontWeight.bold),
                        ]),
                  ));
            },
            child: Helper.text(
                value: 'More', fSize: height * 0.02, fWeight: FontWeight.bold),
          )
        ])
      ]),
    );
  }

  String getSchoolId({String value1, AccountProvider parent}) {
    String temp = "";
    parent.parents.schools.forEach((key, value) {
      if (value == value1) {
        temp = key;
      }
    });
    return temp;
  }

  Widget myAppBar(_height) {
    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      // leading: Padding(
      //     padding: EdgeInsets.only(bottom: 50.0),
      //     child: Icon(Icons.menu_rounded)),
      // title: Padding(
      //   padding: EdgeInsets.only(bottom: 50.0),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Text(
      //         'Welcome',
      //         style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15.0),
      //       ),
      //       Text('Raheel Zain')
      //     ],
      //   ),
      // ),
      toolbarHeight: _height * 0.3,
      elevation: 0.0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/appBack.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      // actions: [
      //   Padding(
      //     padding: EdgeInsets.only(right: 10.0, bottom: 50.0),
      //     child: CircleAvatar(
      //       radius: 30.0,
      //       backgroundColor: CustomColors.darkGreenColor,
      //       child: CircleAvatar(
      //         radius: 27.0,
      //         backgroundColor: Colors.white,
      //         child: Icon(
      //           Icons.person,
      //           color: CustomColors.darkGreenColor,
      //           size: 40.0,
      //         ),
      //       ),
      //     ),
      //   )
      // ],
    );
  }
}
