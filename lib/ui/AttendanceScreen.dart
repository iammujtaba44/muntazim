import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:muntazim/core/services/models/studentModel/StudentModel.dart';
import 'package:muntazim/utils/CustomColors.dart';
import 'package:muntazim/utils/Helper.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel, EventList;
import 'package:muntazim/core/plugins.dart';
import 'package:muntazim/utils/animatedDialogBox.dart';
import 'package:muntazim/utils/get_student_image.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  DateTime _currentDate = DateTime.now();
  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {},
  );
  List<DateTime> presentDates = [];
  List<DateTime> absentDates = [];
  List<DateTime> daysNotMarkedDates = [];
  String student = '';
  StreamController _calenderStream = StreamController<bool>.broadcast();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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

    _calenderStream.add(true);
    // WidgetsBinding.instance.addPostFrameCallback((_){animatedAlertBox(parent: parent,height: MediaQuery.of(context).size.height);});
    student = parent.studentName;
    this.sessionId = parent.sessionId;
    this.school = parent.schoolId;
    this.programId = parent.programId;
    this.subjectId = parent.subjectId;

    if (mounted) {
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          this.attendancePercentage = parent.attendancePercentage ?? null;
          print("-----+****${parent.schoolYearList[0]['school_session_id']}");
          this.schoolName = parent.schoolList[0]['school_name'];
          this.academicYearName = parent.schoolYearList[0]['short_name'] ??
              parent.schoolYearList[0]['school_year'];

          this.monthId = parent.monthId;
        });
        eventsFiller(parent: parent);
      });
    }
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

  String getProgramName(AccountProvider parent) {
    if (parent.programsList != null) {
      List<dynamic> list = List.from(parent.programsList.where(
          (element) => element['program_id'].toString().contains(programId)));
      if (list.isNotEmpty)
        return list[0]['program_title'];
      else
        return null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    var parent = Provider.of<AccountProvider>(context);
    // Provider.of<AccountProvider>(context).userStream.listen((event) {});

    return Stack(
      children: [
        Scaffold(
          key: _scaffoldKey,
          drawer: DrawerView(),
          appBar: myAppBar(_height, parent: parent),
          backgroundColor: CustomColors.lightBackgroundColor,
          body: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //  Helper.text(value: 'Grade : ${getProgramName(parent)??''}'),

              Row(
                children: [
                  InkWell(
                    splashColor:
                        CustomColors.darkBackgroundColor.withOpacity(0.5),
                    onTap: () {
                      // this.myDialogBox(height: _height, parent: parent);
                      this.animatedAlertBox(height: _height, parent: parent);

                      // setState(() {
                      //   searchEnable = true;
                      // });
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          //    borderRadius: BorderRadius.all(Radius.circular(1000))
                        ),
                        margin: EdgeInsets.only(left: 15, bottom: 2, right: 0),
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
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      margin: EdgeInsets.only(left: 15, bottom: 2, right: 15),
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
                                      this.monthId = null;
                                    });
                                    parent.getMonths(
                                        schoolId1: this.school,
                                        sessionId1: this.sessionId,
                                        programId1: this.programId,
                                        subjectId: subjectId);
                                    Future.delayed(Duration(milliseconds: 500),
                                        () {
                                      setState(() {
                                        presentDates.clear();
                                        absentDates.clear();
                                        _markedDateMap.clear();
                                      });
                                      eventsFiller(parent: parent);
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

              bodyWidget(height: _height, width: _width, parent: parent)
              // !searchEnable
              //     ? Center()
              //     : Filter(parent: parent, height: _height),
              // searchEnable
              //     ? Center()
              //     : mywidget(height: _height, width: _width, parent: parent)
            ]),
          ),
        ),
        StreamBuilder(
            stream: _drawerController.stream,
            builder: (context, drawerShot) {
              if (!drawerShot.hasData)
                return Center();
              else {
                return Helper.myHeader(
                    text: 'ATTENDANCE',
                    height: _height,
                    isDrawerOpen: this.isDrawerOpen,
                    onTap: () {
                      _scaffoldKey.currentState.openDrawer();
                    });
              }
            })
        // Helper.myHeader(text: 'ATTENDANCE', height: _height,onTap: (){
        //   _scaffoldKey.currentState.openDrawer();
        // })
      ],
    );
  }

  int len = 5;
  int a = 0;

  static Widget _presentIcon(String day) => Container(
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.all(
            Radius.circular(1000),
          ),
        ),
        child: Center(
          child: Text(
            day,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      );

  static Widget _absentIcon(String day) => Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(
            Radius.circular(1000),
          ),
        ),
        child: Center(
          child: Text(
            day,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      );

  eventsFiller({AccountProvider parent}) {
    print("*****(Event filler call method -> Attendance Screen)*****");

    /// Here we populate the all dates of months into calender
    /// There are two types of loops
    /// 1 : Present icons which show number of present days/month
    /// 2 : Absent icon which show number of absent days/ month

    // print("*****(Month Id -> ${monthId})");
    // List<String> aa = this.monthId.split('-');
    // setState(() {
    //   _currentDate = DateTime(int.tryParse(aa[1]), int.tryParse(aa[0]), 1);
    // });
    this.setState(() {
      // _currentDate = DateTime.now();
      monthId =
          "${_currentDate.month < 10 ? "0${_currentDate.month}" : _currentDate.month}-${_currentDate.year}";
    });
    _calenderStream.sink.add(true);
    print("MONTH LIST ---> ${parent.monthsList.length}");
    for (int i = 0; i < parent.monthsList.length; i++) {
      parent.getMonthData(monthId: parent.monthsList[i]);
      if (parent.monthData != null) {
        if (parent.monthData['daily_status'].isNotEmpty) {
          Map<String, dynamic> status = parent.monthData['daily_status'];
          status.forEach((key, value) {
            if (value == 'present') {
              presentDates.add(DateTime.parse(key));
            } else if (value == 'absent') {
              absentDates.add(DateTime.parse(key));
            }
          });

          for (int i = 0; i < presentDates.length; i++) {
            if (!_markedDateMap.events.keys.contains(presentDates[i])) {
              _markedDateMap.add(
                presentDates[i],
                new Event(
                    date: presentDates[i],
                    title: 'Event 5',
                    dot: Container(
                      margin: EdgeInsets.symmetric(horizontal: 1.0),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(
                          Radius.circular(1000),
                        ),
                      ),
                      height: 7.0,
                      width: 7.0,
                    )),
              );
            }
          }

          for (int i = 0; i < absentDates.length; i++) {
            if (!_markedDateMap.events.keys.contains(absentDates[i])) {
              _markedDateMap.add(
                absentDates[i],
                new Event(
                    date: absentDates[i],
                    title: 'Event 5',
                    dot: Container(
                      margin: EdgeInsets.symmetric(horizontal: 1.0),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(
                          Radius.circular(1000),
                        ),
                      ),
                      height: 7.0,
                      width: 7.0,
                    )),
              );
            }
          }
        }
      }
    }
  }

  Widget bodyWidget(
      {@required double height,
      @required double width,
      @required AccountProvider parent}) {
    return StreamBuilder(
        stream: _calenderStream.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Padding(
                padding: EdgeInsets.only(
                  top: height * 0.1,
                  // left: width * 0.4,
                ),
                child: Helper.CIndicator(),
              ),
            );
          } else {
            return Column(children: [
              Container(
                //height: height * 0.4,
                margin: EdgeInsets.symmetric(horizontal: 15.0),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                child: CalendarCarousel<Event>(
                  scrollDirection: Axis.horizontal,
                  pageScrollPhysics: BouncingScrollPhysics(),
                  // onDayPressed: (DateTime date, List<Event> events) {
                  //   this.setState(() => _currentDate = date);
                  //   print("****** Current day => ${_currentDate.year} && Current month => ${_currentDate.month}");
                  //
                  // },
                  weekendTextStyle: TextStyle(
                    color: Colors.black,
                  ),
                  onCalendarChanged: (DateTime date) {
                    this.setState(() => _currentDate = date);
                    this.setState(() {
                      monthId =
                          "${_currentDate.month < 10 ? "0${_currentDate.month}" : _currentDate.month}-${_currentDate.year}";
                    });
                  },

                  thisMonthDayBorderColor: Colors.grey,
                  headerMargin: EdgeInsets.zero,
                  childAspectRatio: 1.2,
                  customGridViewPhysics: BouncingScrollPhysics(),
                  headerTitleTouchable: true,
                  showOnlyCurrentMonthDate: true,
                  onHeaderTitlePressed: () {
                    print('pressed');
                  },
                  todayButtonColor: Colors.blue,
                  todayBorderColor: Colors.blue,
                  weekFormat: false,
                  markedDatesMap: _markedDateMap,
                  markedDateIconMaxShown: 1,
                  height: height * 0.42,
                  //420.0,
                  width: width * 0.9,
                  selectedDateTime: _currentDate,
                  daysHaveCircularBorder: false,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          color: Colors.white),
                      child: Column(children: [
                        Row(children: [
                          Text(
                            '${this.monthId ?? ''}', //'Sessions',
                            style: TextStyle(fontSize: width * 0.05),
                          ),
                          // Icon(
                          //   Icons.keyboard_arrow_down,
                          //   size: 17.0,
                          // ),
                          Spacer(),
                          Text(
                            'days',
                            style: TextStyle(fontSize: width * 0.05),
                          )
                        ]),
                        Divider(
                          thickness: 2.0,
                        ),
                        getRow(
                            text: 'Present',
                            days:
                                '${parent.monthFilterdWithSubject[monthId] == null ? "0" : parent.monthFilterdWithSubject[monthId]['present_count'] ?? '0'}', //'${parent.monthData['present_count'] ?? '0'}',
                            //'45',
                            color: Colors.green,
                            height: height,
                            width: width),
                        getRow(
                            text: 'Absent',
                            days:
                                '${parent.monthFilterdWithSubject[monthId] == null ? "0" : parent.monthFilterdWithSubject[monthId]['absent_count'] ?? '0'}', //'${parent.monthData['absent_count'] ?? '0'}',
                            //'45',
                            color: Colors.red,
                            height: height,
                            width: width),
                        getRow(
                            text: 'Tardy',
                            days:
                                '${parent.monthFilterdWithSubject[monthId] == null ? "0" : parent.monthFilterdWithSubject[monthId]['tardy_count'] ?? '0'}', //'${parent.monthData['tardy_count'] ?? '0'}',
                            //'45',
                            color: Colors.amber,
                            height: height,
                            width: width),
                        getRow(
                            text: 'Days not marked',
                            days:
                                '${parent.monthFilterdWithSubject[monthId] == null ? "0" : parent.monthFilterdWithSubject[monthId]['days_not_marked'] ?? '0'}', //'${parent.monthData['days_not_marked'] ?? '0'}',
                            //'45',
                            color: Colors.black45,
                            height: height,
                            width: width),
                        SizedBox(
                          height: 20.0,
                        )
                      ]),
                    )
                  ],
                ),
              )
            ]);
          }
        });
  }

  Widget getRow(
      {dynamic text, Color color, dynamic days, double width, double height}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(3.0)),
              color: color),
          height: 20,
          width: 20,
        ),
        SizedBox(
          width: 10.0,
        ),
        Text(
          text,
          style: TextStyle(color: Colors.grey, fontSize: width * 0.045),
        ),
        Spacer(),
        Text(
          days,
          style: TextStyle(color: Colors.grey, fontSize: width * 0.045),
        ),
      ]),
    );
  }

  Widget myAppBar(double _height, {AccountProvider parent}) {
    return AppBar(
      backgroundColor: Colors.transparent,
      // leading: Padding(
      //     padding: EdgeInsets.only(left: _height * 0.015, bottom: 50.0),
      //     child: Icon(Icons.menu_rounded)),
      automaticallyImplyLeading: false,
      leadingWidth: _height * 0.03,
      title: Padding(
        padding: EdgeInsets.only(bottom: 50.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetStudentImage(
              model: parent,
            ),
            SizedBox(
              width: _height * 0.007,
            ),
            Container(
              // width: _height * 0.13,
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
                    this.setState(() {
                      student = newValue;
                      this.sessionId = null;
                      this.school = null;
                      this.programId = null;
                      this.subjectId = null;
                      this.monthId = null;

                      presentDates.clear();
                      absentDates.clear();
                      _markedDateMap.clear();
                      //    this.searchEnable = true;
                    });
                    parent.studentIdUpdate(valueAt: newValue);
                    parent.studentUpdate(attendance: true, isUpdateView: true);
                    //parent.getSchools(type: true);
                    //_calenderStream.sink.add(true);
                    if (mounted) {
                      Future.delayed(Duration(seconds: 2), () {
                        setState(() {
                          this.sessionId = parent.sessionId;
                          this.school = parent.schoolId;
                          this.programId = parent.programId;
                          this.subjectId = parent.subjectId;
                          this.academicYearName = parent.schoolYearList[0]
                                  ['short_name'] ??
                              parent.schoolYearList[0]['school_year'];
                          this.schoolName = parent.schoolList[0]['school_name'];

                          // this.monthId = parent.monthId;
                        });
                        eventsFiller(parent: parent);
                      });
                    }
                  },
                  // isExpanded: true,
                  isDense: true,
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
        StreamBuilder(
            stream: _calenderStream.stream,
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
                return Padding(
                  padding: EdgeInsets.only(right: 15.0, bottom: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Helper.text(
                          value: schoolName ?? 'School', //'Academic Year',
                          fWeight: FontWeight.bold,
                          fSize:
                              schoolName.length > 12 ? _height * 0.018 : 20.0,
                          fColor: Colors.white),
                      Helper.text(
                          value: academicYearName ??
                              'Academic Year', //'Academic Year',
                          fWeight: FontWeight.bold,
                          fSize: academicYearName.length > 12
                              ? _height * 0.016
                              : 20.0,
                          fColor: Colors.white),
                      // x
                      Helper.text(
                          value: attendancePercentage ?? '00.00%',
                          fColor: Colors.white,
                          fWeight: FontWeight.w400,
                          fSize: 15.0)
                    ],
                  ),
                );
              }
            }),
      ],
    );
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
                                              this.schoolName =
                                                  temp[0]['school_name'];
                                              //   print(school);
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
                                            parent.getMonths(
                                                schoolId1: this.school,
                                                sessionId1: this.sessionId,
                                                programId1: this.programId,
                                                subjectId: subjectId);
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
                            //    secondaryColor: CustomColors.lightGreenColor
                          ),
                          multiColorExpandedButton(
                            onTap: () {
                              boxState(() {
                                presentDates.clear();
                                absentDates.clear();
                                _markedDateMap.clear();
                              });
                              eventsFiller(parent: parent);
                              Navigator.pop(context);
                            },
                            buttonText: "SEARCH",
                            primaryColor: CustomColors.buttonLightBlueColor,
                            //    secondaryColor: CustomColors.buttonDarkBlueColor
                          ),
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
          color: primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          // gradient: LinearGradient(
          //     begin: Alignment.centerLeft,
          //     end: Alignment.centerRight,
          //     colors: [primaryColor, secondaryColor])
        ),
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
}
