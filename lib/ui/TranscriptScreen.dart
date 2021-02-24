import 'package:muntazim/core/plugins.dart';
import 'package:muntazim/core/services/models/ReportCardModel.dart';
import 'package:muntazim/core/services/models/studentModel/StudentModel.dart';

class TranscriptScreen extends StatefulWidget {
  @override
  _TranscriptScreenState createState() => _TranscriptScreenState();
}

class _TranscriptScreenState extends State<TranscriptScreen> {
  final GlobalKey<ExpansionTileCardState> stCard = new GlobalKey();

  // Map<String, String> _map = {
  //   'Chemistry': '90',
  //   'Biology': '95',
  //   'Math': '100',
  //   'English': '80',
  //   'Sindhi': '80'
  // };
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;

  String student = '';

  var school;

  var sessionId;

  var programId;
  void initState() {
    var parent = Provider.of<AccountProvider>(context, listen: false);
    super.initState();

    student = parent.studentName;
    this.sessionId = parent.sessionId;
    this.school = parent.schoolId;
    this.programId = parent.programId;
    // parent.getSchools();

    // parent.reportCardStream(subjectId: '53').listen((event) {});
    controller.addListener(() {
      double value = controller.offset / 119;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    var parent = Provider.of<AccountProvider>(context);
    Provider.of<AccountProvider>(context).userStream.listen((event) {});
    // print(parent.studentId);

    return Stack(
      children: [
        Scaffold(
          appBar: myAppBar(_height, parent: parent),
          backgroundColor: CustomColors.lightBackgroundColor,
          body: ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(25, _height * 0.01, 25, 0),
                padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                color: Colors.white,
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
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                            hint: Text('Select School'),
                            onChanged: (String newValue) {
                              print(newValue);
                              setState(() {
                                school = newValue;
                                //  _getCitiesList();

                                print(school);
                              });
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
                margin: EdgeInsets.fromLTRB(25, _height * 0.01, 25, 0),
                padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                color: Colors.white,
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
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                            hint: Text('Select Session'),
                            onChanged: (String newValue) {
                              setState(() {
                                sessionId = newValue;

                                print(sessionId);
                              });
                              parent.getPrograms(
                                  schoolId: this.school, sessionId: sessionId);
                            },
                            items: parent.schoolYearList?.map((item) {
                                  return new DropdownMenuItem(
                                    child: new Text(item['school_year']),
                                    value: item['school_session_id'].toString(),
                                  );
                                })?.toList() ??
                                [],
                          ),
                        ),
                      ),
                    ),
                    // Expanded(
                    //   child: DropdownButtonHideUnderline(
                    //     child: ButtonTheme(
                    //       alignedDropdown: true,
                    //       child: DropdownButton<String>(
                    //         value: school,
                    //         iconSize: 30,
                    //         icon: (null),
                    //         style: TextStyle(
                    //           color: Colors.black54,
                    //           fontSize: 16,
                    //         ),
                    //         hint: Text('Select Program'),
                    //         onChanged: (String newValue) {
                    //           setState(() {
                    //             // _myState = newValue;
                    //             // _getCitiesList();
                    //             // print(_myState);
                    //           });
                    //         },
                    //         items: statesList?.map((item) {
                    //               return new DropdownMenuItem(
                    //                 child: new Text(item['name']),
                    //                 value: item['id'].toString(),
                    //               );
                    //             })?.toList() ??
                    //             [],
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(25, _height * 0.01, 25, 0),
                padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                color: Colors.white,
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
                              color: Colors.black54,
                              fontSize: 16,
                            ),
                            hint: Text('Select Session'),
                            onChanged: (String newValue) {
                              setState(() {
                                programId = newValue;

                                print(programId);
                              });
                              parent.getsubjects(
                                  schoolId: this.school,
                                  sessionId: this.sessionId,
                                  programId: programId);
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
              ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  controller: controller,
                  itemCount: parent.studentSubjects.length,
                  itemBuilder: (context, index) {
                    double scale = 1.0;
                    if (topContainer > 0.5) {
                      scale = index + 0.5 - topContainer;
                      if (scale < 0) {
                        scale = 0;
                      } else if (scale > 1) {
                        scale = 1;
                      }
                    }
                    return Opacity(
                      opacity: scale,
                      child: Transform(
                        transform: Matrix4.identity()..scale(scale, scale),
                        alignment: Alignment.topCenter,
                        child: getTileCard(_height,
                            parent: parent,
                            subjectId:
                                parent.studentSubjects.keys.elementAt(index),
                            subjectName:
                                '${parent.studentSubjects.values.elementAt(index)}',
                            totalMarks: '10',
                            reportCardDocId: '${sessionId}_$programId'),
                      ),
                    );
                  })
            ],
          ),

          // body: SingleChildScrollView(
          //   physics: BouncingScrollPhysics(),
          //   child: Column(
          //     //mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       getTileCard(_height, subjectName: 'Chemistry', totalMarks: 90),
          //       getTileCard(_height, subjectName: 'Biology', totalMarks: 95),
          //       getTileCard(_height,
          //           subjectName: 'Mathematics', totalMarks: 100)
          //     ],
          //   ),
          // ),
        ),
        Helper.myAlign(text: 'TRANSCRIPT', height: _height),
      ],
    );
  }

  Widget getTileCard(double _height,
      {dynamic subjectName,
      dynamic subjectId,
      dynamic totalMarks,
      dynamic reportCardDocId,
      AccountProvider parent}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(25, _height * 0.01, 25, 0),
      child: ExpansionTileCard(
        // key: stCard,
        animateTrailing: true,
        shadowColor: CustomColors.darkGreenColor,
        duration: Duration(seconds: 1),
        elevation: 2.0,

        elevationCurve: Curves.bounceOut,
        heightFactorCurve: Curves.easeInOut,
        contentPadding: EdgeInsets.all(7.0),
        leading: CircleAvatar(
          radius: _height * 0.035,
          backgroundColor: Colors.black,
          child: CircleAvatar(
            radius: _height * 0.032,
            backgroundColor: Colors.white,
          ),
        ),
        title: Row(
          children: [
            Text(
              subjectName,
              style: TextStyle(
                  fontSize: _height * 0.028,
                  color: CustomColors.darkGreenColor),
            ),
            Spacer(),
            Helper.text(
                value: '$totalMarks',
                fSize: _height * 0.027,
                fWeight: FontWeight.w400),
            Helper.text(value: '/', fSize: 17.0),
            Helper.text(value: '100', fSize: _height * 0.017),
          ],
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 2.0),
          child: Row(
            children: [
              Helper.text(value: 'Semester 1', fSize: _height * 0.022),
              Spacer(
                flex: 3,
              ),
              Helper.text(
                  value: 'A', fSize: _height * 0.028, fWeight: FontWeight.bold),
              Spacer()
            ],
          ),
        ),

        trailing: Padding(
            padding: EdgeInsets.only(top: 40.0),
            child: Icon(Icons.keyboard_arrow_down_outlined)),
        // trailing: SizedBox(
        //   child: Column(
        //     children: [
        //       Wrap(
        //         children: [
        //           Helper.text(
        //               value: '90',
        //               fSize: 25.0,
        //               fWeight: FontWeight.bold),
        //           Helper.text(value: '/', fSize: 16.0),
        //           Helper.text(value: '100', fSize: 16.0),
        //         ],
        //       ),
        //       Helper.text(
        //           value: 'A', fSize: 20.0, fWeight: FontWeight.bold),
        //     ],
        //   ),
        // ),
        children: <Widget>[
          getUpperRow(
            text1: 'Session',
            text2: 'Grade',
            text3: 'Score',
            cInd: 0,
          ),
          Divider(
            thickness: 1.0,
            height: 1.0,
            color: Colors.grey,
          ),
          StreamBuilder<ReportCardModel>(
              stream: parent.reportCardStream(
                  subjectId: subjectId, docId: reportCardDocId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return getUpperRow(
                      text1: '.. ..',
                      text2: '..',
                      text3: '.. .',
                      cInd: 1,
                      bottom: false);
                }

                return Container(
                  // height: _height * 0.1,
                  child: SingleChildScrollView(
                      child: Column(
                          children: List.generate(snapshot.data.duration.length,
                              (index) {
                    if (index < snapshot.data.duration.length - 1) {
                      return getUpperRow(
                        text1: '${snapshot.data.duration[index].durationTitle}',
                        text2: snapshot
                            .data.duration[index].grading.percentageGrade.grade,
                        text3:
                            '${snapshot.data.duration[index].grading.percentageGrade.percentage}%',
                        cInd: 1,
                      );
                    } else {
                      return getUpperRow(
                          text1:
                              '${snapshot.data.duration[index].durationTitle}',
                          text2:
                              '${snapshot.data.duration[index].grading.percentageGrade.grade}',
                          text3:
                              '${snapshot.data.duration[index].grading.percentageGrade.percentage}%',
                          cInd: 1,
                          bottom: false);
                    }
                  }))),
                );
              }),
          // getUpperRow(
          //   text1: 'Quarter 1',
          //   text2: 'A',
          //   text3: '92/100',
          //   cInd: 1,
          // ),
          // getUpperRow(
          //     text1: 'Quarter 2',
          //     text2: 'A',
          //     text3: '89/100',
          //     cInd: 1,
          //     bottom: false),
        ],
      ),
    );
  }

  Widget getUpperRow(
      {dynamic text1,
      dynamic text2,
      dynamic text3,
      int cInd,
      bool bottom = true,
      bool top = false}) {
    return Padding(
      padding:
          EdgeInsets.fromLTRB(15.0, top ? 0 : 8.0, 15.0, bottom ? 0 : 30.0),
      child: Row(
        children: [
          Helper.text(
              value: text1,
              fSize: 16.0,
              fWeight: FontWeight.w400,
              fColor: cInd == 0 ? CustomColors.darkGreenColor : Colors.grey),
          Spacer(
            flex: 4,
          ),
          Helper.text(
              value: text2,
              fSize: 16.0,
              fWeight: cInd == 0 ? FontWeight.w400 : FontWeight.bold,
              fColor: cInd == 0 ? CustomColors.darkGreenColor : Colors.grey),
          Spacer(),
          Helper.text(
              value: text3,
              fSize: 16.0,
              fWeight: FontWeight.w400,
              fColor: cInd == 0 ? CustomColors.darkGreenColor : Colors.grey),
        ],
      ),
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
              Text('Current Score',
                  style:
                      TextStyle(fontWeight: FontWeight.w400, fontSize: 20.0)),
              Text('84.50%',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
              Row(
                children: [
                  Text('Grade  ',
                      style: TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 15.0)),
                  Text('A',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0)),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
