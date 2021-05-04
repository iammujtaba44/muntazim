import 'package:muntazim/ui/AttendanceScreen.dart';
import 'package:muntazim/ui/HomeScreen.dart';
import 'package:muntazim/ui/TranscriptScreen.dart';
import 'package:muntazim/ui/announcement/AnnouncementsScreen.dart';
import 'package:muntazim/ui/bottom_bar_navigation_pattern/animated_bottom_bar.dart';
import 'package:muntazim/ui/fees/FeesScreen.dart';

import 'package:muntazim/core/plugins.dart';

class BottomBarNavigationPatternExample extends StatefulWidget {
  int screenIndex;
  final List<BarItem> barItems = [
    BarItem(
      text: "Home",
      iconData: Icons.home,
      color: CustomColors.darkBackgroundColor, //Colors.indigo,
    ),
    BarItem(
      text: "Transcript",
      iconData: Icons.assignment,
      color: CustomColors.darkBackgroundColor, //Colors.teal,
    ),
    BarItem(
      text: "Attendance",
      iconData: Icons.calendar_today,
      color: CustomColors.darkBackgroundColor, //Colors.pinkAccent,
    ),
    BarItem(
      text: "Assign.",
      iconData: Icons.payment,
      color: CustomColors.darkBackgroundColor, //Colors.pinkAccent,
    ),
    BarItem(
      text: "Notification",
      iconData: Icons.notifications,
      color: CustomColors.darkBackgroundColor, //Colors.yellow.shade900,
    ),
  ];
  BottomBarNavigationPatternExample({this.screenIndex});

  @override
  _BottomBarNavigationPatternExampleState createState() =>
      _BottomBarNavigationPatternExampleState();
}

class _BottomBarNavigationPatternExampleState
    extends State<BottomBarNavigationPatternExample> {
  int selectedBarIndex = 0;

  List<Widget> _screens = [
    HomeScreen(),
    TranscriptScreen(),
    AttendanceScreen(),
    AssignmnetScreen(),
    AnnouncementsScreen(),
    AssignmnetDetailScreen(),

  ];

  @override
  void initState() {
    super.initState();
    if (widget.screenIndex > 0) selectedBarIndex = widget.screenIndex;
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    var parent = Provider.of<AccountProvider>(context);

    return Scaffold(
      backgroundColor:
          CustomColors.lightBackgroundColor, //CustomColors.darkBackgroundColor,
      body: _screens[selectedBarIndex],
      // body: AnimatedContainer(
      //   //  color: CustomColors.darkBackgroundColor, //widget.barItems[selectedBarIndex].color,
      //   duration: const Duration(milliseconds: 300),
      // ),
      bottomNavigationBar: AnimatedBottomBar(
          barItems: widget.barItems,
          currentIndex: selectedBarIndex,
          animationDuration: const Duration(milliseconds: 150),
          barStyle: BarStyle(fontSize: 12.0, iconSize: 20.0),
          onBarTap: (index) {
            print(index);
            if (index > 0 && index < 4) {
              parent.studentUpdate(
                  valueAt: 0, attendance: index == 2 ? true : false);
            }
            setState(() {
              selectedBarIndex = index;
              // print(selectedBarIndex);
            });
          }),
    );
  }
}
