import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/user.dart';
import 'package:InPrep/screens/filterSearchScreen.dart';
import 'package:InPrep/screens/locationSelectScreen.dart';
import 'package:InPrep/screens/profile_view.dart';
import 'package:InPrep/screens/selectCategoryScreen.dart';
import 'package:InPrep/utils/constants.dart';
import 'package:InPrep/utils/loader.dart';
import 'package:InPrep/utils/my_button.dart';
import 'package:country_picker/country_picker.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  final bool loggedIn;
  final search;

  const FilterScreen({Key key, this.loggedIn, this.search}) : super(key: key);
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String cityText = "Select",
      countryText = "Select",
      stateText = "Select",
      catValue = 'Select',
      sortValue = "Select",
      subCatReturn = "Select",
      catReturn = "Select";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
        ),
        title: Text(
          "Filters",
          style: TextStyle(color: Colors.white),
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
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView(
              children: [
                Text(
                  'Apply Filters',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 15,
                ),
                //CATEGORY
                InkWell(
                  onTap: () async {
                    String str = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectCategoryScreen()));
                    if (str != null) {
                      setState(() {
                        catValue = str;
                      });
                      catReturn = str.split(",")[0];
                      subCatReturn = str.split(", ")[1];
                    }
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Category',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text('$catValue'),
                        ],
                      ),
                      Icon(Icons.keyboard_arrow_right),
                    ],
                  ),
                ),
                Divider(),
                //SORT
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: DropdownButton<String>(
                      icon: Icon(
                        Icons.arrow_drop_down,
                      ),
                      isExpanded: true, // iconSize: 42,
                      value: sortValue,
                      // underline: SizedBox(),
                      items: ["Select", "A-Z", "Rating"].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(value == 'Select' ? "Sort By" : ""),
                              Text('$value'),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (_) {
                        setState(() {
                          sortValue = _;
                        });
                      },
                    ),
                  ),
                ),
                Divider(),

                Divider(),
                //LOCATION
                Text(
                  'Select Location',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 15,
                ),
                // CSCPicker(
                //   ///Enable disable state dropdown [OPTIONAL PARAMETER]
                //   showStates: true,
                //
                //   /// Enable disable city drop down [OPTIONAL PARAMETER]
                //   showCities: true,
                //
                //   ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                //   flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
                //   layout: Layout.vertical,
                //
                //   ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                //   dropdownDecoration: BoxDecoration(
                //       borderRadius: BorderRadius.all(Radius.circular(30)),
                //       color: Colors.white,
                //       border:
                //           Border.all(color: Colors.grey.shade300, width: 1)),
                //
                //   ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                //   disabledDropdownDecoration: BoxDecoration(
                //       borderRadius: BorderRadius.all(Radius.circular(30)),
                //       color: Colors.grey.shade300,
                //       border:
                //           Border.all(color: Colors.grey.shade300, width: 1)),
                //
                //   ///selected item style [OPTIONAL PARAMETER]
                //   selectedItemStyle: TextStyle(
                //     color: Colors.black,
                //     fontSize: 14,
                //   ),
                //
                //   ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                //   dropdownHeadingStyle: TextStyle(
                //       color: Colors.black,
                //       fontSize: 17,
                //       fontWeight: FontWeight.bold),
                //
                //   ///DropdownDialog Item style [OPTIONAL PARAMETER]
                //   dropdownItemStyle: TextStyle(
                //     color: Colors.black,
                //     fontSize: 14,
                //   ),
                //
                //   ///Dialog box radius [OPTIONAL PARAMETER]
                //   dropdownDialogRadius: 10.0,
                //
                //   ///Search bar radius [OPTIONAL PARAMETER]
                //   searchBarRadius: 10.0,
                //
                //   ///Default Country [OPTIONAL PARAMETER]
                //   defaultCountry: DefaultCountry.United_States,
                //
                //   ///triggers once country selected in dropdown
                //   onCountryChanged: (value) {
                //     setState(() {
                //       ///store value in country variable
                //       countryText = value;
                //       stateText = "Select";
                //       cityText = "Select";
                //       // print("$countryText");
                //     });
                //   },
                //
                //   ///triggers once state selected in dropdown
                //   onStateChanged: (value) {
                //     setState(() {
                //       ///store value in state variable
                //       stateText = value;
                //       cityText = "Select";
                //       // print("$stateText");
                //     });
                //   },
                //
                //   ///triggers once city selected in dropdown
                //   onCityChanged: (value) {
                //     setState(() {
                //       ///store value in city variable
                //       cityText = value;
                //
                //       // print("$cityText");
                //     });
                //   },
                // ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Location",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).primaryColor),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "$countryText, ${stateText ?? ""} ${(cityText != "" && cityText != null && cityText != "Select") ? (", $cityText") : ""} ",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            var location = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => LocationSelectScreen()));
                            if (location != null) {
                              setState(() {
                                countryText = location['country'];
                                stateText = location['state'];
                                cityText = location['city'];
                              });
                            }
                          },
                          child: Text("Select"))
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: ElevatedButton(
                    child: Text('Apply'),
                    onPressed: () async {
                      showLoader(context);
                      List<MyUser> users =
                          await DatabaseService().getAdvancedSearchUser(
                        category: catReturn == "Select" ? null : catReturn,
                        subCategory:
                            subCatReturn == "Select" ? null : subCatReturn,
                        country: countryText == "Select" ? null : countryText,
                        state: stateText == "Select" ? null : stateText,
                        city: cityText == "Select" ? null : cityText,
                      );
                      // print("USERS RETURNED ${users.length}");
                      List<Widget> widgets = sortValue == "Select"
                          ? await getAlphabeticalUsers(users: users)
                          : (sortValue == "Rating"
                              ? await getRatingUsers(users: users)
                              : await getAlphabeticalUsers(users: users));
                      // print("USERS WIDGETS RETURNED ${widgets.length}");
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => FilterSearchScreen(
                                    widgets: widgets,
                                  )));
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<List<Widget>> getRatingUsers({List<MyUser> users}) async {
    Comparator<MyUser> usersComp =
        (a, b) => (a.rating ?? 0).compareTo(b.rating ?? 0);
    users.sort(usersComp);
    List<Widget> widgetMade = [];
    List<Widget> userWidgetsForward = [];
    for (MyUser usr in users) {
      userWidgetsForward.add(GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ProfileView(
                        uid: usr.uid,
                        loggedIn: widget.loggedIn,
                      )));
        },
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 30.0,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Center(
                      child: Text(
                        usr.displayName.substring(0, 1).toUpperCase(),
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 8.0, right: 8.0, left: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          usr.displayName.toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          usr.design == null
                              ? 'No Title'
                              : usr.design.toString().toUpperCase(),
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
    }
    widgetMade = userWidgetsForward.reversed.toList();
    //print('SETTING RATING USERS');
    // print("RATING $widgetMade");
    return (widgetMade == null || widgetMade.length == 0 || widgetMade == [])
        ? noResult
        : widgetMade;
  }

  Future<List<Widget>> getAlphabeticalUsers({users}) async {
    List<Widget> widgetMade = [];
    List<String> chars = [];
    if (users != null && users.length > 0) {
      for (MyUser u in users) {
        if (!chars.contains(u.displayName.toLowerCase()[0])) {
          chars.add(u.displayName.toLowerCase()[0]);
        }
      }
      //print('CHARATERS $chars');

      int index = 0;
      String firstChar = chars[index];
      for (MyUser user in users) {
        if (user.displayName.toLowerCase()[0] == firstChar) {
          widgetMade.add(Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                // color: Theme.of(context).primaryColor,
                child: CircleAvatar(
                  radius: 20.0,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    firstChar.toUpperCase(),
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
            ),
          ));
          index++;
          if (index < chars.length) {
            firstChar = chars[index];
          } else {
            firstChar = 'COMPLETED';
          }
        }

        widgetMade.add(GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ProfileView(
                          uid: user.uid,
                          loggedIn: widget.loggedIn,
                        )));
          },
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 30.0,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Center(
                        child: Text(
                          user.displayName.substring(0, 1).toUpperCase(),
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, bottom: 8.0, right: 8.0, left: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            user.displayName.toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            user.design == null
                                ? 'No Title'
                                : user.design.toString().toUpperCase(),
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
      }
    }

    return (widgetMade == null || widgetMade.length == 0 || widgetMade == [])
        ? noResult
        : widgetMade;
  }

  List<Widget> noResult = [
    Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          'No consultant found',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
        ),
      ),
    )
  ];
}
