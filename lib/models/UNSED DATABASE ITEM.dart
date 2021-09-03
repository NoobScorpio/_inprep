// //             CREATE & REMOVE JOB
// Future<bool> createJob(
//     {uid,
//       category,
//       compName,
//       title,
//       skill,
//       exp,
//       to,
//       from,
//       city,
//       country,
//       desc,
//       date}) async {
//   try {
//     var jobDoc = await jobsCollection.add({
//       'category': category,
//       'companyName': compName,
//       'desc': desc,
//       'exp': exp,
//       'city': city,
//       'date': date,
//       'country': country,
//       'from': from,
//       'to': to,
//       'skill': skill,
//       'title': title,
//       'uid': uid,
//       'timestamp': Timestamp.now(),
//     });
//     var jid = jobDoc.documentID;
//
//     await jobsCollection.document(jid).updateData({
//       'jid': jid,
//     });
//
//     return true;
//   } catch (e) {
//     print(e);
//     return false;
//   }
// }
//
// Future<bool> updateJob(
//     {uid,
//       jid,
//       compName,
//       category,
//       title,
//       skill,
//       exp,
//       to,
//       from,
//       city,
//       country,
//       desc,
//       date}) async {
//   try {
//     await jobsCollection.document(jid).updateData({
//       'category': category,
//       'companyName': compName,
//       'desc': desc,
//       'exp': exp,
//       'city': city,
//       'date': date,
//       'country': country,
//       'from': from,
//       'to': to,
//       'skill': skill,
//       'title': title,
//       'uid': uid,
//       'timestamp': Timestamp.now(),
//     });
//
//     return true;
//   } catch (e) {
//     print(e);
//     return false;
//   }
// }
//
// Future<bool> removeJob({jid}) async {
//   try {
//     await jobsCollection.document(jid).delete();
//     return true;
//   } catch (e) {
//     print(e);
//     return false;
//   }
// }

// Future<List<Job>> getSearchJobs(String search, {String search2}) async {
//   try {
//     List<Job> searchedJobs = [];
//
//     var jobs = await jobsCollection.getDocuments();
//
//     for (var doc in jobs.documents) {
//       var docJob = Job(
//         category: doc.data['category'],
//         uid: doc.data['uid'],
//         jid: doc.data['jid'],
//         title: doc.data['title'],
//         skill: doc.data['skill'],
//         salaryTo: doc.data['to'],
//         salaryFrom: doc.data['from'],
//         desc: doc.data['desc'],
//         date: doc.data['date'],
//         companyName: doc.data['companyName'],
//         city: doc.data['city'],
//         country: doc.data['country'],
//         exp: doc.data['exp'],
//       );
//       if (search2 == null) {
//         if (doc.data['title'].toString().contains(search)) {
//           searchedJobs.add(docJob);
//         }
//       } else {
//         if (search == '') {
//           if (doc.data['city'].toString().contains(search2) ||
//               doc.data['country'].toString().contains(search2)) {
//             if (search2.length == 0) continue;
//             searchedJobs.add(docJob);
//           }
//         } else if (search2 == '') {
//           if (doc.data['skill'].toString().contains(search) ||
//               doc.data['title'].toString().contains(search)) {
//             if (search.length == 0) continue;
//             searchedJobs.add(docJob);
//           }
//         } else if (search != '' && search2 != '') {
//           if (doc.data['city'].toString().contains(search2) ||
//               doc.data['country'].toString().contains(search2) ||
//               doc.data['skill'].toString().contains(search) ||
//               doc.data['title'].toString().contains(search)) {
//             if (search2.length == 0) continue;
//             searchedJobs.add(docJob);
//           }
//         }
//       }
//     }
//
//     return searchedJobs;
//   } catch (e) {
//     print(e);
//     return [];
//   }
// }
