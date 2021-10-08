import 'package:flutter/material.dart';

class PushNotiSettings extends StatefulWidget {
  static String id = 'PushNotiSettings';
  @override
  _PushNotiSettingsState createState() => _PushNotiSettingsState();
}

class _PushNotiSettingsState extends State<PushNotiSettings> {
  List<bool> isSelectedInbox = [true, false];
  List<bool> isSelectedMeet = [true, false];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'Inbox Message',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ToggleButtons(
                      borderWidth: 0,
                      selectedBorderColor: Theme.of(context).primaryColor,
                      selectedColor: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(5),
                      children: <Widget>[
                        Icon(Icons.close),
                        Icon(Icons.check),
                      ],
                      onPressed: (i) {
                        setState(() {
                          isSelectedInbox[0] = !isSelectedInbox[0];
                          isSelectedInbox[1] = !isSelectedInbox[1];
                        });
                      },
                      isSelected: isSelectedInbox,
                    ),
                  ),
                ],
              ),
              Divider(
                height: 20,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'Meeting',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ToggleButtons(
                      borderWidth: 0,
                      selectedBorderColor: Theme.of(context).primaryColor,
                      selectedColor: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(5),
                      children: <Widget>[
                        Icon(Icons.close),
                        Icon(Icons.check),
                      ],
                      onPressed: (i) {
                        setState(() {
                          isSelectedMeet[0] = !isSelectedMeet[0];
                          isSelectedMeet[1] = !isSelectedMeet[1];
                        });
                      },
                      isSelected: isSelectedMeet,
                    ),
                  ),
                ],
              ),
              Divider(
                height: 20,
              ),
            ],
          ),
          Center(
            child: Container(
              height: 50,
              color: Colors.black12,
              child: FlatButton(
                onPressed: () {
                  // print('yes');
                },
                child: Text(
                  'Test Push Notification',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
