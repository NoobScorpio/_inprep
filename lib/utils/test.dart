import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

class CountryCode extends StatefulWidget {
  static String id = 'cc';
  @override
  _CountryCodeState createState() => _CountryCodeState();
}

class _CountryCodeState extends State<CountryCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Demo for country picker')),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            showCountryPicker(
              context: context,
              //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
              exclude: <String>['KN', 'MF'],
              //Optional. Shows phone code before the country name.
              showPhoneCode: true,
              onSelect: (Country country) {
                var code = country.phoneCode;
                print('Select country: ${country.displayName} $code');
              },
            );
          },
          child: const Text('Show country picker'),
        ),
      ),
    );
  }
}
