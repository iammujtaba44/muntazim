import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:muntazim/core/plugins.dart';
import 'package:muntazim/core/services/models/SchoolModel.dart';
import 'package:muntazim/core/services/models/SchoolYearsModel.dart';
import 'package:muntazim/core/services/models/studentModel/StudentModel.dart';
//import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ExpansionTileCardState> stCard = new GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DrawerService _drawerService;

  bool isDrawerOpen = false;
  StreamController _drawerController = StreamController<bool>.broadcast();

  @override
  void initState() {
    super.initState();
    _drawerController.add(false);
    _drawerService = Provider.of(context, listen: false);
    _listenDrawerService();
    Future.delayed(Duration(milliseconds: 200), () {
      _drawerController.sink.add(true);
    });

    // DatabaseServices().test();
  }

  // RefreshController _refreshController =
  //     RefreshController(initialRefresh: false);

  // void _onRefresh() async {
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   _refreshController.refreshCompleted();
  //   setState(() {});
  // }

  // void _onLoading() async {
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   if (mounted) setState(() {});
  //   _refreshController.loadComplete();
  // }

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
    PopupMenu.context = context;
    var parent = Provider.of<AccountProvider>(context);
    var user = Provider.of<UserProvider>(context);
    return RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        //  enablePullDown: true,
        //  enablePullUp: false,
        //  header: WaterDropMaterialHeader(backgroundColor: CustomColors.darkBackgroundColor,color: CustomColors.buttonDarkBlueColor,distance: _height*0.14,),
        // footer: CustomFooter(
        //   builder: (BuildContext context,LoadStatus mode){
        //     Widget body ;
        //     if(mode==LoadStatus.idle){
        //       body =  Text("pull up load");
        //     }
        //     else if(mode==LoadStatus.loading){
        //       body =  CupertinoActivityIndicator();
        //     }
        //     else if(mode == LoadStatus.failed){
        //       body = Text("Load Failed!Click retry!");
        //     }
        //     else if(mode == LoadStatus.canLoading){
        //       body = Text("release to load more");
        //     }
        //     else{
        //       body = Text("No more Data");
        //     }
        //     return Container(
        //       height: 55.0,
        //       child: Center(child:body),
        //     );
        //   },
        // ),
        //  controller: _refreshController,
        //  onRefresh: _onRefresh,
        // onLoading: _onLoading,
        child: Stack(
          children: [
            Scaffold(
              key: _scaffoldKey,
              drawer: DrawerView(),
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
                              child: Helper.CIndicator(),
                            );
                          }
                          AccountModel data = snapshot.data;
                          if (data.students != null) {
                            return Padding(
                              padding: EdgeInsets.fromLTRB(
                                  25, _height * 0.05, 25, 0),
                              child: Column(
                                children: List.generate(data.students.length,
                                    (index) {
                                  return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: _height * 0.01),
                                          child: ExpansionTileCard(
                                            //key: stCard,
                                            animateTrailing: true,
                                            shadowColor:
                                                CustomColors.darkGreenColor,
                                            duration:
                                                Duration(milliseconds: 500),
                                            elevation: 2.0,
                                            elevationCurve: Curves.bounceOut,
                                            heightFactorCurve: Curves.easeInOut,
                                            contentPadding:
                                                EdgeInsets.all(10.0),

                                            leading: StreamBuilder<
                                                    StudentModel>(
                                                stream: parent.studentStream(
                                                    stId: data.students.keys
                                                        .elementAt(index)),
                                                builder: (_, photo) {
                                                  if (!photo.hasData) {
                                                    return CircleAvatar(
                                                      radius: 30,
                                                      backgroundColor:
                                                          CustomColors
                                                              .lightGreenColor,
                                                      child: Icon(
                                                        Icons.person,
                                                        size: 30,
                                                        color: Colors.white,
                                                      ),
                                                    );
                                                  }
                                                  return CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    fadeInCurve:
                                                        Curves.easeInCirc,
                                                    imageUrl: photo.data.photo,
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        CircleAvatar(
                                                            radius: 30,
                                                            backgroundImage:
                                                                imageProvider),
                                                    placeholder: (context,
                                                            url) =>
                                                        CircleAvatar(
                                                            radius: 30,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            child: Helper
                                                                .CIndicator()),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        Image.asset(
                                                            'assets/user_avatar.png'),
                                                  );
                                                }),
                                            title: Helper.text(
                                                value:
                                                    '${data.students.values.elementAt(index)}',
                                                fSize: _height * 0.025),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                StreamBuilder<StudentModel>(
                                                    stream:
                                                        parent.studentStream(
                                                            stId: data
                                                                .students.keys
                                                                .elementAt(
                                                                    index)),
                                                    builder: (_, student) {
                                                      if (!student.hasData) {
                                                        return Helper.text(
                                                            value:
                                                                '... .. ... .',
                                                            fSize:
                                                                _height * 0.02);
                                                      }

                                                      return Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children:
                                                              List.generate(
                                                                  student
                                                                      .data
                                                                      .schools
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
                                                                builder: (_,
                                                                    school) {
                                                                  if (!school
                                                                      .hasData) {
                                                                    return Helper.text(
                                                                        value:
                                                                            '... .. ... .',
                                                                        fSize: _height *
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
                                                                                0.02,
                                                                            fColor:
                                                                                CustomColors.darkBackgroundColor),
                                                                        Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: List.generate(student.data.schools.values.elementAt(sdIndex).schoolYears.length, (schoolYearIndex) {
                                                                              return StreamBuilder<SchoolYearsModel>(
                                                                                  stream: parent.schoolYearStream(schoolYearId: student.data.schools.values.elementAt(sdIndex).schoolYears.keys.elementAt(schoolYearIndex)),
                                                                                  builder: (_, schoolYear) {
                                                                                    if (!schoolYear.hasData) {
                                                                                      return Center();
                                                                                      //  return Helper.text(value: '... .. ... .', fSize: _height * 0.017);
                                                                                    } else if (schoolYear.data == null) {
                                                                                      return Center();
                                                                                    } else {
                                                                                      return Helper.text(value: schoolYear.data.schoolYear, fSize: _height * 0.017, fColor: CustomColors.buttonDarkBlueColor);
                                                                                    }
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
                              padding: EdgeInsets.fromLTRB(
                                  25, _height * 0.05, 25, 0),
                              child: Text('checking data'),
                            );
                          }
                        }),
                  ],
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
                        text: 'HOME',
                        height: _height,
                        isDrawerOpen: this.isDrawerOpen,
                        onTap: () {
                          _scaffoldKey.currentState.openDrawer();
                        });
                  }
                })
          ],
        ));
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
              parent.studentUpdate(valueAt: index, attendance: true);
              Navigator.push(
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
            parent.studentUpdate(valueAt: index, assignment: true);
            Navigator.push(
                context,
                AnimatedPageRoute(
                    widget: BottomBarNavigationPatternExample(
                  screenIndex: 3,
                )));
            //  cardB.currentState?.expand();
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
            Navigator.push(
                context,
                AnimatedPageRoute(
                    widget: BottomBarNavigationPatternExample(
                  screenIndex: 1,
                )));
            // cardB.currentState?.toggleExpansion();
          },
          child: ButtonCol(
              image: 'assets/transcript.png',
              text: 'Report Card',
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
      automaticallyImplyLeading: false,
      titleSpacing: _height * 0.03,
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
                // onShow(
                //     height: _height,
                //     width: _width,
                //     offset: details.globalPosition);
              },
              child: CircleAvatar(
                radius: _height * 0.034,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage('assets/user_avatar.png'),
                // child: Icon(
                //   Icons.person,
                //   color: CustomColors.darkGreenColor,
                //   size: _height * 0.04,
                // ),
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
          // MenuItem(
          //     title: 'Profile',
          //     textStyle:
          //         TextStyle(fontSize: height * 0.015, color: Colors.white),
          //     image: Icon(
          //       Icons.person,
          //       color: Colors.white,
          //     )),
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

class GetNetworkImage extends StatefulWidget {
  const GetNetworkImage({
    Key key,
    @required this.uRL,
    @required double height,
  })  : _height = height,
        super(key: key);

  final String uRL;
  final double _height;

  @override
  _GetNetworkImageState createState() => _GetNetworkImageState();
}

class _GetNetworkImageState extends State<GetNetworkImage> {
  Map<String, String> headers = Map();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      fadeInCurve: Curves.easeInCirc,
      imageUrl: widget.uRL,
      imageBuilder: (context, imageProvider) =>
          CircleAvatar(backgroundImage: imageProvider),
      placeholder: (context, url) => CircleAvatar(
          backgroundColor: Colors.transparent, child: Helper.CIndicator()),
      errorWidget: (context, url, error) => Icon(
        Icons.error,
        size: 40,
      ),
    );
  }
}
