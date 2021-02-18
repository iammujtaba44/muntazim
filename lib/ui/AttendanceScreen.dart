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
  @override
  void initState() {
    var parent = Provider.of<AccountProvider>(context, listen: false);
    super.initState();

    student = parent.student;

    evnetsFiller();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    var parent = Provider.of<AccountProvider>(context);
    Provider.of<AccountProvider>(context).userStream.listen((event) {});

    return Stack(
      children: [
        Scaffold(
          appBar: myAppBar(_height, parent: parent),
          backgroundColor: CustomColors.lightBackgroundColor,
          body: SingleChildScrollView(
            child: mywidget(height: _height, width: _width),
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

  evnetsFiller() {
    for (int i = 0; i < len; i++) {
      a = i + 1;
      presentDates.add(new DateTime(2020, 12, a));
    }
    a = 0;
    for (int i = 0; i < len; i++) {
      a = i + 1;
      absentDates.add(new DateTime(2020, 11, a));
    }

    for (int i = 0; i < len; i++) {
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

    for (int i = 0; i < len; i++) {
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

  Widget mywidget({double height, double width}) {
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
                    'Sessions',
                    style: TextStyle(fontSize: width * 0.05),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 17.0,
                  ),
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
                    days: '45',
                    color: Colors.green,
                    height: height,
                    width: width),
                getRow(
                    text: 'Absent',
                    days: '45',
                    color: Colors.red,
                    height: height,
                    width: width),
                getRow(
                    text: 'Tardy',
                    days: '45',
                    color: Colors.amber,
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
              height: 20,
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
                    setState(() {
                      student = newValue;
                    });
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
            // Text(
            //     '${parent.parents.students.values.elementAt(0).split(' ').last}',
            //     style: TextStyle(
            //         fontWeight: FontWeight.w400, fontSize: _height * 0.02)),
            // Icon(
            //   Icons.keyboard_arrow_down_outlined,
            //   color: Colors.white,
            // )
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
