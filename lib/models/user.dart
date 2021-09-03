import 'package:InPrep/models/contact.dart';
import 'package:InPrep/models/education.dart';
import 'package:InPrep/models/experience.dart';
import 'package:InPrep/models/portfolio.dart';
import 'package:InPrep/models/review.dart';
import 'package:InPrep/models/social.dart';
import 'Skill.dart';

class MyUser {
  String uid;
  bool verified;
  bool read;
  String category;
  String subCategory;
  String skype;
  String email;
  String state;
  bool profile;
  String pass;
  int badge;
  String uname;
  bool seeker;
  String country;
  String design;
  String cover;
  String city;
  String desc;
  String displayName;
  String photoUrl;
  Contact contact;
  String other;
  Social social;
  String priceFrom, priceTo;
  List<Experience> experiences;
  List<Education> educations;
  List<Skill> skills;
  List<Portfolio> portfolio;
  List<Review> reviews;
  double rating;
  MyUser({
    this.read,
    this.uid,
    this.cover,
    this.other,
    this.verified,
    this.rating,
    this.state,
    this.category,
    this.badge,
    this.subCategory,
    this.skype,
    this.email,
    this.profile,
    this.pass,
    this.uname,
    this.seeker,
    this.country,
    this.design,
    this.city,
    this.desc,
    this.displayName,
    this.photoUrl,
    this.contact,
    this.social,
    this.experiences,
    this.educations,
    this.skills,
    this.portfolio,
    this.reviews,
    this.priceFrom,
    this.priceTo,
  });

  MyUser.fromJson(Map<String, dynamic> json) {
    read = json['read'];
    badge = json['badge'];
    cover = json['cover'];
    other = json['other'];
    subCategory = json['subCategory'];
    priceFrom = json['priceFrom'];
    rating = json['rating'];
    priceTo = json['priceTo'];
    uid = json['uid'];
    verified = json['verified'];
    category = json['category'];
    skype = json['skype'];
    email = json['email'];
    state = json['state'];
    profile = json['profile'];
    pass = json['pass'];
    uname = json['uname'];
    seeker = json['seeker'];
    country = json['country'];
    design = json['design'];
    city = json['city'];
    desc = json['desc'];
    displayName = json['displayName'];

    photoUrl = json['photoUrl'];
    contact =
        json['Contact'] != null ? new Contact.fromJson(json['Contact']) : null;
    social =
        json['Social'] != null ? new Social.fromJson(json['Social']) : null;
    if (json['experience'] != null) {
      experiences = new List<Experience>();
      json['experience'].forEach((v) {
        experiences.add(new Experience.fromJson(v));
      });
    }
    if (json['Education'] != null) {
      educations = new List<Education>();
      json['Education'].forEach((v) {
        educations.add(new Education.fromJson(v));
      });
    }
    if (json['Skill'] != null) {
      skills = new List<Skill>();
      json['Skill'].forEach((v) {
        skills.add(new Skill.fromJson(v));
      });
    }
    if (json['Portfolio'] != null) {
      portfolio = new List<Portfolio>();
      json['Portfolio'].forEach((v) {
        portfolio.add(new Portfolio.fromJson(v));
      });
    }
    if (json['Review'] != null) {
      reviews = new List<Review>();
      json['Review'].forEach((v) {
        reviews.add(new Review.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['priceFrom'] = this.priceFrom;
    data['badge'] = this.badge;
    data['other'] = this.other;
    data['priceTo'] = this.priceTo;
    data['rating'] = this.rating;
    data['read'] = this.read;
    data['subCategory'] = this.subCategory;
    data['uid'] = this.uid;
    data['verified'] = this.verified;
    data['category'] = this.category;
    data['skype'] = this.skype;
    data['email'] = this.email;
    data['state'] = this.state;
    data['cover'] = this.cover;
    data['profile'] = this.profile;
    data['pass'] = this.pass;
    data['uname'] = this.uname;
    data['seeker'] = this.seeker;
    data['country'] = this.country;
    data['design'] = this.design;
    data['city'] = this.city;
    data['desc'] = this.desc;
    data['displayName'] = this.displayName;
    data['photoUrl'] = this.photoUrl;
    if (this.contact != null) {
      data['Contact'] = this.contact.toJson();
    }
    if (this.social != null) {
      data['Social'] = this.social.toJson();
    }
    if (this.experiences != null) {
      data['experience'] = this.experiences.map((v) => v.toJson()).toList();
    }
    if (this.educations != null) {
      data['Education'] = this.educations.map((v) => v.toJson()).toList();
    }
    if (this.skills != null) {
      data['Skill'] = this.skills.map((v) => v.toJson()).toList();
    }
    if (this.portfolio != null) {
      data['Portfolio'] = this.portfolio.map((v) => v.toJson()).toList();
    }
    if (this.reviews != null) {
      data['Review'] = this.reviews.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
