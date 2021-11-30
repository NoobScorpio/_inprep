import 'package:InPrep/models/user.dart';
import 'package:InPrep/screens/screens/test.dart';
import 'package:InPrep/user_bloc/userLogInCubit.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:InPrep/auth/auth.dart';
import 'package:InPrep/screens/screens/category_screen.dart';
import 'package:InPrep/screens/chat/chat_screen.dart';
import 'package:InPrep/screens/chat/date_time.dart';
import 'package:InPrep/screens/screens/home.dart';
import 'package:InPrep/screens/screens/intro.dart';
import 'package:InPrep/jobs/job_search.dart';
import 'package:InPrep/screens/chat/chats.dart';
import 'package:InPrep/screens/screens/pre_intro.dart';
import 'package:InPrep/screens/profile_screens/profile.dart';
import 'package:InPrep/screens/profile_screens/profile_setup.dart';
import 'package:InPrep/screens/settings/push_noti_settings.dart';
import 'package:InPrep/screens/screens/search_screen.dart';
import 'package:InPrep/screens/settings/settings.dart';
import 'package:InPrep/screens/screens/signin_signup.dart';
import 'package:InPrep/screens/screens/signin.dart';
import 'package:InPrep/screens/screens/signup.dart';
import 'package:InPrep/screens/screens/welcome.dart';
import 'package:InPrep/utils/test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import 'utils/test.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      // debug: true // optional: set false to disable printing logs to console
      );
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(providers: [
      Provider(
        create: (_) => AuthService(),
      ),
      StreamProvider(
        initialData: MyUser(),
        create: (context) => context.read<AuthService>().onAuthStateChanged,
      ),
    ], child: MyApp()),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  // static bool theme = true;
  static final Map<int, Color> color = {
    50: Color.fromRGBO(139, 0, 0, .1),
    100: Color.fromRGBO(139, 0, 0, .2),
    200: Color.fromRGBO(139, 0, 0, .3),
    300: Color.fromRGBO(139, 0, 0, .4),
    400: Color.fromRGBO(139, 0, 0, .5),
    500: Color.fromRGBO(139, 0, 0, .6),
    600: Color.fromRGBO(139, 0, 0, .7),
    700: Color.fromRGBO(139, 0, 0, .8),
    800: Color.fromRGBO(139, 0, 0, .9),
    900: Color.fromRGBO(139, 0, 0, 1),
  };
  final MaterialColor colorCustom = MaterialColor(0xff8B0000, color);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit(),
      child: AdaptiveTheme(
        light: ThemeData(
          brightness: Brightness.light,
          primarySwatch: colorCustom,
        ),
        dark: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: colorCustom,
          primaryColor: colorCustom,
          primaryColorDark: colorCustom,
          bottomAppBarColor: colorCustom,

          primaryIconTheme: IconThemeData(color: colorCustom),
          toggleButtonsTheme: ToggleButtonsThemeData(color: colorCustom),

          // textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.white70),
        ),
        initial: AdaptiveThemeMode.light,
        builder: (theme, darkTheme) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'InPrep',
          darkTheme: darkTheme,
          theme: theme,
          initialRoute: PreIntro.id,
          routes: {
            Test.id: (_) => Test(),
            CountryCode.id: (_) => CountryCode(),
            CategoryScreen.id: (_) => CategoryScreen(),
            MyDateTime.id: (_) => MyDateTime(),
            SignInUp.id: (_) => SignInUp(),
            SignIn.id: (_) => SignIn(),
            Home.id: (_) => Home(),
            SignUp.id: (_) => SignUp(),
            Profile.id: (_) => Profile(),
            Chats.id: (_) => Chats(),
            // JobsFeed.id: (_) => JobsFeed(),
            ChatScreen.id: (_) => ChatScreen(),
            // JobView.id: (_) => JobView(),
            Settings.id: (_) => Settings(),
            PushNotiSettings.id: (_) => PushNotiSettings(),
            ProfileSetup.id: (_) => ProfileSetup(),
            JobSearch.id: (_) => JobSearch(),
            // JobEdit.id: (_) => JobEdit(),
            Search.id: (_) => Search(),
            IntroScreen.id: (_) => IntroScreen(),
            PreIntro.id: (_) => PreIntro(),
            // MyLocalAuth.id:(_)=>MyLocalAuth(),
            Welcome.id: (_) => Welcome(),
          },
        ),
      ),
    );
  }
}
