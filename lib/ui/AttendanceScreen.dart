import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:muntazim/utils/CustomColors.dart';
import 'package:muntazim/utils/Helper.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel, EventList;
import 'package:muntazim/core/plugins.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  DateTime _currentDate;
  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {},
  );
  List<DateTime> presentDates = [];
  List<DateTime> absentDates = [];
  String student = '';

  var school;

  var sessionId;

  var programId;


  bool searchEnable = false;

  String subjectId;

  String monthId;
  @override
  void initState() {
    var parent = Provider.of<AccountProvider>(context, listen: false);
    super.initState();

    student = parent.studentName;
    this.sessionId = parent.sessionId;
    this.school = parent.schoolId;
    this.programId = parent.programId;
    this.subjectId = parent.subjectId;
    this.monthId = parent.monthId;
    print('%%%%% ${parent.monthId}');
    // _currentDate = DateTime.parse(parent.monthId);

    evnetsFiller(parent: parent);
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
          appBar: myAppBar(_height, parent: parent),
          backgroundColor: CustomColors.lightBackgroundColor,
          body: SingleChildScrollView(
            child: Column(children: [
              InkWell(
                splashColor: CustomColors.darkBackgroundColor.withOpacity(0.5),
                onTap: () {
                  setState(() {
                    searchEnable = true;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                  padding:
                      EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text('Search'),
                      ),
                    ],
                  ),
                ),
              ),
              !searchEnable
                  ? Center()
                  : Filter(parent: parent, height: _height),
              searchEnable
                  ? Center()
                  : mywidget(height: _height, width: _width, parent: parent)
            ]),
          ),
        ),
        Helper.myAlign(text: 'ATTENDANCE', height: _height)
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

  evnetsFiller({AccountProvider parent}) {
    List<String> aa = this.monthId.split('-');
    setState(() {
      _currentDate = DateTime(int.tryParse(aa[1]), int.tryParse(aa[0]), 1);
    });
    if (parent.monthData != null) {
      if (parent.monthData['daily_status'] != null) {
        Map<String, dynamic> status = parent.monthData['daily_status'];
        // print(status);

        status.forEach((key, value) {
          if (value == 'present') {
            presentDates.add(DateTime.parse(key));
          } else if (value == 'absent') {
            absentDates.add(DateTime.parse(key));
          }
        });

        for (int i = 0; i < presentDates.length; i++) {
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

        for (int i = 0; i < absentDates.length; i++) {
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
    // for (int i = 0; i < len; i++) {
    //   a = i + 1;
    //   presentDates.add(new DateTime(2020, 12, a));
    // }
    // a = 0;
    // for (int i = 0; i < len; i++) {
    //   a = i + 1;
    //   absentDates.add(new DateTime(2020, 11, a));
    // }
  }

  Widget Filter({AccountProvider parent, double height}) {
    return Column(children: [
      Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 2.0),
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
                    value: school,
                    iconSize: 30,
                    icon: (null),
                    style: TextStyle(
                      color: CustomColors.darkGreenColor,
                      fontSize: 16,
                    ),
                    hint: Text('Select School'),
                    onChanged: (String newValue) {
                      print(newValue);
                      setState(() {
                        school = newValue;
                        this.sessionId = null;
                        this.programId = null;
                        this.monthId = null;
                        this.subjectId = null;
                        print(school);
                      });
                      // parent.clearSubjectList();
                      parent.getSessions(schoolId: school);
                    },
                    items: parent.schoolList?.map((item) {
                          return new DropdownMenuItem(
                            child: new Text(item['school_name']),
                            value: item['school_id'].toString(),
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
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 2.0),
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      setState(() {
                        sessionId = newValue;
                        this.programId = null;
                        this.monthId = null;
                        this.subjectId = null;
                        print(sessionId);
                      });

                      parent.getPrograms(
                          schoolId: this.school, sessionId: sessionId);
                    },
                    items: parent.schoolYearList?.map((item) {
                          return new DropdownMenuItem(
                            child: new Text(
                              item['school_year'],
                              overflow: TextOverflow.ellipsis,
                            ),
                            value: item['school_session_id'].toString(),
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
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 2.0),
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
                    value: programId,
                    iconSize: 30,
                    icon: (null),
                    style: TextStyle(
                      color: CustomColors.darkGreenColor,
                      fontSize: 16,
                    ),
                    hint: Text('Select Program'),
                    onChanged: (String newValue) {
                      setState(() {
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
                    items: parent.programsList?.map((item) {
                          return new DropdownMenuItem(
                            child: new Text(item['program_title']),
                            value: item['program_id'].toString(),
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
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 2.0),
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

                        print(subjectId);
                      });
                      parent.getMonths(
                          schoolId1: this.school,
                          sessionId1: this.sessionId,
                          programId1: this.programId,
                          subjectId: subjectId);
                    },
                    items: parent.studentSubjects.values?.map((item) {
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
      Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 2.0),
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
                    value: monthId,
                    iconSize: 30,
                    icon: (null),
                    style: TextStyle(
                      color: CustomColors.darkGreenColor,
                      fontSize: 16,
                    ),
                    hint: Text('Select Month'),
                    onChanged: (String newValue) {
                      setState(() {
                        monthId = newValue;

                        print(monthId);
                      });
                      parent.getsubjects(
                          schoolId1: this.school,
                          sessionId1: this.sessionId,
                          programId1: programId);
                    },
                    items: parent.monthsList?.map((item) {
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
      InkWell(
        onTap: () {
          setState(() {
            presentDates.clear();
            absentDates.clear();
            _markedDateMap.clear();
          });
          parent.getMonthData(monthId: this.monthId);
          this.evnetsFiller(parent: parent);
          setState(() {
            searchEnable = false;
          });
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    CustomColors.buttonLightBlueColor,
                    CustomColors.buttonDarkBlueColor
                  ])),
          margin:
              EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
          padding: EdgeInsets.only(left: 15, right: 15, top: 5.0, bottom: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text('SEARCH',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget mywidget({double height, double width, AccountProvider parent}) {
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
          // },
          weekendTextStyle: TextStyle(
            color: Colors.black,
          ),
          thisMonthDayBorderColor: Colors.grey,
          headerMargin: EdgeInsets.zero,
          childAspectRatio: 1.2,
          customGridViewPhysics: BouncingScrollPhysics(),
          headerTitleTouchable: true,
          onHeaderTitlePressed: () {
            print('pressed');
          },
          todayButtonColor: Colors.blue,
          todayBorderColor: Colors.blue,

//      weekDays: null, /// for pass null when you do not want to render weekDays
//      headerText: Container( /// Example for rendering custom header
//        child: Text('Custom Header'),
//      ),
//         customDayBuilder: (
//           /// you can provide your own build function to make custom day containers
//           bool isSelectable,
//           int index,
//           bool isSelectedDay,
//           bool isToday,
//           bool isPrevMonthDay,
//           TextStyle textStyle,
//           bool isNextMonthDay,
//           bool isThisMonthDay,
//           DateTime day,
//         ) {
//           /// If you return null, [CalendarCarousel] will build container for current [day] with default function.
//           /// This way you can build custom containers for specific days only, leaving rest as default.
//
//           // Example: every 15th of month, we have a flight, we can place an icon in the container like that:
//           // if (day.day == 15) {
//           //   return Center(
//           //     child: Icon(Icons.local_airport),
//           //   );
//           // } else {
//           //   return null;
//           // }
//         },
          weekFormat: false,
          markedDatesMap: _markedDateMap,
          markedDateIconMaxShown: 1,
          height: height * 0.42, //420.0,
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
                    days: '${parent.monthData['present_count'] ?? '0'}', //'45',
                    color: Colors.green,
                    height: height,
                    width: width),
                getRow(
                    text: 'Absent',
                    days: '${parent.monthData['absent_count'] ?? '0'}', //'45',
                    color: Colors.red,
                    height: height,
                    width: width),
                getRow(
                    text: 'Tardy',
                    days: '${parent.monthData['tardy_count'] ?? '0'}', //'45',
                    color: Colors.amber,
                    height: height,
                    width: width),
                getRow(
                    text: 'Days not marked',
                    days:
                        '${parent.monthData['days_not_marked'] ?? '0'}', //'45',
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
      leading: Padding(
          padding: EdgeInsets.only(left: _height * 0.015, bottom: 50.0),
          child: Icon(Icons.menu_rounded)),
      leadingWidth: _height * 0.03,
      title: Padding(
        padding: EdgeInsets.only(bottom: 50.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: _height * 0.025,
              backgroundColor: CustomColors.lightGreenColor,
              child: CircleAvatar(
                radius: _height * 0.022,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  color: CustomColors.darkGreenColor,
                  size: _height * 0.022,
                ),
              ),
            ),
            SizedBox(
              width: _height * 0.007,
            ),
            Container(
              width: _height * 0.1,
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
                      this.searchEnable = true;
                    });
                    parent.studentIdUpdate(valueAt: newValue);
                    parent.getSchools(type: true);
                  },
                  isExpanded: true,
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
        Padding(
          padding: EdgeInsets.only(right: 15.0, bottom: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Helper.text(
                  value: 'Academic Year',
                  fWeight: FontWeight.bold,
                  fSize: 20.0,
                  fColor: Colors.white),
              Text('Present',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
              Helper.text(
                  value: '84.50%',
                  fColor: Colors.white,
                  fWeight: FontWeight.w400,
                  fSize: 15.0)
            ],
          ),
        )
      ],
    );
  }
}
