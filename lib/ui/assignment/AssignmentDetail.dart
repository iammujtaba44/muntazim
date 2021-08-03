import 'dart:async';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:muntazim/core/plugins.dart';
import 'package:muntazim/utils/CustomColors.dart';
import 'package:muntazim/utils/Helper.dart';
import 'package:muntazim/utils/animatedDialogBox.dart';
import 'package:muntazim/utils/openDocument.dart';

class AssignmnetDetailScreen extends StatefulWidget {
  // final assignmentData;

  // AssignmnetDetailScreen({Key key, this.assignmentData}) : super(key: key);
  @override
  _AssignmnetDetailScreenState createState() => _AssignmnetDetailScreenState();
}

class _AssignmnetDetailScreenState extends State<AssignmnetDetailScreen> {
  final GlobalKey<ExpansionTileCardState> stCard = new GlobalKey();

  var schoolId;
  String schoolIdName;
  StreamController<bool> dataController = StreamController<bool>.broadcast();
  PermissionService _permissionService = PermissionService();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  StreamController _mainController = StreamController<int>.broadcast();

  List dataList = List();
  dynamic data;

  dynamic teacherName;
  DrawerService _drawerService;
  bool isDrawerOpen = false;
  StreamController _drawerController = StreamController<bool>.broadcast();

  @override
  void initState() {
    var parent = Provider.of<AccountProvider>(context, listen: false);
    super.initState();
    _mainController.add(0);
    populateData(parent: parent);
    _drawerController.add(false);
    _drawerService = Provider.of(context, listen: false);
    _listenDrawerService();
    Future.delayed(Duration(milliseconds: 200), () {
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
            child: StreamBuilder(
              stream: _mainController.stream,
              builder: (context, snapShot) {
                if (!snapShot.hasData)
                  return Center(child: Helper.CIndicator());
                else {
                  if (snapShot.data == 0)
                    return Center(child: Helper.CIndicator());
                  else {
                    return SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Container(
                          child: Column(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: _width,
                            padding: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))),
                            child: getRow(
                                key: 'Student',
                                value: '${parent.studentName ?? '...'}'),
                          ),
                          SizedBox(
                            height: _height * 0.017,
                          ),
                          Container(
                              width: _width,
                              padding: EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                              child: Column(
                                children: [
                                  getRow(
                                      key: 'Teacher',
                                      value: '${teacherName ?? '...'}'),
                                  getRow(
                                      key: 'Assignment type',
                                      value:
                                          '${dataList[0]['assignment_type'] ?? '.. ..'}'),
                                ],
                              )),
                          SizedBox(
                            height: _height * 0.017,
                          ),
                          Container(
                              width: _width,
                              padding: EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                              child: Column(
                                children: [
                                  getRow(
                                      key: 'Assigned Date',
                                      value:
                                          '${dataList[0]['assignment_date'] ?? '.. ..'}'),
                                  getRow(
                                      key: 'Due Date',
                                      value:
                                          '${dataList[0]['assignment_due_date'] ?? '.. ..'}'),
                                  parent.detailStatus == 3
                                      ? getRow(
                                          key: 'Submission Date',
                                          value:
                                              '${parent.gradedAssignmentList[parent.detailIndex]['submission_date'] ?? '.. ..'}')
                                      : Center(),
                                ],
                              )),
                          SizedBox(
                            height: _height * 0.017,
                          ),
                          Container(
                              width: _width,
                              padding: EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Helper.text(
                                      value: 'Description',
                                      fSize: _height * 0.027),
                                  SizedBox(
                                    height: _height * 0.017,
                                  ),
                                  Container(
                                    child: Helper.text(
                                        value:
                                            '${dataList[0]['description'] ?? '.. ..'}',
                                        fSize: _height * 0.025),
                                  )
                                ],
                              )),
                          SizedBox(
                            height: _height * 0.017,
                          ),
                          Container(
                              width: _width,
                              padding: EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Helper.text(
                                      value: 'Attachments',
                                      fSize: _height * 0.027),
                                  SizedBox(
                                    height: _height * 0.017,
                                  ),
                                  dataList[0]['document'] == null
                                      ? Helper.text(
                                          value: 'No attachments',
                                          fSize: _height * 0.025,
                                          fColor: Colors.grey)
                                      : Wrap(
                                          runSpacing: 5.0,
                                          children: List.generate(
                                              dataList[0]['document'].length,
                                              (index) {
                                            List temp = dataList[0]['document']
                                                    [index]
                                                .split('%');
                                            return InkWell(
                                                onTap: () {
                                                  openDocument(dataList[0]
                                                      ['document'][index]);
                                                },
                                                child: Wrap(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: _height * 0.023,
                                                      backgroundColor:
                                                          CustomColors
                                                              .darkGreenColor,
                                                      child: CircleAvatar(
                                                        radius: _height * 0.021,
                                                        backgroundColor:
                                                            Colors.white,
                                                        child: Icon(
                                                          Icons
                                                              .download_rounded,
                                                          color: CustomColors
                                                              .darkGreenColor,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10.0,
                                                    ),
                                                    temp.length < 2
                                                        ? Helper.text(
                                                            value: '${temp[0]}',
                                                            fSize:
                                                                _height * 0.02)
                                                        : Helper.text(
                                                            value:
                                                                '${dataList[0]['document'][index].split('%')[1].split('?')[0]}',
                                                            fSize:
                                                                _height * 0.02)
                                                    // Helper.text(
                                                    //     value: 'Attachment.pdf',
                                                    //     fSize: _height * 0.025)
                                                  ],
                                                )
                                                // child: Helper.text(
                                                //     value: data['attachment'][index],
                                                //     fSize: height * 0.016,
                                                //     fColor: CustomColors.darkGreenColor,
                                                //     fWeight: FontWeight.bold),
                                                );
                                          }))
                                ],
                              ))
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
            builder: (context, drawerShot) {
              if (!drawerShot.hasData)
                return Center();
              else {
                return Helper.myHeader(
                    text: 'Assignment Detail',
                    height: _height,
                    isDrawerOpen: this.isDrawerOpen,
                    onTap: () {
                      _scaffoldKey.currentState.openDrawer();
                    });
              }
            })
        // Helper.myHeader(text: 'Assignment Detail', height: _height, onTap: (){
        //   _scaffoldKey.currentState.openDrawer();
        // }),
      ],
    );
  }

  Widget getRow({String key, String value, double height}) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Helper.text(value: '$key', fSize: height * 0.027),
        Spacer(),
        Helper.text(value: '$value', fSize: height * 0.025)
      ],
    );
  }

  Widget myAppBar(_height, AccountProvider parent) {
    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      leading: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Padding(
            padding: EdgeInsets.only(bottom: 50.0),
            child: Icon(Icons.arrow_back_sharp)),
      ),
      leadingWidth: _height * 0.035,
      title: Padding(
        padding: EdgeInsets.only(bottom: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Helper.text(
                value: '${dataList[0]['assignment_title'] ?? '.. ..'}',
                fSize: _height * 0.03,
                fColor: Colors.white)
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
        Padding(
          padding: EdgeInsets.only(right: 15.0, bottom: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(right: _height * 0.0),
                child: Helper.text(
                  value:
                      '${parent.detailStatus == 3 ? AppConstants.GRADED : parent.detailStatus == 2 ? AppConstants.SUBMITTED : parent.detailStatus == 1 ? AppConstants.DUE : "Unknown"}',
                  fWeight: FontWeight.bold,
                  fColor: Colors.white,
                  fSize: _height * 0.03,
                ),
              ),
              parent.gradedAssignmentList.isEmpty
                  ? Helper.text(
                      value: '(0/${dataList[0]['total_marks']}) ',
                      fWeight: FontWeight.bold,
                      fColor: Colors.white,
                      fSize: _height * 0.025,
                    )
                  : parent.gradedAssignmentList[parent.detailIndex]['marks'] !=
                              null ||
                          parent.gradedAssignmentList[parent.detailIndex]
                                  ['marks'] !=
                              ""
                      ? Helper.text(
                          value:
                              '(${parent.gradedAssignmentList[parent.detailIndex]['marks']}/${dataList[0]['total_marks']}) ',
                          fWeight: FontWeight.bold,
                          fColor: Colors.white,
                          fSize: _height * 0.025,
                        )
                      : Helper.text(
                          value: '(0/${dataList[0]['total_marks']}) ',
                          fWeight: FontWeight.bold,
                          fColor: Colors.white,
                          fSize: _height * 0.025,
                        ),
            ],
          ),
        )
      ],
    );
  }

  void populateData({AccountProvider parent}) {
    if (parent.detailStatus == 1)
      dataList.add(parent.dueAssignmentDetails[parent.detailIndex]);
    if (parent.detailStatus == 2)
      dataList.add(parent.submittedAssignmentDetails[parent.detailIndex]);
    if (parent.detailStatus == 3)
      dataList.add(parent.gradedAssignmentDetails[parent.detailIndex]);

    Future.delayed(Duration(seconds: 1), () {
      try {
        DatabaseServices()
            .teachers
            .doc(dataList[0]['teacher_id'])
            .get()
            .then((value) {
          //   print("===== Teacher's data -> ${value.data()}");
          teacherName = "${value.data()['first_name']}";
          _mainController.sink.add(1);
        });
      } catch (e) {
        _mainController.sink.add(1);
      }
      // print("^^^^${dataList}");
    });
  }
}
