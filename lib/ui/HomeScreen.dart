import 'package:muntazim/core/plugins.dart';
import 'package:muntazim/core/services/models/SchoolModel.dart';
import 'package:muntazim/core/services/models/SchoolYearsModel.dart';
import 'package:muntazim/core/services/models/studentModel/StudentModel.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ExpansionTileCardState> stCard = new GlobalKey();
  @override
  void initState() {
    super.initState();

    DatabaseServices().test();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    PopupMenu.context = context;
    var parent = Provider.of<AccountProvider>(context);
    var user = Provider.of<UserProvider>(context);

    // DatabaseServices().schoolStream(stId: '398').listen((event) {});
    return Stack(
      children: [
        Scaffold(
          appBar: myAppBar(_height, _width, user: user),
          backgroundColor: CustomColors.lightBackgroundColor,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder<AccountModel>(
                    stream: parent.userStream(
                        Id: '${user.parentData != null ? user.parentData.masjidId : ''}_${user.parentData != null ? user.parentData.parentId : ''}'),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Padding(
                          padding: EdgeInsets.only(
                            top: _height * 0.2,
                            left: _width * 0.4,
                          ),
                          child: CircularProgressIndicator(),
                        );
                      }
                      AccountModel data = snapshot.data;
                      // print(data.students);

                      if (data.students != null) {
                        return Padding(
                          padding:
                              EdgeInsets.fromLTRB(25, _height * 0.05, 25, 0),
                          child: Column(
                            children:
                                List.generate(data.students.length, (index) {
                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: _height * 0.01),
                                      child: ExpansionTileCard(
                                        //key: stCard,
                                        animateTrailing: true,
                                        shadowColor:
                                            CustomColors.darkGreenColor,
                                        duration: Duration(seconds: 1),
                                        elevation: 2.0,
                                        elevationCurve: Curves.bounceOut,
                                        heightFactorCurve: Curves.easeInOut,
                                        contentPadding: EdgeInsets.all(10.0),
                                        leading: CircleAvatar(
                                          radius: 30.0,
                                          backgroundColor:
                                              CustomColors.lightGreenColor,
                                        ),
                                        title: Helper.text(
                                            value:
                                                '${data.students.values.elementAt(index)}',
                                            fSize: _height * 0.025),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            StreamBuilder<StudentModel>(
                                                stream: parent.studentStream(
                                                    stId: data.students.keys
                                                        .elementAt(index)),
                                                builder: (_, student) {
                                                  if (!student.hasData) {
                                                    return Helper.text(
                                                        value: '... .. ... .',
                                                        fSize: _height * 0.02);
                                                  }

                                                  return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: List.generate(
                                                          student.data.schools
                                                              .length,
                                                          (sdIndex) {
                                                        return StreamBuilder<
                                                                SchoolModel>(
                                                            stream: parent.schoolStream(
                                                                schoolId: student
                                                                    .data
                                                                    .schools
                                                                    .keys
                                                                    .elementAt(
                                                                        sdIndex)),
                                                            builder:
                                                                (_, school) {
                                                              if (!school
                                                                  .hasData) {
                                                                return Helper.text(
                                                                    value:
                                                                        '... .. ... .',
                                                                    fSize:
                                                                        _height *
                                                                            0.02);
                                                              }
                                                              return Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Helper.text(
                                                                        value:
                                                                            '${school.data.schoolName}',
                                                                        fSize: _height *
                                                                            0.02),
                                                                    Column(
                                                                        crossAxisAlignment: CrossAxisAlignment
                                                                            .start,
                                                                        children: List.generate(
                                                                            student.data.schools.values.elementAt(sdIndex).schoolYears.length,
                                                                            (schoolYearIndex) {
                                                                          return StreamBuilder<SchoolYearsModel>(
                                                                              stream: parent.schoolYearStream(schoolYearId: student.data.schools.values.elementAt(sdIndex).schoolYears.keys.elementAt(schoolYearIndex)),
                                                                              builder: (_, schoolYear) {
                                                                                if (!schoolYear.hasData) {
                                                                                  return Helper.text(value: '... .. ... .', fSize: _height * 0.017);
                                                                                }
                                                                                return Helper.text(value: schoolYear.data.schoolYear, fSize: _height * 0.017);
                                                                              });
                                                                        }))
                                                                    // Helper.text(
                                                                    //     value: 'Grade',
                                                                    //     fSize: _height *
                                                                    //         0.017)
                                                                  ]);
                                                            });
                                                      }));
                                                }),
                                            // parent.students.isEmpty
                                            //     ? Helper.text(
                                            //         value: '... .. ... .',
                                            //         fSize: _height * 0.02)
                                            //     : StreamBuilder<SchoolModel>(
                                            //         stream: parent.schoolStream(
                                            //             schoolId: parent
                                            //                 .students[index]
                                            //                 .schools
                                            //                 .keys
                                            //                 .elementAt(0)),
                                            //         builder: (_, snapshot1) {
                                            //           if (!snapshot1.hasData) {
                                            //             return Helper.text(
                                            //                 value: '... .. ... .',
                                            //                 fSize: _height * 0.02);
                                            //           }
                                            //           return Helper.text(
                                            //               value:
                                            //                   '${snapshot1.data.schoolName}',
                                            //               fSize: _height * 0.02);
                                            //         }),
                                            // Helper.text(
                                            //     value: 'School Name',
                                            //     fSize: _height * 0.02),
                                            // Helper.text(
                                            //     value: 'Grade',
                                            //     fSize: _height * 0.02)
                                          ],
                                        ),
                                        children: <Widget>[
                                          Divider(
                                            thickness: 1.0,
                                            height: 1.0,
                                          ),
                                          TileBottomBar(
                                              height: _height,
                                              parent: parent,
                                              index: index)
                                        ],
                                      ),
                                    ),
                                  ]);
                            }),
                          ),
                        );
                      } else {
                        return Padding(
                          padding:
                              EdgeInsets.fromLTRB(25, _height * 0.05, 25, 0),
                          child: Text('checking data'),
                        );
                      }
                    }),
              ],
            ),
          ),
        ),
        Helper.myHeader(text: 'HOME', height: _height),
      ],
    );
  }

  Widget TileBottomBar({double height, AccountProvider parent, int index}) {
    return ButtonBar(
      alignment: MainAxisAlignment.spaceAround,
      buttonHeight: 52.0,
      buttonMinWidth: 90.0,
      children: <Widget>[
        FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0)),
            onPressed: () {
              parent.studentUpdate(valueAt: index,attendance: true);
              Navigator.pushReplacement(
                  context,
                  AnimatedPageRoute(
                      widget: BottomBarNavigationPatternExample(
                    screenIndex: 2,
                  )));
              //  cardB.currentState?.expand();
            },
            child: ButtonCol(
                image: 'assets/attendance.png',
                text: 'Attendance',
                height: height)),
        FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
          onPressed: () {
            // cardB.currentState?.collapse();
          },
          child: ButtonCol(
              image: 'assets/assignment.png',
              text: 'Assignment',
              height: height),
        ),
        FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
          onPressed: () {
            parent.studentUpdate(valueAt: index);
            Navigator.pushReplacement(
                context,
                AnimatedPageRoute(
                    widget: BottomBarNavigationPatternExample(
                  screenIndex: 1,
                )));
            // cardB.currentState?.toggleExpansion();
          },
          child: ButtonCol(
              image: 'assets/transcript.png',
              text: 'Transcript',
              height: height),
        ),
      ],
    );
  }

  Widget ButtonCol({String image, String text, double height}) {
    return Column(
      children: <Widget>[
        //Icon(Icons.arrow_downward),
        Image.asset(
          image,
          width: text == 'Attendance' ? 42.0 : 35.0,
          //  height: 40.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
        ),
        Helper.text(
            value: text,
            fWeight: FontWeight.bold,
            fSize: height * 0.014,
            fColor: Colors.black54),
      ],
    );
  }

  Widget myAppBar(_height, _width, {UserProvider user}) {
    return AppBar(
      backgroundColor: Colors.transparent,
      // leading: Padding(
      //     padding: EdgeInsets.only(bottom: 50.0),
      //     child: Icon(Icons.menu_rounded)),
     titleSpacing: _height*0.03,
      title: Padding(
        padding: EdgeInsets.only(bottom: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Helper.text(
                value: 'Welcome',
                fWeight: FontWeight.w300,
                fSize: _height * 0.018,
                fColor: Colors.white),
            Text('${user.parentData == null ? '' : user.parentData.displayAs}')
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
          padding: EdgeInsets.only(right: 10.0, bottom: 50.0),
          child: CircleAvatar(
            radius: _height * 0.038,
            backgroundColor: CustomColors.darkGreenColor,
            child: GestureDetector(
              key: btnKey,
              onTapUp: (TapUpDetails details) {
                onShow(
                    height: _height,
                    width: _width,
                    offset: details.globalPosition);
              },
              child: CircleAvatar(
                radius: _height * 0.034,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  color: CustomColors.darkGreenColor,
                  size: _height * 0.04,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  GlobalKey btnKey = GlobalKey();
  void stateChanged(bool isShow) {
    // print('menu is ${ isShow ? 'showing': 'closed' }');
  }
  onShow({double width, double height, Offset offset}) {
    PopupMenu menu = PopupMenu(
        backgroundColor: CustomColors.darkBackgroundColor,
        // lineColor: Colors.tealAccent,
        // maxColumn: 2,
        items: [
          MenuItem(
              title: 'Sign out',
              textStyle:
                  TextStyle(fontSize: height * 0.015, color: Colors.white),
              image: Icon(
                Icons.logout,
                color: Colors.white,
              )),
          MenuItem(
              title: 'Profile',
              textStyle:
                  TextStyle(fontSize: height * 0.015, color: Colors.white),
              image: Icon(
                Icons.person,
                color: Colors.white,
              )),
        ],
        onClickMenu: onClickMenu,
        stateChanged: stateChanged,
        onDismiss: onDismiss);

    menu.show(widgetKey: btnKey, rect: Rect.fromPoints(offset, offset));
  }

  void onClickMenu(MenuItemProvider item) async {
    if (item.menuTitle == 'Sign out') {
      Auth().signOut(context: context);
    }
  }

  void onDismiss() {}
}
