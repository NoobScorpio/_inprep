import 'package:InPrep/models/Job.dart';
import 'package:InPrep/models/Skill.dart';
import 'package:InPrep/models/contact.dart';
import 'package:InPrep/models/education.dart';
import 'package:InPrep/models/experience.dart';
import 'package:InPrep/models/portfolio.dart';
import 'package:InPrep/models/review.dart';
import 'package:InPrep/utils/app_utils.dart';
import 'package:InPrep/utils/loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:getflutter/components/rating/gf_rating.dart';
import 'package:url_launcher/url_launcher.dart';

ListTile buildExperienceRow(context,
    {String company, dark, String position, String from, String to}) {
  Color color = dark ? Colors.white : Theme.of(context).primaryColor;
  return ListTile(
    leading: Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 20.0),
      child: Icon(
        Icons.check_circle,
        size: 12.0,
        color: color,
      ),
    ),
    title: Text(
      company,
      style: TextStyle(color: color, fontWeight: FontWeight.bold),
    ),
    subtitle: Text("$position ($from-$to)"),
  );
}

Widget buildReviewRow(context, {dark, Review review}) {
  Color color = dark ? Colors.white : Theme.of(context).primaryColor;
  return ListTile(
    leading: Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 20.0),
      child: Icon(
        Icons.check_circle,
        size: 12.0,
        color: color,
      ),
    ),
    title: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'By ${review.gName}',
          style: TextStyle(
              color: color, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          '${review.body}',
          maxLines: 2,
          style: TextStyle(
            color: color,
          ),
        ),
        RatingBar(
          initialRating: review.stars,
          minRating: 0,
          maxRating: 5.0,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          ignoreGestures: true,
          ratingWidget: RatingWidget(
              half: Icon(
                Icons.star_half,
                color: Colors.amber,
              ),
              full: Icon(
                Icons.star,
                color: Colors.amber,
              ),
              empty: Icon(
                Icons.star_border_outlined,
                color: Colors.amber,
              )),
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          onRatingUpdate: (val) {},
        ),
      ],
    ),
    // subtitle: GFRating(
    //
    //   padding: EdgeInsets.all(0),
    //   margin: EdgeInsets.all(0),
    //   size: 15,
    //   value: review.stars,
    //   onChanged: (val) {},
    // ),
  );
}

ListTile buildEducationRow(context,
    {String institue,
    dark,
    String degree,
    String from,
    String to,
    String country}) {
  Color color = dark ? Colors.white : Theme.of(context).primaryColor;
  return ListTile(
    leading: Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 20.0),
      child: Icon(
        Icons.check_circle,
        size: 12.0,
        color: color,
      ),
    ),
    title: Text(
      '${institue == null ? 'Institute' : institue.toUpperCase()}, ${country == null ? 'Country' : country.toUpperCase()}',
      style: TextStyle(color: color, fontWeight: FontWeight.bold),
    ),
    subtitle: Text("$degree ($from-$to)"),
  );
}

ListTile buildJobsRow(context, {String title, String salary, String location}) {
  return ListTile(
    leading: Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 20.0),
      child: Icon(
        Icons.check_circle,
        size: 12.0,
        color: Theme.of(context).primaryColor,
      ),
    ),
    title: Text(
      title,
      style: TextStyle(
          color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
    ),
    subtitle: Text("Salary from $salary USD ($location)"),
  );
}

ListTile buildSalaryRow(context, {String salary1, String salary2}) {
  return ListTile(
    leading: Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 20.0),
      child: Icon(
        Icons.check_circle,
        size: 12.0,
        color: Theme.of(context).primaryColor,
      ),
    ),
    title: Text(
      'Salary',
      style: TextStyle(
          color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
    ),
    subtitle: Text("From $salary1 to $salary2 USD"),
  );
}

ListTile buildExpRow(context, {String year}) {
  return ListTile(
    leading: Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 20.0),
      child: Icon(
        Icons.check_circle,
        size: 12.0,
        color: Theme.of(context).primaryColor,
      ),
    ),
    title: Text(
      'Experience',
      style: TextStyle(
          color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
    ),
    subtitle: Text(int.parse(year) > 1 ? "$year years" : "$year year"),
  );
}

ListTile buidPortfolioRow(context, dummy, {dark, title, to, from, image}) {
  Color color = dark ? Colors.white : Theme.of(context).primaryColor;
  return ListTile(
    leading: Padding(
      padding: const EdgeInsets.only(top: 5.0, left: 20.0),
      child: Icon(
        Icons.check_circle,
        size: 12.0,
        color: color,
      ),
    ),
    title: Text(
      '$title',
      style: TextStyle(color: color, fontWeight: FontWeight.bold),
    ),
    subtitle: dummy ? Text('') : Text('$from-$to'),
    trailing: image == '' || image == null
        ? Text('')
        : GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        content: Image.network(image),
                      ));
            },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(image), fit: BoxFit.cover),
                border: Border.all(
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              height: 50,
              width: 50,
            ),
          ),
  );
}

ListTile buildLocRow(context, {String city, String country}) {
  return ListTile(
    leading: Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 20.0),
      child: Icon(
        Icons.check_circle,
        size: 12.0,
        color: Theme.of(context).primaryColor,
      ),
    ),
    title: Text(
      'Location',
      style: TextStyle(
          color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
    ),
    subtitle: Text("${city.toUpperCase()}, ${country.toUpperCase()}"),
  );
}

ListTile buildCatRow(context, {String cat}) {
  return ListTile(
    leading: Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 20.0),
      child: Icon(
        Icons.check_circle,
        size: 12.0,
        color: Theme.of(context).primaryColor,
      ),
    ),
    title: Text(
      'Category',
      style: TextStyle(
          color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
    ),
    subtitle: Text("${cat ?? "General"}"),
  );
}

Widget buildSkillRow(String skill, double level) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 5.0),
        Expanded(
            flex: 4,
            child: Text(
              skill.toUpperCase(),
              textAlign: TextAlign.center,
            )),
        SizedBox(width: 10.0),
        Expanded(
          flex: 5,
          child: LinearProgressIndicator(
            value: level,
          ),
        ),
        SizedBox(width: 20.0),
      ],
    ),
  );
}

Row buildSkype({String uname}) {
  return Row(
    children: <Widget>[
      SizedBox(width: 20.0),
      IconButton(
        color: Colors.blue,
        icon: Icon(FontAwesomeIcons.skype),
        onPressed: () {
          _launchURL("zoom:");
        },
      ),
      SizedBox(width: 10.0),
      Text(uname == null ? "Not Added" : '$uname'),
      SizedBox(width: 15.0),
    ],
  );
}

Widget buildTitle(String title, bool dark) {
  return Padding(
    padding: const EdgeInsets.only(left: 16.0, bottom: 10, top: 15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Divider(
          color: dark ? Colors.white38 : Colors.black38,
        ),
      ],
    ),
  );
}

Row buildProfileHeader(context, {name, designation, city, country}) {
  return Row(
    children: <Widget>[
      SizedBox(width: 20.0),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            name == null ? 'Name' : "$name",
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
          ),
          SizedBox(height: 10.0),
          Text("${designation == null ? 'Designation' : designation}"),
          SizedBox(height: 5.0),
          Row(
            children: <Widget>[
              Icon(
                Icons.map,
                size: 12.0,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(width: 10.0),
              Text(
                "${city == null ? 'City' : city}, ${country == null ? 'Country' : country}",
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ],
      )
    ],
  );
}

Widget buildHeader(context,
    {category,
    uid,
    state,
    photoUrl,
    name,
    designation,
    city,
    country,
    dark,
    subCat,
    cover}) {
  List<String> names = name.toString().split(' ');
  // print("BOOLEAN IN PROFILE $dark");
  // print(names.length);
  Color color = dark ? Colors.white : Theme.of(context).primaryColor;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      SizedBox(width: 20.0),
      Stack(
        children: [
          Center(
            child: CachedNetworkImage(
              imageUrl: cover ?? "",
              imageBuilder: (context, image) {
                return Container(
                  height: 125,
                  width: MediaQuery.of(context).size.width - 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.black,
                      image: DecorationImage(
                        image: image,
                        fit: BoxFit.cover,
                      )),
                );
              },
              placeholder: (context, image) {
                return Container(
                  height: 125,
                  width: MediaQuery.of(context).size.width - 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.black,
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.green,
                    ),
                  ),
                );
              },
              errorWidget: (context, image, err) {
                return Container(
                  height: 125,
                  width: MediaQuery.of(context).size.width - 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Theme.of(context).primaryColor,
                      image: DecorationImage(
                        image: AssetImage("assets/icons/logo1024.png"),
                      )),
                );
              },
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.black,
                    border: Border.all(color: Colors.grey),
                    gradient: LinearGradient(
                        colors: [Colors.white, Colors.black],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)),
                child: CachedNetworkImage(
                  imageUrl: photoUrl ?? "",
                  imageBuilder: (context, image) {
                    return Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(360)),
                          image:
                              DecorationImage(image: image, fit: BoxFit.cover)),
                    );
                  },
                  placeholder: (context, image) {
                    return Container(
                      width: 100.0,
                      height: 100.0,
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.green,
                        ),
                      ),
                    );
                  },
                  errorWidget: (context, image, err) {
                    if (photoUrl == "" || photoUrl == null)
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(360)),
                          color: Theme.of(context).primaryColor,
                        ),
                        width: 100.0,
                        height: 100.0,
                        child: Center(
                          child: Center(
                            child: Text(
                              "${name[0].toUpperCase()}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 42,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    else {
                      return Container(
                        width: 100.0,
                        height: 100.0,
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              showToast(context,
                                  "Error loading profile image. Re-upload to view");
                            },
                            child: Center(
                              child: Icon(Icons.error),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name == null ? 'Name' : "${name.toString().toUpperCase()}",
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: color),
                ),
                InkWell(
                  onTap: () async {
                    String url = await AppUtils.buildDynamicLink(
                        uid: uid,
                        image: photoUrl ??
                            "https://inprepapp.com/assets/images/logo.png",
                        desc: designation ?? "InPrep User",
                        name: name.toString().toUpperCase());
                    print(url);
                    Clipboard.setData(ClipboardData(text: url));
                    await FlutterShare.share(
                      title: name,
                      text: designation,
                      linkUrl: url,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.share,
                      size: 15,
                      color:
                          dark ? Colors.grey : Theme.of(context).primaryColor,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 5.0),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                infoRow(
                    color: color,
                    dark: dark,
                    text: state ?? "State",
                    icon: Icons.map_outlined),
                infoRow(
                    color: color,
                    dark: dark,
                    text: designation ?? "Designation",
                    icon: Icons.work),
                infoRow(
                    color: color,
                    dark: dark,
                    text: city ?? "City",
                    icon: Icons.map),
                infoRow(
                    color: color,
                    dark: dark,
                    text: country ?? "Country",
                    icon: Icons.location_city),
                infoRow(
                    color: color,
                    dark: dark,
                    text: category ?? "Category",
                    icon: Icons.category),
                infoRow(
                    color: color,
                    dark: dark,
                    text: subCat ?? "Sub Category",
                    icon: Icons.category_outlined),
              ],
            ),
          ),
        ],
      )
    ],
  );
}

Widget infoRow({color, text, dark, icon}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            size: 18.0,
            color: color,
          ),
        ),
      ),
      Expanded(
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("$text",
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: dark ? Colors.grey : Colors.black54)),
          ),
        ),
      ),
    ],
  );
}

_launchURL(link) async {
  try {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      print('Could not launch $link');
    }
  } catch (e) {
    print(e);
    print('Could not launch $link');
  }
}

Widget buildPriceRange(context, dark, {String from, String to}) {
  String text = (from == null || to == null) ||
          (from == '' || to == '') ||
          (from == 'null' || to == 'null')
      ? 'No price set yet'
      : "${double.parse(from).toInt()} - ${double.parse(to).toInt()}";
  Color color = dark ? Colors.white : Theme.of(context).primaryColor;
  return ListTile(
    leading: Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 20.0),
      child: Icon(
        Icons.attach_money_sharp,
        size: 18.0,
        color: color,
      ),
    ),
    title: Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

Widget buildContact({Contact contact, context}) {
  return Column(
    children: [
      if (contact != null && contact.number != '')
        Row(
          children: <Widget>[
            SizedBox(width: 30.0),
            Icon(
              Icons.phone,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(width: 10.0),
            Text(
              "${contact.code}-${contact.number}",
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      if (contact == null && contact.number == '')
        Row(
          children: <Widget>[
            SizedBox(width: 30.0),
            Icon(
              Icons.phone,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(width: 10.0),
            Text(
              "Not Added",
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
    ],
  );
}

Row buildSocialsRow({fb, git, linkedin, tiktok, insta, dark, context}) {
  // print("DARK IN SOCIAL $dark");
  return Row(
    children: <Widget>[
      SizedBox(width: 20.0),
      IconButton(
        color: Colors.indigo,
        icon: Icon(FontAwesomeIcons.facebookF),
        onPressed: () {
          _launchURL("https://facebook.com/$fb");
        },
      ),
      SizedBox(width: 5.0),
      IconButton(
        color: Colors.grey,
        icon: Icon(FontAwesomeIcons.github),
        onPressed: () {
          _launchURL("https://github.com/$git");
        },
      ),
      SizedBox(width: 5.0),
      IconButton(
        color: Colors.blue,
        icon: Icon(FontAwesomeIcons.linkedin),
        onPressed: () async {
          String url = "https://www.linkedin.com/in/$linkedin";

          _launchURL(url);
        },
      ),
      SizedBox(width: 5.0),
      IconButton(
        color: Colors.redAccent,
        icon: Icon(FontAwesomeIcons.instagram),
        onPressed: () {
          _launchURL("https://www.instagram.com/$insta");
        },
      ),
      SizedBox(width: 5.0),
      GestureDetector(
        onTap: () {
          _launchURL("https://www.tiktok.com/@$tiktok");
        },
        child: Container(
          height: 20,
          width: 20,
          child: Tab(
            icon: dark
                ? Image.asset("assets/icons/ttw.png")
                : Image.asset("assets/icons/tt.png"),
          ),
        ),
      ),
      SizedBox(width: 15.0),
    ],
  );
}

Widget skillsWidgets(context, dark, List<Skill> skills) {
  List<Widget> skillWidgets = [];

  if (skills == null || skills.length < 1) {
    return buidPortfolioRow(context, true,
        dark: dark, title: 'No Skill Added Yet', to: '', from: '');
  }
  for (Skill skill in skills) {
    skillWidgets.add(buildSkillRow(skill.name, (skill.rank / 10).abs()));

    skillWidgets.add(SizedBox(height: 5.0));
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: skillWidgets,
  );
}

Widget imagesWidget(context, dark, images) {
  List<Widget> widgets = [];
  for (var image in images) {
    widgets.add(GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Image.network(image),
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dark ? Colors.white : Theme.of(context).primaryColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(image), fit: BoxFit.cover),
                shape: BoxShape.circle,
              ),
              height: 80,
              width: 80,
            ),
          ),
        ),
      ),
    ));
  }
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: widgets,
  );
}

Widget experienceWidgets(context, dark, List<Experience> exp) {
  List<Widget> expWidgets = [];
  if (exp == null || exp.length < 1) {
    return buidPortfolioRow(context, true,
        dark: dark, title: 'No Experience Added Yet', to: '', from: '');
  }
  for (Experience exp in exp) {
    expWidgets.add(buildExperienceRow(context,
        dark: dark,
        company: exp.title,
        position: exp.designation,
        from: exp.from,
        to: exp.to));
    expWidgets.add(SizedBox(height: 5.0));
  }

  return Column(
    children: expWidgets,
  );
}

Widget reviewWidgets(context, dark, List<Review> revs) {
  // print("REVIEWS  LENGTH ${revs.length}");
  List<Widget> revWidgets = [];
  if (revs != null) {
    for (Review rev in revs) {
      // print('REVIEWS $rev');
      // print('REVIEWS ${rev.gName}');
      revWidgets.add(buildReviewRow(context, dark: dark, review: rev));
      revWidgets.add(SizedBox(height: 5.0));
    }
  }
  if (revWidgets.length < 1) {
    return buidPortfolioRow(context, true,
        dark: dark, title: 'No Review Added Yet', to: '', from: '');
  }
  return Column(
    children: revWidgets,
  );
}

Widget educationWidgets(context, dark, List<Education> edu) {
  List<Widget> eduWidgets = [];
  if (edu == null || edu.length < 1) {
    return buidPortfolioRow(context, true,
        dark: dark, title: 'No Education Added Yet', to: '', from: '');
  }
  for (Education edu in edu) {
    eduWidgets.add(buildEducationRow(context,
        dark: dark,
        institue: edu.institute,
        country: edu.country,
        degree: edu.degree,
        from: edu.from,
        to: edu.to));
    eduWidgets.add(SizedBox(height: 5.0));
  }

  return Column(
    children: eduWidgets,
  );
}

Widget jobWidgets(context, List<Job> jobs) {
  List<Widget> jobWidgets = [];
  for (Job job in jobs) {
    jobWidgets.add(Row(
      children: <Widget>[
        buildJobsRow(context,
            salary: job.salaryFrom.toString(),
            location: '${job.city.toUpperCase()}, ${job.country.toUpperCase()}',
            title: '${job.title}'),
//          FlatButton.icon(
//            icon: Icon(Icons.delete),
//            onPressed: () async {
        //  print('${job.jid}');
//              bool deleted = await _databaseService.removeJob(jid: job.jid);
//
//              if (deleted)
//                setState(() {
        //  print('JOB DELETED');
//                });
//              else
        //  print('NOT DELETED');
//            },
//            label: Text(''),
//          ),
      ],
    ));
    jobWidgets.add(SizedBox(height: 5.0));
  }
  return Column(
    children: jobWidgets,
  );
}

Widget portfolioWidgets(context, dark, List<Portfolio> port) {
  List<Widget> portWidgets = [];
  if (port == null || port.length < 1) {
    return buidPortfolioRow(context, true,
        dark: dark, title: 'No Portfolio', to: '', from: '', image: '');
  }
  for (Portfolio port in port) {
    portWidgets.add(buidPortfolioRow(context, false,
        dark: dark,
        title: port.title,
        to: port.to,
        from: port.from,
        image: port.image));
    portWidgets.add(SizedBox(height: 5.0));
  }

  return Column(
    children: portWidgets,
  );
}

class ProfilePlaceHolder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: [
            Row(
              children: <Widget>[
                SizedBox(width: 20.0),
                Container(
                  height: 60,
                  width: 60,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    radius: 50.0,
                    child: Center(
                      child: Text(
                        'A',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Container(
                          color: Colors.grey,
                          child: Text(
                            "Name",
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.map_outlined,
                            size: 18.0,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(width: 10.0),
                          Container(
                            color: Colors.grey,
                            child: Text(
                              "Dummy Text",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.work,
                            size: 18.0,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(width: 10.0),
                          Container(
                            color: Colors.grey,
                            child: Text(
                              "Dummy Text",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.map,
                            size: 18.0,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(width: 10.0),
                          Container(
                            color: Colors.grey,
                            child: Text("Dummy Text",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.category,
                            size: 18.0,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(width: 10.0),
                          Container(
                            color: Colors.grey,
                            child: Text("Dummy Text",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),

            //HERE ENDS HEADER

            Container(
              height: 60,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(50.0)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.grey,
                ),
              ),
            ),
            Container(
              height: 60,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(50.0)),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 60,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(50.0)),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 60,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(50.0)),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 60,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(50.0)),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                SizedBox(width: 20.0),
                IconButton(
                  color: Colors.indigo,
                  icon: Icon(FontAwesomeIcons.facebookF),
                  onPressed: () {},
                ),
                SizedBox(width: 5.0),
                IconButton(
                  color: Colors.grey,
                  icon: Icon(FontAwesomeIcons.github),
                  onPressed: () {},
                ),
                SizedBox(width: 5.0),
                IconButton(
                  color: Colors.blue,
                  icon: Icon(FontAwesomeIcons.linkedin),
                  onPressed: () {},
                ),
                SizedBox(width: 5.0),
                IconButton(
                  color: Colors.redAccent,
                  icon: Icon(FontAwesomeIcons.instagram),
                  onPressed: () {},
                ),
                SizedBox(width: 5.0),
                Container(
                  height: 20,
                  width: 20,
                  child: Tab(
                    icon: Image.asset("assets/icons/tt.png"),
                  ),
                ),
                SizedBox(width: 15.0),
              ],
            ),
          ],
        ),
        Positioned(
            bottom: 10,
            right: 10,
            child: CircleAvatar(
              radius: 30,
              foregroundColor: Colors.grey,
              backgroundColor: Colors.grey,
              child: Container(
                color: Colors.grey,
                child: Text(''),
              ),
            ))
      ],
    );
  }
}
