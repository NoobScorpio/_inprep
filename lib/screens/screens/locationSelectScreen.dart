import 'package:InPrep/utils/loader_notifications.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';

class LocationSelectScreen extends StatefulWidget {
  @override
  _LocationSelectScreenState createState() => _LocationSelectScreenState();
}

class _LocationSelectScreenState extends State<LocationSelectScreen> {
  String country = "", state = "", city = "";
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   Future.delayed(Duration(milliseconds: 2000), () {
    //     setState(() {
    //       isLoading = false;
    //     });
    //   });
    // });
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context, null);
            },
            child: Icon(
              Icons.cancel_outlined,
              color: Colors.white,
            ),
          ),
          title: Text(
            "Select Location",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            CircleAvatar(
              radius: 35,
              backgroundImage: AssetImage('assets/icons/logo1024.png'),
            ),
          ],
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: CSCPicker(
                showStates: true,
                showCities: true,
                flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
                layout: Layout.vertical,

                dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300, width: 1)),

                ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                disabledDropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Colors.grey.shade300,
                    border: Border.all(color: Colors.grey.shade300, width: 1)),

                ///selected item style [OPTIONAL PARAMETER]
                selectedItemStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),

                ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                dropdownHeadingStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),

                ///DropdownDialog Item style [OPTIONAL PARAMETER]
                dropdownItemStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),

                ///Dialog box radius [OPTIONAL PARAMETER]
                dropdownDialogRadius: 10.0,

                ///Search bar radius [OPTIONAL PARAMETER]
                searchBarRadius: 10.0,

                ///Default Country [OPTIONAL PARAMETER]
                defaultCountry: DefaultCountry.United_States,

                ///triggers once country selected in dropdown
                onCountryChanged: (value) {
                  setState(() {
                    ///store value in country variable
                    country = value;
                    state = "";
                    city = "";
                    // print("$countryText");
                  });
                },

                ///triggers once state selected in dropdown
                onStateChanged: (value) {
                  setState(() {
                    ///store value in state variable
                    state = value;
                    city = "";
                    // print("$stateText");
                  });
                },

                ///triggers once city selected in dropdown
                onCityChanged: (value) {
                  setState(() {
                    ///store value in city variable
                    city = value;

                    // print("$cityText");
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                  onPressed: () {
                    print("$country $state $city");
                    if ((state == "" || state == null) ||
                        (city == "" || city == null) ||
                        (country == "" || country == null))
                      showToast(context, "Please select all options");
                    else
                      Navigator.pop(context,
                          {"country": country, "state": state, "city": city});
                  },
                  child: Text("Confirm")),
            )
          ],
        ),
      ),
    );
  }
}
