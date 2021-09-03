import 'package:InPrep/screens/search_screen.dart';
import 'package:InPrep/screens/filterScreen.dart';
import 'package:InPrep/utils/constants.dart';
import 'package:flutter/material.dart';

class SubCatScreen extends StatefulWidget {
  final String category;

  const SubCatScreen({Key key, this.category}) : super(key: key);
  @override
  _SubCatScreenState createState() => _SubCatScreenState();
}

class _SubCatScreenState extends State<SubCatScreen> {
  List<String> strings = [];
  String iconStr = '';
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    strings = subs[widget.category];
    iconStr = icons[widget.category];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          widget.category,
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
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: Image.asset(
                    iconStr,
                    scale: 5,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                    padding: EdgeInsets.only(
                        left: 25.0, right: 25.0, bottom: 30, top: 30),
                    child: Material(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 6,
                        child: Container(
                            height: 60,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AutofillGroup(
                                child: TextField(
                                  autofillHints: [AutofillHints.jobTitle],
                                  controller: controller,
                                  decoration: InputDecoration(
                                    hintText:
                                        'Search in ${widget.category} category',
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.search),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Search(
                                                      loggedIn: true,
                                                      title: widget.category,
                                                      search: controller.text
                                                              .toString() ??
                                                          '',
                                                    )));
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            )))),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Sub categories",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                for (int i = 1; i < strings.length; i++)
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Search(
                                              loggedIn: true,
                                              title: widget.category,
                                              title2: strings[i],
                                              search: null,
                                            )));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 15),
                                  child: Text(
                                    strings[i],
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.navigate_next,
                              color: Colors.black54,
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Divider(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
