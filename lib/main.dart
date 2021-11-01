import 'package:muntazim/core/plugins.dart';
import 'package:muntazim/core/services/public_service.dart';

import 'package:provider/single_child_widget.dart';

// void main() {
//   runApp(MyApp());
// }
List<SingleChildWidget> providers = [
  ChangeNotifierProvider<AccountProvider>(create: (_) => AccountProvider()),
  ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
  Provider(create: (_) => DrawerService()),
  ChangeNotifierProvider<PublicService>(create: (_) => PublicService()),
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
