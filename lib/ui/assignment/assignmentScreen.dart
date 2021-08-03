import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:muntazim/core/plugins.dart';
import 'package:muntazim/core/services/models/studentModel/StudentModel.dart';
import 'package:muntazim/ui/assignment/AssignmentDetail.dart';
import 'package:muntazim/utils/CustomColors.dart';
import 'package:muntazim/utils/Helper.dart';
import 'package:muntazim/utils/animatedDialogBox.dart';
import 'package:muntazim/utils/openDocument.dart';

class AssignmnetScreen extends StatefulWidget {
  @override
  _AssignmnetScreenState createState() => _AssignmnetScreenState();
}

class _AssignmnetScreenState extends State<AssignmnetScreen> {
  final GlobalKey<ExpansionTileCardState> stCard = new GlobalKey();

  var schoolId;
  String schoolIdName;
  StreamController _dataController = StreamController<bool>.broadcast();
  StreamController _mainController = StreamController<int>.broadcast();

  PermissionService _permissionService = PermissionService();
  List<bool> tileExpansion = List<bool>.filled(4, false);
  bool tileExpansion1 = true,
      tileExpansion2 = false,
      tileExpansion3 = false,
      tileExpansion4 = false;
  final GlobalKey expansionTileKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String student = '';
  var school;
  var sessionId;
  var programId;
  bool searchEnable = false;
  String subjectId;
  String monthId;
  String academicYearName = "";
  String attendancePercentage = "";
String schoolName = "";
  DrawerService _drawerService;
  bool isDrawerOpen = false;
  StreamController _drawerController = StreamController<bool>.broadcast();


  @override
  void initState() {
    var parent = Provider.of<AccountProvider>(context, listen: false);
    super.initState();
    _dataController.add(false);
    _mainController.add(0);
    student = parent.studentName;
    this.sessionId = parent.sessionId;
    this.school = parent.schoolId;
    this.programId = parent.programId;
    this.subjectId = parent.subjectId;
    if (mounted) {
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          this.schoolName = parent.schoolList[0]['school_name'];
          this.academicYearName = parent.schoolYearList[0]['short_name'] ??
              parent.schoolYearList[0]['school_year'];
        });
        _dataController.sink.add(true);
        _mainController.sink.add(1);
      });
    }
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
          appBar: myAppBar(_height, parent),
          backgroundColor: CustomColors.lightBackgroundColor,
          body: Padding(
            padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: StreamBuilder<int>(
              stream: _mainController.stream,
              builder: (context,mainSnapshot){
                if(!mainSnapshot.hasData)
                  return Center(child: Helper.CIndicator());
                else
                  {
                    if(mainSnapshot.data == 0)
                      return Center(child: Helper.CIndicator());
                    else {
                      return SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      splashColor:
                                      CustomColors.darkBackgroundColor.withOpacity(0.5),
                                      onTap: () {
                                        this.animatedAlertBox(
                                            height: _height, parent: parent);
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            //    borderRadius: BorderRadius.all(Radius.circular(1000))
                                          ),
                                          margin: EdgeInsets.only(bottom: 2),
                                          padding: EdgeInsets.all(14),
                                          child: Icon(
                                            Icons.person_search,
                                            color: CustomColors.darkGreenColor,
                                          )),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(5.0))),
                                        margin: EdgeInsets.only(left: 15, bottom: 2),
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
                                                    value: subjectId,
                                                    iconSize: 30,
                                                    icon: (null),
                                                    style: TextStyle(
                                                      color: CustomColors.darkGreenColor,
                                                      fontSize: 16,
                                                    ),
                                                    hint: Text('Select Subject'),
                                                    onChanged: (String newValue) {
                                                      setState(() {
                                                        subjectId = newValue;
                                                      });
                                                      parent.getAssignments(
                                                          subjectId: this.subjectId,
                                                          programId1: this.programId,
                                                          schoolId1: this.school,
                                                          sessionId1: this.sessionId);

                                                      Future.delayed(
                                                          Duration(milliseconds: 1000), () {
                                                        setState(() {});
                                                      });
                                                    },
                                                    items: parent.studentSubjects.values
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
                                    )
                                  ],
                                ),
                                parent.assignmentList.length == 0? Padding(
                                  padding: EdgeInsets.only(top:_height*0.2),
                                  child: Helper.text(value: "No Assignment found",fSize: _height*0.03,fColor: Colors.grey),): Center(),
                                // mainSnapshot.data == 2? Padding(
                                //   padding: EdgeInsets.only(top:_height*0.08),
                                //   child: Helper.CIndicator(),
                                // ):Center(),
                                SizedBox(
                                  height: _height * 0.005,
                                ),
                                parent.dueAssignmentList.length > 0? bodyWidget(
                                    height: _height,
                                    tileTitle: 'Due',
                                    widgetChild:
                                    assignmentData(height: _height,dataList: parent.dueAssignmentDetails, status: 1,parent: parent), //_mylistview2(),
                                    initiallyExpanded: tileExpansion1,
                                    tileExpansionM: tileExpansion1,
                                    onChange: (bool ex) {
                                      setState(() {
                                        if (ex) {
                                          tileExpansion1 = true;
                                          tileExpansion2 = false;
                                          // tileExpansion[0] = ex;
                                          // tileExpansion[1] = !ex;
                                          // tileExpansion[2] = !ex;
                                          // tileExpansion[3] = !ex;
                                        } else
                                          tileExpansion1 = false;
                                      });

                                      print(tileExpansion);
                                    }): Center(),
                                SizedBox(
                                  height: _height * 0.005,
                                ),
                                parent.submittedAssignmentList.length > 0?  bodyWidget(
                                    height: _height,
                                    tileTitle: 'Submitted',
                                    widgetChild:
                                    assignmentData(height: _height,dataList: parent.submittedAssignmentDetails, status: 2,parent: parent), //_mylistview2(),
                                    tileExpansionM: tileExpansion2,
                                    initiallyExpanded: tileExpansion2,
                                    onChange: (bool ex) {
                                      setState(() {
                                        if (ex) {
                                          tileExpansion1 = false;
                                          tileExpansion2 = true;
                                          // tileExpansion[0] = !ex;
                                          // tileExpansion[1] = ex;
                                          // tileExpansion[2] = !ex;
                                          // tileExpansion[3] = !ex;

                                        } else
                                          tileExpansion2 = false;
                                      });

                                      print(tileExpansion);
                                    }): Center(),
                                SizedBox(
                                  height: _height * 0.005,
                                ),
                                parent.gradedAssignmentList.length > 0?  bodyWidget(
                                    height: _height,
                                    tileTitle: 'Graded',
                                    widgetChild:
                                    assignmentData(height: _height,dataList: parent.gradedAssignmentDetails, status: 3,parent: parent), //_mylistview2(),
                                    tileExpansionM: tileExpansion3,
                                    initiallyExpanded: tileExpansion3,
                                    onChange: (bool ex) {
                                      setState(() {
                                        if (ex) {
                                          tileExpansion1 = false;
                                          tileExpansion2 = false;
                                          tileExpansion3 = true;
                                          // tileExpansion[0] = !ex;
                                          // tileExpansion[1] = ex;
                                          // tileExpansion[2] = !ex;
                                          // tileExpansion[3] = !ex;

                                        } else
                                          tileExpansion3 = false;
                                      });

                                      print(tileExpansion);
                                    }) : Center()
                              ],
                            )),
                      );

                    }
                  }

              },
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
                    text: 'Assignments',
                    height: _height,
                    isDrawerOpen: this.isDrawerOpen,
                    onTap: () {
                      _scaffoldKey.currentState.openDrawer();

                    });
              }
            })
        // Helper.myHeader(text: 'Assignments', height: _height,onTap: (){
        //   _scaffoldKey.currentState.openDrawer();
        // }),
      ],
    );
  }

  Widget bodyWidget(
      {double height,
      Widget widgetChild,
      String tileTitle,
      bool initiallyExpanded = false,
      Function onChange,
      bool tileExpansionM}) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          trailing: tileExpansionM
              ? Icon(Icons.keyboard_arrow_up)
              : Icon(Icons.keyboard_arrow_down),
          onExpansionChanged: onChange,
          title: Helper.text(value: '$tileTitle', fSize: height * 0.027),
          children: <Widget>[
            Container(
              //height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10.0, left: 10.0, right: 3.0, bottom: 10.0),
                    child: SizedBox(
                        //height: 30.0,
                        child: Wrap(
                      spacing: height * 0.08,
                      children: <Widget>[
                        Helper.text(
                            value: "Title",
                            fSize: height * 0.025,
                            fColor: Colors.black),
                        Helper.text(
                            value: "Due Date",
                            fSize: height * 0.025,
                            fColor: Colors.black),
                        Helper.text(
                            value: "Actions",
                            fSize: height * 0.025,
                            fColor: Colors.black),
                      ],
                    )),
                  ),
                  Divider(
                    thickness: 2.0,
                    height: 5,
                    indent: 10.0,
                    endIndent: 10.0,
                  ),
                  SizedBox(
                    child: widgetChild,
                  ),
                  // Flexible(
                  //   child: SizedBox(
                  //     child: widgetChild,
                  //   ),
                  // ),
                  ListTile(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget assignmentData({double height , List dataList, int status , AccountProvider parent}) {
    return Column(
      children: List.generate(
          dataList.length,
          (index) => Wrap(
                children: <Widget>[
                  ListTile(
                    tileColor: status == 2? parent.submittedAssignmentList[index]['status'] == AppConstants.ADUEDATE? Colors.red : Colors.white : Colors.white,
                    title: Row(
                     // spacing: height * 0.05,
                      //spacing: height * 0.08,

                      children: <Widget>[
                        ConstrainedBox(constraints: BoxConstraints(maxWidth: 80.0),
                        child:   Helper.text(
                            value: '${dataList[index]['assignment_title']}', fSize: height * 0.02,
                        fColor: status == 2? parent.submittedAssignmentList[index]['status'] == AppConstants.ADUEDATE? Colors.white : CustomColors.darkGreenColor : CustomColors.darkGreenColor),

                        ),
                        Spacer(),
                        Helper.text(
                            value: '${dataList[index]['assignment_date']}', fSize: height * 0.02,

                            fColor: status == 2? parent.submittedAssignmentList[index]['status'] == AppConstants.ADUEDATE? Colors.white : CustomColors.darkGreenColor : CustomColors.darkGreenColor),
                        Spacer(),
                        InkWell(
                          onTap: () {
                           // print(dataList[index]);
                           // print(parent.gradedAssignmentList[index]);
                            parent.changeDetailStatus(status: status,index: index);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        BottomBarNavigationPatternExample(
                                          screenIndex: 5,
                                        )));
                          },
                          child: Helper.text(
                              value: 'Details',
                              fSize: height * 0.02,
                              tDecoration: TextDecoration.underline,
                              fColor: status == 2? parent.submittedAssignmentList[index]['status'] == AppConstants.ADUEDATE? Colors.white : CustomColors.buttonDarkBlueColor : CustomColors.buttonDarkBlueColor),
                        ),


                        //  Helper.text(value: 'View Details',fSize: height*0.017)
                      ],
                    ),
                    // trailing: InkWell(
                    //   onTap: () {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (_) =>
                    //                 BottomBarNavigationPatternExample(
                    //                   screenIndex: 5,
                    //                 )));
                    //   },
                    //   child: Helper.text(
                    //       value: 'Details',
                    //       fSize: height * 0.02,
                    //       tDecoration: TextDecoration.underline,
                    //       fColor: CustomColors.buttonDarkBlueColor),
                    // ),
                    // trailing: Wrap(
                    //   spacing: 10,
                    //   children: <Widget>[
                    //     InkWell(
                    //       child: Icon(
                    //         Icons.download_rounded,
                    //         color: Color.fromRGBO(5, 115, 106, 100),
                    //       ),
                    //     ),
                    //     InkWell(
                    //       child: Icon(
                    //         Icons.remove_red_eye,
                    //         color: Colors.red,
                    //       ),
                    //     )
                    //   ],
                    // ),
                  ),
                  Divider(
                    thickness: 1,
                    height: 0,
                    indent: 10.0,
                    endIndent: 10.0,
                  ),
                ],
              )),
    );
  }

  Widget _mylistview2() {
    return ListView.builder(
        itemCount: 4,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          return Wrap(
            children: <Widget>[
              ListTile(
                title: Wrap(
                  spacing: 50.0,
                  children: <Widget>[
                    Text("Assignment ${index}"),
                    Text("0${index}/01/2020"),
                  ],
                ),
                trailing: Wrap(
                  spacing: 10,
                  children: <Widget>[
                    InkWell(
                      child: Icon(
                        Icons.download_rounded,
                        color: Color.fromRGBO(5, 115, 106, 100),
                      ),
                    ),
                    InkWell(
                      child: Icon(
                        Icons.remove_red_eye,
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                thickness: 1,
                height: 0,
                indent: 10.0,
                endIndent: 10.0,
              ),
            ],
          );
        });
  }

  animatedAlertBox({AccountProvider parent, double height}) async {
    return await showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.7),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                contentPadding: EdgeInsets.zero,

                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                title: Column(children: [
                  Helper.text(value: 'SEARCH', fSize: height * 0.03),
                  Divider(
                    color: Colors.black45,
                  )
                ]),
                content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter boxState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          child: Column(children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 2.0),
                              padding: EdgeInsets.only(
                                left: 15,
                                right: 15,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButton<String>(
                                          value: school,
                                          iconSize: 30,
                                          icon: (null),
                                          style: TextStyle(
                                            color: CustomColors.darkGreenColor,
                                            fontSize: 16,
                                          ),
                                          hint: Text('Select School'),
                                          onChanged: (String newValue) {
                                            _mainController.sink.add(2);
                                            List temp = List.from(parent
                                                .schoolList
                                                .where((element) =>
                                            element['school_id']
                                                .toString() ==
                                                newValue));
                                            boxState(() {
                                              school = newValue;
                                              this.sessionId = null;
                                              this.programId = null;
                                              this.monthId = null;
                                              this.subjectId = null;
                                              this.schoolName = temp[0]['school_name'];
                                            });
                                            parent.getSessions(
                                                schoolId: school);
                                          },
                                          items: parent.schoolList?.map((item) {
                                                return new DropdownMenuItem(
                                                  child: new Text(
                                                    item['school_name'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize:
                                                            item['school_name']
                                                                        .length >
                                                                    12
                                                                ? height * 0.021
                                                                : height *
                                                                    0.023),
                                                  ),
                                                  value: item['school_id']
                                                      .toString(),
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
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 2.0),
                              padding: EdgeInsets.only(left: 15, right: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButton<String>(
                                          value: sessionId,
                                          iconSize: 30,
                                          icon: (null),
                                          style: TextStyle(
                                            color: CustomColors.darkGreenColor,
                                            fontSize: 16,
                                          ),
                                          hint: Text('Select Session'),
                                          onChanged: (String newValue) {
                                            List temp = List.from(parent
                                                .schoolYearList
                                                .where((element) =>
                                                    element['school_session_id']
                                                        .toString() ==
                                                    newValue));

                                            boxState(() {
                                              sessionId = newValue;
                                              this.programId = null;
                                              this.monthId = null;
                                              this.subjectId = null;
                                              this.academicYearName = temp[0]
                                                      ["short_name"] ??
                                                  temp[0]["school_year"];
                                              // print(sessionId);
                                            });

                                            parent.getPrograms(
                                                schoolId: this.school,
                                                sessionId: sessionId);
                                            Future.delayed(
                                                Duration(milliseconds: 500),
                                                () {
                                              print(
                                                  "******${parent.attendancePercentage}");
                                              boxState(() {
                                                attendancePercentage =
                                                    parent.attendancePercentage;
                                              });
                                            });
                                          },
                                          items: parent.schoolYearList
                                                  ?.map((item) {
                                                return new DropdownMenuItem(
                                                  child: new Text(
                                                    item['short_name'] ??
                                                        item['school_year'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: item[
                                                                    'short_name'] !=
                                                                null
                                                            ? height * 0.023
                                                            : item['school_year']
                                                                        .length >
                                                                    12
                                                                ? height * 0.018
                                                                : height *
                                                                    0.023),
                                                  ),
                                                  value:
                                                      item['school_session_id']
                                                          .toString(),
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
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 2.0),
                              padding: EdgeInsets.only(
                                left: 15,
                                right: 15,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButton<String>(
                                          value: programId,
                                          iconSize: 30,
                                          icon: (null),
                                          style: TextStyle(
                                            color: CustomColors.darkGreenColor,
                                            fontSize: 16,
                                          ),
                                          hint: Text('Select Grade'),
                                          onChanged: (String newValue) {
                                            boxState(() {
                                              programId = newValue;
                                              this.monthId = null;
                                              this.subjectId = null;
                                              print(programId);
                                            });
                                            parent.getsubjects(
                                                schoolId1: this.school,
                                                sessionId1: this.sessionId,
                                                programId1: programId);
                                          },
                                          items:
                                              parent.programsList?.map((item) {
                                                    return new DropdownMenuItem(
                                                      child: new Text(
                                                        item['program_title'],
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: item['program_title']
                                                                        .length >
                                                                    12
                                                                ? height * 0.021
                                                                : height *
                                                                    0.023),
                                                      ),
                                                      value: item['program_id']
                                                          .toString(),
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
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 2.0),
                              padding: EdgeInsets.only(
                                left: 15,
                                right: 15,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButton<String>(
                                          value: subjectId,
                                          iconSize: 30,
                                          icon: (null),
                                          style: TextStyle(
                                            color: CustomColors.darkGreenColor,
                                            fontSize: 16,
                                          ),
                                          hint: Text('Select Subject'),
                                          onChanged: (String newValue) {
                                            boxState(() {
                                              subjectId = newValue;
                                              this.monthId = null;

                                              print(subjectId);
                                            });

                                            parent.getAssignments(
                                                subjectId: this.subjectId,
                                                programId1: this.programId,
                                                schoolId1: this.school,
                                                sessionId1: this.sessionId);
                                            Future.delayed(Duration(seconds: 1),(){
                                              _mainController.sink.add(1);
                                            });
                                          },
                                          items: parent.studentSubjects.values
                                                  ?.map((item) {
                                                return new DropdownMenuItem(
                                                  child: new Text(
                                                    item,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: item.length >
                                                                12
                                                            ? height * 0.021
                                                            : height * 0.023),
                                                  ),
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
                          ]),
                        ),
                        Row(children: [
                          multiColorExpandedButton(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              buttonText: "CANCEL",
                              primaryColor: CustomColors.darkGreenColor,
                              secondaryColor: CustomColors.lightGreenColor),
                          multiColorExpandedButton(
                              onTap: () {
                                boxState(() {});
                                Navigator.pop(context);
                              },
                              buttonText: "SEARCH",
                              primaryColor: CustomColors.buttonLightBlueColor,
                              secondaryColor: CustomColors.buttonDarkBlueColor),
                        ]),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    );
                  },
                ),
                // actions: <Widget>[
                //
                // ],
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }

  Widget multiColorExpandedButton(
      {Function onTap, Color primaryColor, Color secondaryColor, buttonText}) {
    return Expanded(
        child: InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [primaryColor, secondaryColor])),
        margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
        padding: EdgeInsets.only(left: 15, right: 15, top: 5.0, bottom: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text('$buttonText',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ],
        ),
      ),
    ));
  }

  Widget myAppBar(_height, AccountProvider parent) {
    return AppBar(
      backgroundColor: Colors.transparent,
      // leading: Padding(
      //     padding: EdgeInsets.only(bottom: 50.0),
      //     child: Icon(Icons.menu_rounded)),
      automaticallyImplyLeading: false,
      title: Padding(
        padding: EdgeInsets.only(bottom: 50.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<StudentModel>(
                stream: parent.studentStream(
                    stId: parent.studentId),
                builder: (_, photo) {
                  if (!photo.hasData) {
                    return CircleAvatar(
                      radius: 30,
                      backgroundColor:CustomColors.lightGreenColor,

                      child: Icon(Icons.person,size: 30,color: Colors.white,),
                    );
                  }
                  return CachedNetworkImage(
                    fit: BoxFit.cover,
                    fadeInCurve: Curves.easeInCirc,
                    imageUrl:
                    photo.data.photo,
                    imageBuilder:
                        (context, imageProvider) =>
                        CircleAvatar(
                          radius: _height * 0.025,
                          backgroundColor: CustomColors.lightGreenColor,
                          child: CircleAvatar(
                            radius: _height * 0.022,
                            backgroundColor: Colors.white,
                            backgroundImage: imageProvider,
                          ),
                        ),
                    placeholder: (context, url) =>
                        CircleAvatar(
                          radius: _height * 0.025,
                          backgroundColor: CustomColors.lightGreenColor,
                          child: CircleAvatar(
                            radius: _height * 0.022,
                            backgroundColor: Colors.white,
                            child: Helper.CIndicator(),
                          ),
                        ),
                    errorWidget: (context, url,
                        error) =>
                        Image.asset(
                            'assets/user_avatar.png'),
                  );
                }),
            SizedBox(
              width: _height * 0.007,
            ),
            Container(
              // width: _height * 0.1,
              height: _height * 0.1,
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  value: student,
                  icon: Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: Colors.white,
                  ),
                  iconSize: _height * 0.025,
                  dropdownColor: CustomColors.darkBackgroundColor,
                  onChanged: (String newValue) {
                      student = newValue;
                      this.sessionId = null;
                      this.school = null;
                      this.programId = null;
                      this.subjectId = null;
                      _mainController.sink.add(0);
                      _dataController.sink.add(false);
                      parent.studentIdUpdate(valueAt: newValue);
                    parent.studentUpdate(isUpdateView: true,assignment: true);
                    if (mounted) {
                      Future.delayed(Duration(seconds: 2), () {
                       // setState(() {
                          this.sessionId = parent.sessionId;
                          this.school = parent.schoolId;
                          this.programId = parent.programId;
                          this.subjectId = parent.subjectId;
                          this.academicYearName = parent.schoolYearList[0]
                          ['short_name'] ??
                              parent.schoolYearList[0]['school_year'];
                          this.schoolName = parent.schoolList[0]['school_name'];

                          // this.monthId = parent.monthId;
                       // });
                        _mainController.sink.add(1);
                        _dataController.sink.add(true);

                      });
                    }

                  },
                  //  isExpanded: true,
                  // isDense: true,
                  items: parent.parents.students.values
                      .map<DropdownMenuItem<String>>((e) {
                    return DropdownMenuItem<String>(
                        value: e, //e.split(' ').last,
                        child: Text(e,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: _height * 0.02)));
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
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
      actions: [
        StreamBuilder<bool>(
            stream: _dataController.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Padding(
                  padding: EdgeInsets.only(right: 15.0, bottom: 10.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [Helper.CIndicator()]),
                );
              } else {
                if(!snapshot.data)
                  {
                    return Padding(
                      padding: EdgeInsets.only(right: 15.0, bottom: 10.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [Helper.CIndicator()]),
                    );
                  }
                else
                  {
                    return Padding(
                      padding: EdgeInsets.only(right: 15.0, bottom: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Helper.text(
                              value: schoolName ??
                                  'School', //'Academic Year',
                              fWeight: FontWeight.bold,
                              fSize: schoolName.length > 12
                                  ? _height * 0.018
                                  : 20.0,
                              fColor: Colors.white),
                          Helper.text(
                              value: academicYearName ??
                                  'Academic Year', //'Academic Year',
                              fWeight: FontWeight.bold,
                              fSize: academicYearName.length > 12
                                  ? _height * 0.016
                                  : 20.0,
                              fColor: Colors.white),
                          Helper.text(
                              value:'', //'Academic Year',
                              fWeight: FontWeight.bold,
                              fSize: _height * 0.016,
                              fColor: Colors.white),
                        ],
                      ),
                    );

                  }
              }
            }),
      ],
    );
  }
}
