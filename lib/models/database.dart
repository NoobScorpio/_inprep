import 'package:InPrep/models/blog.dart';
import 'package:InPrep/models/meeting.dart';
import 'package:InPrep/models/review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:InPrep/models/Skill.dart';
import 'package:InPrep/models/chat.dart';
import 'package:InPrep/models/contact.dart';
import 'package:InPrep/models/education.dart';
import 'package:InPrep/models/experience.dart';
import 'package:InPrep/models/order.dart';
import 'package:InPrep/models/payment.dart';

import 'package:InPrep/models/portfolio.dart';
import 'package:InPrep/models/session.dart';
import 'package:InPrep/models/social.dart';
import 'package:InPrep/models/user.dart';

import 'offer.dart';

class DatabaseService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('user');
  final CollectionReference contactsCollection =
      FirebaseFirestore.instance.collection('contact');
  final CollectionReference educationCollection =
      FirebaseFirestore.instance.collection('education');
  final CollectionReference experienceCollection =
      FirebaseFirestore.instance.collection('experience');
  final CollectionReference skillCollection =
      FirebaseFirestore.instance.collection('skill');
  final CollectionReference socialCollection =
      FirebaseFirestore.instance.collection('social');
  final CollectionReference portfolioCollection =
      FirebaseFirestore.instance.collection('portfolio');
  final CollectionReference chatsCollection =
      FirebaseFirestore.instance.collection('chats');
  final CollectionReference sessCollection =
      FirebaseFirestore.instance.collection('sessions');
  final CollectionReference paymentCollection =
      FirebaseFirestore.instance.collection('payments');
  final CollectionReference orderCollection =
      FirebaseFirestore.instance.collection('orders');
  final CollectionReference meetCollection =
      FirebaseFirestore.instance.collection('meeting');
  final CollectionReference reviewCollection =
      FirebaseFirestore.instance.collection('review');
  static final CollectionReference blogCollection =
      FirebaseFirestore.instance.collection('blog');

  Future<bool> createBlog({Blog blog}) async {
    try {
      var b = await blogCollection.add(blog.toJson());
      await blogCollection.doc(b.id).update({"bid": b.id});
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<String> createReview({Review review}) async {
    try {
      //print('MAKING REVIEW');
      var rev = await reviewCollection.add(review.toJson());
      var revid = rev.id;
      await reviewCollection.doc(revid).update({'rid': revid});
      //print('REVIEW MADE');
      return revid;
    } catch (e) {
      //print('ERROR IN REVIEW CREATION $e');
      return null;
    }
  }

  Future<String> createSession({Session session}) async {
    try {
      //print('MAKING SESSION');
      var sess = await sessCollection.add(session.toJson());
      var sessid = sess.id;
      await sessCollection.doc(sessid).update({'sessid': sessid});
      //print('SESSION MADE');
      return sessid;
    } catch (e) {
      //print('ERROR IN SESSION CREATION $e');
      return null;
    }
  }

  Future<String> createOrder({Order order}) async {
    try {
      //print('MAKING Order');
      var ord = await orderCollection.add(order.toJson());
      var oid = ord.id;
      await orderCollection.doc(oid).update({'oid': oid});
      //print('SESSION Order');
      return oid;
    } catch (e) {
      //print('ERROR IN Order CREATION $e');
      return null;
    }
  }

  Future<String> createPayment({Payment payment}) async {
    try {
      //print('MAKING Payment');
      var pay = await paymentCollection.add(payment.toJson());
      var payid = pay.id;
      await paymentCollection.doc(payid).update({'pid': payid});
      //print('Payment MADE');
      return payid;
    } catch (e) {
      //print('ERROR IN Payment CREATION $e');
      return null;
    }
  }

  Future<String> createMeet({Meeting meeting}) async {
    try {
      //print('MAKING MEETING');
      var meet = await meetCollection.add(meeting.toJson());
      var meetid = meet.id;
      await meetCollection.doc(meetid).update({'mid': meetid});
      //print('Payment MADE');
      return meetid;
    } catch (e) {
      //print('ERROR IN MEET CREATION $e');
      return null;
    }
  }

  Future<bool> updateUserVerification() async {
    try {
      User user = FirebaseAuth.instance.currentUser;
      await userCollection.doc(user.uid).update({
        'verified': true,
      });
      return true;
    } catch (e) {
      //print(e.message);
      return false;
    }
  }

  setSeeker({uid, seeker}) async {
    //print('CHANGING SEEKER');
    //print('BEFORE SEEKER $seeker');
    await userCollection.doc(uid).update({
      'seeker': seeker,
    });
    // var user =await userCollection.doc(uid).get();
  }

  Future<bool> getConfirmMessage({cid}) async {
    try {
      DocumentSnapshot chat = await chatsCollection.doc(cid).get();
      return chat.data()['confirm'];
    } catch (e) {
      //print(e);
      return false;
    }
  }

  getAppointment({cid}) async {
    try {
      var chat = await chatsCollection.doc(cid).get();
      ////print(chat.data()['confirm']);
      return chat.data()['confirm'];
    } catch (e) {
      //print(e);
      return null;
    }
  }

  getDateForAppointment({cid}) async {
    try {
      var chat = await chatsCollection.doc(cid).get();
      ////print(chat.data()['confirm']);
      return chat.data()['appointDate'];
    } catch (e) {
      //print(e);
      return null;
    }
  }

  getTimeForAppointment({cid}) async {
    try {
      var chat = await chatsCollection.doc(cid).get();
      ////print(chat.data()['confirm']);
      return chat.data()['appointTime'];
    } catch (e) {
      //print(e);
      return null;
    }
  }

  getSkype({uid}) async {
    try {
      //print(uid);
      QuerySnapshot user =
          await socialCollection.where('uid', isEqualTo: uid).get();

      // //print('${user.data()['displayName']} ISaaaa THE EMP');
      if (user.docs.length > 0) {
        //print('${user.docs.first.data()['skype']} IS THE EMP SKYPE');
        return user.docs.first.data()['skype'];
      }
      return null;
    } catch (e) {
      //print(e);
      //print('NO SKYPEaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
      return null;
    }
  }

  sendMessage(
      {cid,
      offerCancelled,
      cost,
      msg,
      accepted,
      sender,
      receiver,
      type,
      time,
      date,
      rid,
      sid,
      Offer offer,
      appointTime,
      appointDate,
      platform,
      file,
      image}) async {
    try {
      //print(cid);
      var message = await chatsCollection.doc(cid).collection('messages').add({
        'sender': sender,
        'receiver': receiver,
        'time': time,
        'message': msg,
        'rid': rid,
        'sid': sid,
        // 'offer': offer,
        'imgURL': image,
        // 'fileURL': file,
        'type': type,
        "sDeleted": false,
        "rDeleted": false
      });

      var meid = message.id;
      if (type == 2) offer.meid = meid.toString();
      //print(meid);
      await chatsCollection.doc(cid).collection('messages').doc(meid).update({
        'meid': meid,
        'timestamp': Timestamp.now(),
        'offer': offer == null
            ? Offer(
                meid: meid,
                cid: cid,
                oid: '',
                meetCount: 0,
                cost: 0.0,
                cancel: false,
                timestamp: Timestamp.now(),
                meets: []).toJson()
            : offer.toJson()
      });
      //print('MESAGE SENT');
      DocumentSnapshot chatDoc = await chatsCollection.doc(cid).get();
      Chat chat = Chat.fromJson(chatDoc.data());
      if (chat.users[0] == sid) {
        await chatsCollection.doc(cid).update({
          'timestamp': Timestamp.now(),
          'lastMessage': msg,
          'rRead': false,
          'rDeleted': false
        });
        await userCollection.doc(rid).update({"read": false});
      } else if (chat.users[1] == sid) {
        await chatsCollection
            .doc(cid)
            .update({'lastMessage': msg, 'sRead': false, 'sDeleted': false});
        await userCollection.doc(rid).update({"read": false});
      }
    } catch (e) {
      //print('MESSAGE NOT SENT');
      //print(e);
    }
  }

  Future<List<Chat>> getChats({sid}) async {
    ////print(sid);
    try {
      var chatsDocs = await chatsCollection
          .orderBy('timestamp', descending: true)
          .where('users', arrayContains: sid)
          .get();

      List<Chat> chats = [];
      for (int i = 0; i < chatsDocs.docs.length; i++) {
        Chat chat = Chat.fromJson(chatsDocs.docs[i].data());

        //print(chat.rid);
        if (chat.users[0] == sid) {
          //print(
          // "${chat.cid} with ${chat.senderName} and ${chat.receiverName} is deleted");
          if (chat.sDeleted) {
            continue;
          } else {
            chats.add(chat);
          }
        } else if (chat.users[1] == sid) {
          //print(
          // "${chat.cid} with ${chat.senderName} and ${chat.receiverName} is deleted");
          if (chat.rDeleted) {
            continue;
          } else {
            chats.add(chat);
          }
        }
        // chats.add(chat);
      }

      // //print('RETURNING CAHATS');
      return chats;
    } catch (e) {
      ////print('$e NO CHATS');
      return [];
    }
  }

  Future<List<Session>> getSessions({uid}) async {
    ////print(sid);
    try {
      //print('GET SESSION UID  $uid');
      var sessDocs = await sessCollection
          .orderBy('timestamp', descending: true)
          .where('user', arrayContains: uid)
          .get();
      ////print('${chatsDocs.docs.first.data()['sender']} IS THE ID $sid');
      List<Session> sessions = [];
      for (int i = 0; i < sessDocs.docs.length; i++) {
        // //print('INSIDE CHATs FOR LOOP');
        Session sess = Session.fromJson(sessDocs.docs[i].data());

        //  //print('CHAT ADDED');
        sessions.add(sess);
      }

      //print('RETURNING SESSIONS');
      return sessions;
    } catch (e) {
      //print('COULD NOT GET SESSIONS $e');
      return null;
    }
  }

  Future<List<Review>> getReviews({uid}) async {
    ////print(sid);
    try {
      //print('GET REVIEW UID  $uid');
      var revDocs = await reviewCollection
          .orderBy('timestamp', descending: true)
          .where('uid', isEqualTo: uid)
          .get();
      ////print('${chatsDocs.docs.first.data()['sender']} IS THE ID $sid');
      List<Review> reviews = [];
      for (int i = 0; i < revDocs.docs.length; i++) {
        // //print('INSIDE CHATs FOR LOOP');
        Review rev = Review.fromJson(revDocs.docs[i].data());

        //  //print('CHAT ADDED');
        reviews.add(rev);
      }

      //print('RETURNING REVIEWS');
      return reviews;
    } catch (e) {
      //print('COULD NOT GET REVIEWS $e');
      return null;
    }
  }

  Future<List<Payment>> getPayments({uid}) async {
    ////print(sid);
    try {
      //print('GET SESSION UID  $uid');
      var payDocs = await paymentCollection
          .orderBy('timestamp', descending: true)
          .where('sid', isEqualTo: uid)
          .get();
      ////print('${chatsDocs.docs.first.data()['sender']} IS THE ID $sid');
      List<Payment> payments = [];
      for (int i = 0; i < payDocs.docs.length; i++) {
        // //print('INSIDE CHATs FOR LOOP');
        Payment pay = Payment.fromJson(payDocs.docs[i].data());

        //  //print('CHAT ADDED');
        payments.add(pay);
      }

      //print('RETURNING PAYMENTS');
      return payments;
    } catch (e) {
      //print('COULD NOT GET PAYMENTS $e');
      return null;
    }
  }

  Future<List<Order>> getOrders({uid}) async {
    ////print(sid);
    try {
      //print('GET SESSION UID  $uid');
      var orderDocs = await orderCollection
          .orderBy('timestamp', descending: true)
          .where('uid', isEqualTo: uid)
          .get();
      ////print('${chatsDocs.docs.first.data()['sender']} IS THE ID $sid');
      List<Order> orders = [];
      for (int i = 0; i < orderDocs.docs.length; i++) {
        // //print('INSIDE CHATs FOR LOOP');
        Order order = Order.fromJson(orderDocs.docs[i].data());

        //  //print('CHAT ADDED');
        orders.add(order);
      }

      //print('RETURNING ORDERS');
      return orders;
    } catch (e) {
      //print('COULD NOT GET ORDERS $e');
      return null;
    }
  }

//
//
//  USER GETS USER GETS USER GETS
//
//
  Future<List<MyUser>> getSearchUser({search, title, title2}) async {
    try {
      //print('@SEEARCH $search $title $title2');
      List<MyUser> searchedUsers = [];
      var users = await userCollection.get();
      if (title != null && search != null) {
        for (var doc in users.docs) {
          MyUser user = MyUser.fromJson(doc.data());
          await userNullCheck(user: user);
          if ((user.displayName
                      .toString()
                      .toLowerCase()
                      .contains(search.toString().toLowerCase()) ||
                  user.email
                      .toString()
                      .toLowerCase()
                      .contains(search.toString().toLowerCase()) ||
                  user.design
                      .toString()
                      .toLowerCase()
                      .contains(search.toString().toLowerCase())) &&
              user.seeker == false &&
              user.category.toLowerCase() == title.toLowerCase()) {
            searchedUsers.add(user);
          }
        }
      } else if (title != null) {
        if (title2 != null) {
          print("inside title 2 ${users.size} $title2 $title");
          int i = 0;
          for (var doc in users.docs) {
            MyUser user = MyUser.fromJson(doc.data());
            // print(user.displayName);
            // i++;
            print("${user.subCategory} with ${user.displayName}");
            await userNullCheck(user: user);
            if ((user.subCategory.toLowerCase() ?? "accounting") ==
                    title2.toLowerCase() &&
                (user.category.toLowerCase() ?? "business") ==
                    title.toLowerCase() &&
                user.seeker == false) {
              searchedUsers.add(user);
            }
          }
        } else {
          for (var doc in users.docs) {
            MyUser user = MyUser.fromJson(doc.data());
            await userNullCheck(user: user);
            if (user.category.toLowerCase() == title.toLowerCase() &&
                user.seeker == false) {
              searchedUsers.add(user);
            }
          }
        }
      } else {
        for (var doc in users.docs) {
          MyUser user = MyUser.fromJson(doc.data());
          await userNullCheck(user: user);
          if ((user.displayName
                      .toString()
                      .toLowerCase()
                      .contains(search.toLowerCase()) ||
                  user.email
                      .toString()
                      .toLowerCase()
                      .contains(search.toLowerCase()) ||
                  user.design
                      .toString()
                      .toLowerCase()
                      .contains(search.toLowerCase())) &&
              user.seeker == false) {
            searchedUsers.add(user);
          }
        }
      }
      //print('COMPARING');
      Comparator<MyUser> usersComp = (a, b) =>
          a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase());
      searchedUsers.sort(usersComp);
      return searchedUsers;
    } catch (e) {
      //print(e);
      return null;
    }
  }

  Future<List<MyUser>> getAdvancedSearchUser(
      {category, subCategory, country, city, state}) async {
    try {
      // print('$category $subCategory $country $city $state');
      List<MyUser> searchedUsers = [];
      var users = await userCollection.get();
      // print("USERS FETCHED ${users.docs.length}");
      for (var doc in users.docs) {
        MyUser user = MyUser.fromJson(doc.data());
        // print("USERS FETCHED ${user.displayName}");
        await userNullCheck(user: user);
        if (category != null &&
            subCategory != null &&
            country != null &&
            city != null &&
            state != null) {
          if (((category ?? "") == user.category &&
                  (subCategory ?? "") == user.subCategory &&
                  (country ?? "") == user.country &&
                  (city ?? "") == user.city &&
                  (state ?? "") == user.state) &&
              user.seeker == false) {
            searchedUsers.add(user);
          }
        } else if (category != null &&
            subCategory != null &&
            country != null &&
            city != null) {
          if (((category ?? "") == user.category &&
                  (subCategory ?? "") == user.subCategory &&
                  (country ?? "") == user.country &&
                  (city ?? "") == user.city) &&
              user.seeker == false) {
            searchedUsers.add(user);
          }
        } else if (category != null && subCategory != null && country != null) {
          if (((category ?? "") == user.category &&
                  (subCategory ?? "") == user.subCategory &&
                  (country ?? "") == user.country) &&
              user.seeker == false) {
            searchedUsers.add(user);
          }
        } else if (category != null && subCategory != null) {
          if (((category ?? "") == user.category &&
                  (subCategory ?? "") == user.subCategory) &&
              user.seeker == false) {
            searchedUsers.add(user);
          }
        } else if (country != null && city != null && state != null) {
          if (((country ?? "") == user.country &&
                  (city ?? "") == user.city &&
                  (state ?? "") == user.state) &&
              user.seeker == false) {
            searchedUsers.add(user);
          }
        } else {
          searchedUsers.add(user);
        }
      }
      // print("USERS BEFORE COMPARE  ${searchedUsers.length}");
      Comparator<MyUser> usersComp = (a, b) =>
          a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase());
      searchedUsers.sort(usersComp);
      // print("USERS AFTER COMPARE  ${searchedUsers.length}");
      return searchedUsers;
    } catch (e) {
      //print(e);
      return null;
    }
  }

//
//  CREATE USER CREATE USER CREATE USER
//
  Future<bool> createUserData(
      {uid,
      email,
      pass,
      displayName,
      seeker,
      photoUrl,
      category,
      subCat,
      other,
      verified}) async {
    try {
      await userCollection.doc(uid).set({
        'uid': uid,
        'email': email,
        'pass': pass,
        'displayName': displayName,
        'seeker': seeker,
        'photoUrl': photoUrl != null ? "$photoUrl" : "",
        'profile': false,
        'category': category,
        'verified': verified,
        "subCategory": subCat,
        "other": other
      });
      return true;
    } catch (e) {
      //print(e);
      return false;
    }
  }

  Future<void> updateUserData(
      {seeker,
      uid,
      fullName,
      designation,
      description,
      country,
      city,
      url,
      skills,
      contacts,
      social,
      experience,
      portfolio,
      jobs,
      skype,
      education}) async {
    await userCollection.doc(uid).update({
      'displayName': fullName,
      'designation': designation,
      'country': country,
      'city': city,
      'description': description,
      'photoUrl': url,
      'skype': url,
    });
  }

  Future<bool> getUserSeeker(uid) async {
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();

    //print(snapshot.data()['seeker']);
    return snapshot.data()['seeker'];
  }

  Future<bool> userAvail(uid) async {
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    return snapshot.data != null;
  }

//  USER
//  PROFILE
//  INFORMATION

  Future<MyUser> getCurrentUserProfile(uid, {seeker, loggedin}) async {
    try {
      if (loggedin) {
        User fUser = FirebaseAuth.instance.currentUser;
        if (fUser.emailVerified) {
          await userCollection.doc(uid).update({
            'verified': true,
          });
        }
      }
      var user = await userCollection.doc(uid).get();

//    USER INFO GET
      MyUser u = MyUser.fromJson(user.data());

      //    USER SOCIAL DATA GET
      Social social;
      var socialColl =
          await socialCollection.where('uid', isEqualTo: uid).get();
//      //print('SOCIAL COLLECTION CALLED  INSIDE GETDATABASE');
//      //print('${socialColl.docs.length} IS LENGTH');
      if (socialColl.docs.length > 0) {
        var socialCollData = socialColl.docs.first;
        //print('${socialCollData.data}');
        social = Social.fromJson(socialCollData.data());
      }
      u.social = social;

      // //print('GETTING CONTACT INFO INSIDE GETDATABASE');
//    USER CONTACTS GET
      Contact contact;
      var contactColl =
          await contactsCollection.where('uid', isEqualTo: uid).get();
      if (contactColl.docs.length > 0) {
        var contactCollData = contactColl.docs.first;
        contact = Contact.fromJson(contactCollData.data());
      }
      u.contact = contact;
      // //print('GETTING INSIDE SEEKER IF  INSIDE GETDATABASE');
      if (!seeker) {
//      USER EDUCATION GET
        List<Education> educations = [];
        var educationColl =
            await educationCollection.where('uid', isEqualTo: uid).get();
        if (educationColl.docs.length > 0) {
          for (int i = 0; i < educationColl.docs.length; i++) {
            Education edu = Education.fromJson(educationColl.docs[i].data());
            educations.add(edu);
          }
        }

        // //print('GETTING INSIDE SEEKER IF SKILLS INSIDE GETDATABASE');
//      USER SKILL GET
        List<Skill> skills = [];
        var skillColl =
            await skillCollection.where('uid', isEqualTo: uid).get();
        if (skillColl.docs.length > 0) {
          for (int i = 0; i < skillColl.docs.length; i++) {
            Skill ski = Skill.fromJson(skillColl.docs[i].data());
            skills.add(ski);
          }
        }

        // //print('GETTING INSIDE SEEKER IF EXPERIENCE INSIDE GETDATABASE');
        //    USER EXPERIENCE GET
        List<Experience> experiences = [];
        var expColl =
            await experienceCollection.where('uid', isEqualTo: uid).get();
        if (expColl.docs.length > 0) {
          for (int i = 0; i < expColl.docs.length; i++) {
            Experience exp = Experience.fromJson(expColl.docs[i].data());
            experiences.add(exp);
          }
        }

        //        USER PORTFOLIO
        List<Portfolio> portfolio = [];
        var portfolioColl =
            await portfolioCollection.where('uid', isEqualTo: uid).get();
        if (portfolioColl.docs.length > 0) {
          for (int i = 0; i < portfolioColl.docs.length; i++) {
            var port = Portfolio.fromJson(portfolioColl.docs[i].data());
            portfolio.add(port);
            // //print('${portfolio[i].title} IS PORTFOLIO');
          }
        }
        //reviews
        List<Review> reviews = [];
        var reviewsColl =
            await reviewCollection.where('uid', isEqualTo: uid).get();
        if (reviewsColl.docs.length > 0) {
          for (int i = 0; i < reviewsColl.docs.length; i++) {
            Review rev = Review.fromJson(reviewsColl.docs[i].data());
            reviews.add(rev);
            // //print('${portfolio[i].title} IS PORTFOLIO');
          }
        }
        u.reviews = reviews;
        u.portfolio = portfolio;
        u.educations = educations;
        u.skills = skills;
        u.experiences = experiences;
        // //print('${u.social.skype}');
        //print('RETURNING CONSULTANT FROM DATABASE');
        return u;
      }
//ELSE
      else {
//        USER PORTFOLIO

        u.skills = [];
        u.experiences = [];
        u.educations = [];
        u.portfolio = [];
        //print('RETURNING SEEKER FROM DATABASE');
        return u;
      }
    } catch (e) {
      //print('$e +  CURRENTUSERPROFILE');
      return null;
    }
  }

//  SET
//  USER
//  PROFILE
//  INFORMATION
  Future<bool> setCurrentUserProfile(
      {uid,
      priceTo,
      priceFrom,
      category,
      subCat,
      displayName,
      design,
      city,
      country,
      photoUrl,
      desc,
      state,
      seeker,
      other,
      email}) async {
    try {
      //print(category);
      if (seeker)
        await userCollection.doc(uid).update({
          'displayName': displayName,
          'design': design,
          'desc': desc,
          'city': city,
          'country': country,
          'photoUrl': photoUrl,
          'profile': true,
          'category': category,
          'state': state,
          'subCategory': subCat,
          other: other
        });
      else
        await userCollection.doc(uid).update({
          'displayName': displayName,
          'design': design,
          'desc': desc,
          'city': city,
          'country': country,
          'photoUrl': photoUrl,
          'profile': true,
          'category': category,
          'state': state,
          'priceTo': priceTo,
          'priceFrom': priceFrom,
          'subCategory': subCat
//        'uid': uid,
//        'email': email,
//        'seeker': seeker
        });
      return true;
    } catch (e) {
      //print('$e ERROR DURING SETTING DATA');
      return false;
    }
  }

  Future<MyUser> getcurrentUserData(uid, {seeker, loggedin}) async {
    try {
      //print("getcurrentUserData USER : $uid");
      // if (loggedin) {
      //   User fUser = await FirebaseAuth.instance.currentUser();
      //   if (fUser.isEmailVerified) {
      //     await userCollection.doc(uid).update({
      //       'verified': true,
      //     });
      //   }
      // }
      //print("getcurrentUserData AFTER LOGIN USER : $uid");
      var user =
          await FirebaseFirestore.instance.collection('user').doc(uid).get();
      var userData = MyUser.fromJson(user.data());
      return userData;
    } catch (e) {
      //print("PROBLEM IN getCurrentUserData $e");
      return null;
    }
  }

//
//
//          CREATE AND REMOVE CONTACT
//
  Future<Contact> createContact({Contact contact}) async {
    try {
      var doc = await contactsCollection.add(contact.toJson());
      String cid = doc.id;
      await contactsCollection.doc(cid).update({'cid': cid});
      var cont = await contactsCollection.doc(cid).get();

      return Contact.fromJson(cont.data());
    } catch (e) {
      //print(e);
      return null;
    }
  }

  Future<bool> removeContact({cid}) async {
    try {
      await contactsCollection.doc(cid).delete();
      return true;
    } catch (e) {
      //print(e);
      return false;
    }
  }

  //
//
//          CREATE AND REMOVE PORTFOLIO
//
  Future<Portfolio> createPortfolio(
      {uid, title, from, to, current, image}) async {
    try {
      var portDoc = await portfolioCollection.add({
        'uid': uid,
        'title': title,
        'from': from,
        'to': to,
        'current': current,
        'image': image
      });
      String pid = portDoc.id;
      await portfolioCollection.doc(portDoc.id).update({'pid': pid});
      var portData = await portfolioCollection.doc(portDoc.id).get();
      Portfolio port = Portfolio.fromJson(portData.data());
      return port;
    } catch (e) {
      //print(e);
      return null;
    }
  }

  Future<bool> removePortfolio({pid}) async {
    try {
      await portfolioCollection.doc(pid).delete();
      return true;
    } catch (e) {
      //print(e);
      return false;
    }
  }

  //
//
//          CREATE AND REMOVE SOCIAL
//
  Future<Social> createSocial(
      {uid, fb, git, linkedin, tiktok, insta, skype}) async {
    try {
      String sid = '';
      QuerySnapshot socialDoc =
          await socialCollection.where('uid', isEqualTo: uid).get();
      // //print(socialDoc.docs.first.data);
      if (socialDoc.docs.length > 0) {
        //print('INSIDE IF');
        await socialCollection.doc(socialDoc.docs.first.data()['sid']).update({
          'uid': uid,
          'fb': fb ?? socialDoc.docs.first.data()['fb'],
          'git': git ?? socialDoc.docs.first.data()['git'],
          'linkedin': linkedin ?? socialDoc.docs.first.data()['linkedin'],
          'tiktok': tiktok ?? socialDoc.docs.first.data()['tiktok'],
          'insta': insta ?? socialDoc.docs.first.data()['insta'],
          'skype': skype ?? socialDoc.docs.first.data()['skype']
        });
        sid = socialDoc.docs.first.data()['sid'];
        //print('INSIDE IF END');
      } else {
        //print('INSIDE ELSE');
        var doc = await socialCollection.add({
          'uid': uid,
          'fb': fb,
          'git': git,
          'linkedin': linkedin,
          'tiktok': tiktok,
          'insta': insta,
          'skype': skype
        });
        sid = doc.id;
        await socialCollection.doc(sid).update({'sid': sid});
        //print('INSIDE ELSE END');
      }

      var socialData = await socialCollection.doc(sid).get();
      Social s = Social(
        sid: sid,
        uid: socialData.data()['uid'],
        fb: socialData.data()['fb'],
        git: socialData.data()['git'],
        tiktok: socialData.data()['tiktok'],
        insta: socialData.data()['insta'],
        linkedin: socialData.data()['linkedin'],
        skype: socialData.data()['skype'],
      );
      return s;
    } catch (e) {
      //print(e);
      return null;
    }
  }

  Future<bool> removeSocial({sid}) async {
    try {
      await socialCollection.doc(sid).delete();
      return true;
    } catch (e) {
      //print(e);
      return false;
    }
  }

  //
//
//          CREATE AND REMOVE EXPERIENCE
//
  Future<Experience> createExperience(
      {uid, to, from, title, designation}) async {
    try {
      //print('$uid IS THE ID');
      var expDoc = await experienceCollection.add({
        'uid': uid,
        'to': to,
        'from': from,
        'title': title,
        'designation': designation
      });
      String eid = expDoc.id;
      ////print('$eid is EXPERIENCE ID');
      await experienceCollection.doc(expDoc.id).update({'eid': eid});
      var expDocData = await experienceCollection.doc(expDoc.id).get();
      Experience exp = Experience(
        eid: eid,
        uid: expDocData.data()['uid'],
        from: expDocData.data()['from'],
        title: expDocData.data()['title'],
        designation: expDocData.data()['designation'],
        to: expDocData.data()['to'],
      );
      ////print('${exp.eid} is EXPERIENCE ID IN OBJECT');
      return exp;
    } catch (e) {
      //print(e);
      return null;
    }
  }

  Future<bool> removeExperience({eid}) async {
    try {
      await experienceCollection.doc(eid).delete();
      return true;
    } catch (e) {
      //print(e);
      return false;
    }
  }

  //
//
//          CREATE AND REMOVE EDUCATION
//
  Future<Education> createEducation(
      {uid, to, from, country, degree, institute, current}) async {
    try {
      //print('$uid IS THE ID');
      var eduDoc = await educationCollection.add({
        'uid': uid,
        'to': to,
        'from': from,
        'country': country,
        'degree': degree,
        'institute': institute,
        'current': current
      });
      String eid = eduDoc.id;
      await educationCollection.doc(eduDoc.id).update({'eid': eid});
      var eduDocData = await educationCollection.doc(eduDoc.id).get();
      Education edu = Education.fromJson(eduDocData.data());

      return edu;
    } catch (e) {
      //print(e);
      return null;
    }
  }

  Future<bool> removeEducation({eid}) async {
    //print('$eid is the ID');
    try {
      await educationCollection.doc(eid).delete();
      return true;
    } catch (e) {
      //print(e);
      return false;
    }
  }

  //
//
//          CREATE AND REMOVE SKILL
//
  Future<Skill> createSkill({uid, name, rank}) async {
    try {
      var skillDoc = await skillCollection.add({
        'uid': uid,
        'name': name,
        'rank': rank,
      });
      //print('${skillDoc.id} IS THE ID IN DOC ABOVE');
      String sid = skillDoc.id;
      await skillCollection.doc(skillDoc.id).update({'sid': sid});
      var skillDocData = await skillCollection.doc(skillDoc.id).get();
      //print('${skillDocData.data} IS THE ID IN DOC BELOW');
      Skill s = Skill(
        sid: sid,
        uid: skillDocData.data()['uid'],
        name: skillDocData.data()['name'],
        rank: skillDocData.data()['rank'],
      );
      //print('${s.sid} is the ID of skill');
      return s;
    } catch (e) {
      //print(e);
      return null;
    }
  }

  Future<bool> removeSkill({sid}) async {
    //print(sid);
    try {
      await skillCollection.doc(sid).delete();
      return true;
    } catch (e) {
      //print(e);
      return false;
    }
  }

  Future<String> createChat({
    sid,
    time,
    rid,
    sender,
    receiver,
  }) async {
    try {
      String cid = '$sid$rid';
      var users = [sid, rid];
      await chatsCollection.doc(cid).set({
        'appointTime': '',
        'sDeleted': false,
        'sRead': true,
        'rRead': false,
        'rDeleted': false,
        'rid': '$rid',
        'sid': '$sid',
        'receiverName': '$receiver',
        'senderName': '$sender',
        'confirm': false,
        'timestamp': Timestamp.now(),
        'users': FieldValue.arrayUnion(users),
        'lastMessage': 'Happy Consulting'
      });

      // //print(' CHAT ADDED $cid');
      var message = await chatsCollection.doc(cid).collection('messages').add({
        'sender': 'InPrep',
        'receiver': '',
        'message': 'Happy Consulting',
        'time': time.toString(),
        'rid': '$rid',
        'sid': '$sid',
        'timestamp': Timestamp.now(),
        'type': 0,
        'imgURL': '',
        'sDeleted': false,
        'rDeleted': false
      });
      String meid = message.id;
      Offer offer = Offer(
          meid: meid,
          cid: cid,
          oid: '',
          meetCount: 0,
          cancel: false,
          timestamp: Timestamp.now(),
          meets: []);

      await chatsCollection
          .doc(cid)
          .collection('messages')
          .doc(meid)
          .update({'meid': meid, 'offer': offer.toJson()});
      await chatsCollection.doc(cid).update({
        'cid': cid,
      });
      await userCollection.doc(rid).update({'read': false});
      // _saveDeviceToken(sid);
      return cid;
    } catch (e) {
      //print(e);
      return null;
    }
  }

  searchChat({String sid, String rid}) async {
    ////print('$sid and $rid');
    var users = [sid, rid];
    //print('$users are MY USERS');
    try {
      var chats = await chatsCollection.get();
      for (var chat in chats.docs) {
        if (chat.id.contains(sid) && chat.id.contains(rid)) {
          await chatsCollection
              .doc(chat.id)
              .update({'rDeleted': false, 'sDeleted': false});
          return chat.id;
        }
      }

      return null;
    } catch (e) {
      //print(e);
      return null;
    }
  }

  Future<void> userNullCheck({user}) async {
    if (user.category == null || user.subCategory == null) {
      if (user.category == null && user.subCategory == null) {
        await userCollection
            .doc(user.uid)
            .update({'category': 'Business', 'subCategory': 'Accounting'});
      } else if (user.category == null) {
        await userCollection.doc(user.uid).update({'category': 'Business'});
      } else if (user.subCategory == null) {
        await userCollection
            .doc(user.uid)
            .update({'subCategory': 'Accounting'});
      }
    }
  }
}
