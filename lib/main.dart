import 'package:muntazim/core/plugins.dart';

import 'package:provider/single_child_widget.dart';

// void main() {
//   runApp(MyApp());
// }
List<SingleChildWidget> providers = [
  ChangeNotifierProvider<AccountProvider>(create: (_) => AccountProvider()),
  ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
];
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MUNTAZIM',
        theme: ThemeData(
            //backgroundColor: CustomColors.darkBackgroundColor,
            //accentColor: CustomColors.buttonDarkBlueColor,
            primaryColor: CustomColors.darkBackgroundColor),

        //home: BottomBarNavigationPatternExample(),
        //home: AnnouncementsScreen(),
        home: SplashScreenU(),
      ),
    );
  }
}
