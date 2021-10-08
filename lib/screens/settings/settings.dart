import 'package:flutter/material.dart';
import 'package:InPrep/utils/my_pin_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class Settings extends StatefulWidget {
  static String id = 'settings';
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool bioAuth = false;
  bool pinAuth = false;
  bool noti = true;
  bool light = true;
  SharedPreferences preferences;
  final GlobalKey<ScaffoldState> globKey = new GlobalKey<ScaffoldState>();
  void showSnack(text) {
    globKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).primaryColor,
      content: Text(text),
      duration: Duration(seconds: 1),
    ));
  }

  @override
  void initState() {
    super.initState();
  }

  getPref() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      light = preferences.getBool('dark');
    });
  }

  getPinAuth() async {
    preferences = await SharedPreferences.getInstance();
    bool pin = preferences.getBool('pinAuth');
    if (pin == null) {
      preferences.setBool('pinAuth', false);
      setState(() {
        pinAuth = false;
      });
    } else {
      setState(() {
        pinAuth = pin;
      });
    }
  }

  getBioAuth() async {
    preferences = await SharedPreferences.getInstance();

    bool bio = preferences.getBool('bioAuth');
    if (bio == null) {
      preferences.setBool('bioAuth', false);
      setState(() {
        bioAuth = false;
      });
    } else {
      setState(() {
        bioAuth = bio;
      });
    }
  }

  @override
  Widget build(BuildContext c) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getBioAuth();
      getPinAuth();
      getPref();
    });
    return Scaffold(
      key: globKey,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        actions: [
          CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage('assets/icons/logo1024.png'),
          ),
        ],
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.09,
            child: Image.asset(
              "assets/images/bg.jpg",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: [
                  SwitchListTile(
                    activeColor: Theme.of(context).primaryColor,
                    secondary: Icon(Icons.notifications),
                    title: Text('Push Notification'),
                    value: noti,
                    onChanged: (v) async {
                      if (noti) {
                        await preferences.setBool('noti', false);
                        setState(() {
                          noti = false;
                        });
                      } else {
                        await preferences.setBool('noti', true);
                        setState(() {
                          noti = true;
                        });
                      }
                    },
                  ),
                  Divider(
                    height: 1,
                  ),
//          PRIVACY POLICY
                  SwitchListTile(
                    activeColor: Theme.of(context).primaryColor,
                    title: Text('Light/Dark'),
                    secondary: Icon(Icons.lightbulb_outline),
                    value: light,
                    onChanged: (v) async {
                      // showSnack('Availabe in the Next Update');

                      AdaptiveThemeMode theme =
                          await AdaptiveTheme.getThemeMode();
                      if (theme.isDark) {
                        //print("SWITCHING TO LIGHT ");
                        AdaptiveTheme.of(context).setLight();
                        await preferences.setBool('dark', false);
                        setState(() {
                          light = false;
                        });
                      } else {
                        //print("SWITCHING TO DARK ");
                        AdaptiveTheme.of(context).setDark();
                        await preferences.setBool('dark', true);
                        setState(() {
                          light = true;
                        });
                      }
                      //print('DARKMODE IS ${theme.isDark}');
                    },
                  ),
                  Divider(
                    height: 1,
                  ),
                  SwitchListTile(
                    activeColor: Theme.of(context).primaryColor,
                    title: Text('Enable Biometric Authentication'),
                    secondary: Icon(Icons.fingerprint),
                    value: bioAuth,
                    onChanged: (v) async {
                      if (bioAuth) {
                        await preferences.setBool('bioAuth', false);
                        setState(() {
                          bioAuth = false;
                        });
                      } else {
                        await preferences.setBool('bioAuth', true);
                        setState(() {
                          bioAuth = true;
                        });
                      }
                    },
                  ),
                  Divider(
                    height: 1,
                  ),
                  SwitchListTile(
                    activeColor: Theme.of(context).primaryColor,
                    title: Text('Enable Pin Authentication'),
                    secondary: Icon(Icons.keyboard_hide),
                    value: pinAuth,
                    onChanged: (v) async {
                      if (pinAuth) {
                        await preferences.setBool('pinAuth', false);
                        setState(() {
                          pinAuth = false;
                        });
                      } else {
                        bool enable = await showDialog(
                            context: c,
                            builder: (_) {
                              return MyPinDialog();
                            });
                        if (enable) {
                          await preferences.setBool('pinAuth', true);
                          setState(() {
                            pinAuth = true;
                          });
                        }
                      }
                    },
                  ),
                  Divider(
                    height: 1,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text('© InPrep LLC', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     final LocalAuthentication auth = LocalAuthentication();
      //     bool authenticated = false;
      //     bool canCheckBiometrics = false;
      //     bool bioAuth = false;
      //
      //     try {
      //       canCheckBiometrics = await auth.canCheckBiometrics;
      //     } catch (e) {
      //       //print("error biome trics $e");
      //     }
      //
      //     //print("biometric is available: $canCheckBiometrics");
      //     // if (!mounted) return false;
      //     List<BiometricType> availableBiometrics;
      //     try {
      //       availableBiometrics = await auth.getAvailableBiometrics();
      //       //print(availableBiometrics);
      //     } catch (e) {
      //       //print("error enumerate biometrics $e");
      //     }
      //   },
      // ),
    );
  }
}
