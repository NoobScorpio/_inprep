import 'package:InPrep/utils/constants.dart';
import 'package:flutter/material.dart';

class SelectCategoryScreen extends StatefulWidget {
  @override
  _SelectCategoryScreenState createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
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
          "Select Category",
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
          ListView.builder(
            itemCount: catList.length,
            itemBuilder: (context, index) {
              if (index == 0)
                return Container();
              else {
                var subCatValue = subs[catList[index]][0];
                return Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                iconsOptions[index - 1],
                                size: 35,
                                color: Theme.of(context).primaryColor,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                catList[index],
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),

                            // dropdown below..
                            child: DropdownButton<String>(
                              icon: Icon(
                                Icons.arrow_drop_down,
                              ),
                              // iconSize: 42,
                              value: subCatValue,
                              // underline: SizedBox(),
                              items: subs[catList[index]].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Container(
                                      width: 150, child: new Text('$value')),
                                );
                              }).toList(),
                              onChanged: (_) {
                                Navigator.pop(context, "${catList[index]}, $_");
                              },
                            ),
                          ),
                        ]),
                    Divider()
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
