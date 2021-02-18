import 'package:muntazim/core/plugins.dart';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool isLoggingIn = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  AnimationController _animationController;
  Animation<double> animation;

  bool visibility = true;

  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(seconds: 5), vsync: this);

    final curvedAnimation = CurvedAnimation(
        parent: _animationController,
        curve: Curves.bounceIn,
        reverseCurve: Curves.easeOut);
    animation =
        Tween<double>(begin: 0, end: 2 * math.pi).animate(curvedAnimation)
          ..addListener(() {
            if (mounted) {
              setState(() {});
            }
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _animationController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              _animationController.forward();
            }
          });
    _animationController.forward();
  }

  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final node = FocusScope.of(context);
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          height: height,
          decoration: BoxDecoration(
              color: CustomColors.darkBackgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(top: height * 0.2, bottom: height * 0.1),
                  child: buildLogo(),
                ),
                buildForm(context, node: node)
              ],
            ),
          ),
        ));
  }

  Widget buildLogo() {
    return Container(
      padding: EdgeInsets.all(30),
      height: 150,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                CustomColors.buttonLightBlueColor,
                CustomColors.buttonDarkBlueColor
              ]),
          shape: BoxShape.circle,
          color: CustomColors.lightGreenColor),
      alignment: Alignment.center,
      child: Image.asset(
        'assets/Logo_Muntazim_Color.png',
        height: 45,
      ),
    );
  }

  Widget buildForm(BuildContext context, {final node}) {
    return Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              TextFormField(
                onEditingComplete: () => node.nextFocus(),
                controller: _emailController,
                validator: (value) {
                  if (value.isEmpty) return 'Please enter some text';
                  return null;
                },
                style: TextStyle(color: Colors.grey, fontSize: 18.0),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: Colors.white60,
                    size: 25.0,
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  hintText: "Username",
                  hintStyle: TextStyle(color: Colors.white60, fontSize: 18.0),
                  fillColor: Colors.grey,
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                onFieldSubmitted: (_) => node.unfocus(),
                controller: _passwordController,
                validator: (value) {
                  if (value.isEmpty) return 'Please enter some text';
                  return null;
                },
                //initialValue: "password",
                obscureText: visibility,
                style: TextStyle(color: Colors.grey, fontSize: 18.0),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: visibility
                        ? Icon(
                            Icons.visibility,
                            color: Colors.white60,
                          )
                        : Icon(
                            Icons.visibility_off_rounded,
                            color: Colors.blue,
                          ),
                    onPressed: visibilePassword,
                  ),
                  prefixIcon: Icon(
                    Icons.lock_rounded,
                    color: Colors.white60,
                    size: 25.0,
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  hintText: "Password",
                  hintStyle: TextStyle(color: Colors.white60, fontSize: 18.0),
                  fillColor: Colors.grey,
                ),
              ),
              SizedBox(height: 45),
              Row(
                children: [
                  Expanded(child: submitButton()),
                ],
              ),
            ],
          ),
        ));
  }

  Widget submitButton() {
    return InkWell(
      onTap: () async {
        FocusScope.of(context).requestFocus(new FocusNode());
        if (_formKey.currentState.validate()) {
          setState(() {
            isLoggingIn = true;
          });
          // _signInWithEmailAndPassword(context);
          Auth auth = Auth();
          if (isLoggingIn) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => BottomBarNavigationPatternExample(
                      screenIndex: 0,
                    )));
            // ResponseState state = await auth.login(
            //     username: _emailController.text.trim(),
            //     password: _passwordController.text.trim());
            // if (state is ListError) {
            //   setState(() {
            //     isLoggingIn = false;
            //   });
            //   final error = state.error;
            //   String message = '${error.message}';
            //   _scaffoldKey.currentState
            //       .showSnackBar(Helper.sBar(text: message));
            // } else if (state is LoadedState) {
            //   Navigator.pushReplacement(
            //       context,
            //       MaterialPageRoute(
            //           builder: (_) => BottomBarNavigationPatternExample(
            //                 screenIndex: 0,
            //               )));
            // }
          }
        }
      },
      child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: !isLoggingIn
                      ? [
                          CustomColors.buttonLightBlueColor,
                          CustomColors.buttonDarkBlueColor
                        ]
                      : [
                          // CustomColors.darkBackgroundColor,
                          CustomColors.textBorderColor,
                          CustomColors.textBorderColor
                        ])),
          child: !isLoggingIn
              ? const Text('SIGN IN',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.white))
              : CircularProgressIndicator(
                  backgroundColor: CustomColors.darkBackgroundColor,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      CustomColors.buttonDarkBlueColor),
                )
          // : const Text('Signing In..',
          //     textAlign: TextAlign.center,
          //     style: TextStyle(fontSize: 20, color: Colors.white)),
          ),
    );
  }

  visibilePassword() {
    setState(() {
      //  FocusScope.of(context).requestFocus(new FocusNode());
      if (visibility)
        visibility = false;
      else
        visibility = true;
    });
  }
}
