import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';

void push(context, obj) {
  Navigator.push(context, MaterialPageRoute(builder: (_) => obj));
}

Future<String> pickImage(camera) async {
  try {
    List<Media> media;
    File selected;
    if (!camera) {
      media = await ImagesPicker.pick(
        count: 1,
        pickType: PickType.image,
        cropOpt: CropOption(
          aspectRatio: CropAspectRatio.custom,
          cropType: CropType.rect, // currently for android
        ),
      );
    } else {
      media = await ImagesPicker.openCamera(
        pickType: PickType.image,
        cropOpt: CropOption(
          aspectRatio: CropAspectRatio.custom,
          cropType: CropType.rect, // currently for android
        ),
      );
    }
    if (media != null) {
      selected = File(media[0].path);
      // _storage.bucket = 'gs://inprep-c8711.appspot.com';
      FirebaseStorage _storage;

      UploadTask _uploadTask;
      _storage =
          FirebaseStorage.instanceFor(bucket: 'gs://inprep-c8711.appspot.com');
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      // setState(() {
      _uploadTask =
          _storage.ref().child('images').child(fileName).putFile(selected);
      if (_uploadTask == null)
        return "";
      else {
        final snap = await _uploadTask.whenComplete(() => {});
        return await snap.ref.getDownloadURL();
      }
    } else {
      return "";
    }
  } catch (e) {
    print("UPLOAD ERROR $e");
    return "";
  }
}

Future<String> pickFile() async {
  try {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );
    if (result == null) {
      return "";
    } else {
      File selected = File(result.files.single.path);
      // _storage.bucket = 'gs://inprep-c8711.appspot.com';
      FirebaseStorage _storage;

      UploadTask _uploadTask;
      _storage =
          FirebaseStorage.instanceFor(bucket: 'gs://inprep-c8711.appspot.com');
      String fileName = DateTime.now().millisecondsSinceEpoch.toString() +
          ".${selected.path.split('.').last}";
      // setState(() {
      _uploadTask =
          _storage.ref().child('files').child(fileName).putFile(selected);
      if (_uploadTask == null)
        return "";
      else {
        final snap = await _uploadTask.whenComplete(() => {});
        return await snap.ref.getDownloadURL() + "\$" + fileName;
      }
    }
  } catch (e) {
    print("UPLOAD ERROR $e");
    return "";
  }
}

void pop(context) {
  Navigator.pop(context);
}

const categoryString =
    'Select a category and a sub category for your profile if you are already not signed in from google or apple before. This way seekers can easily '
    'find you based on your category and sub category.';

Widget background(context) {
  return Opacity(
    opacity: 0.09,
    child: Image.asset(
      "assets/images/bg.jpg",
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.fill,
    ),
  );
}

List<String> months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];
const List<String> catList = [
  "Select",
  'Business',
  'Education',
  'Tech',
  'Arts',
  'LifeStyle',
  'Medical',
  'Sports',
  'News'
];
const List<String> featuredList = [
  "Select",
  'Accounting',
  'Scientist',
  'App Development',
  'Calligraphers',
  'Photographer',
  'Psychologist',
  'Athlete',
  'Political'
];
const List<String> featuredListImages = [
  "Select",
  'https://cdn.corporatefinanceinstitute.com/assets/accounting.jpeg',
  'https://cdn.the-scientist.com/assets/articleNo/66230/aImg/32939/scientists-at-work-in-the-lab-l.jpg',
  'https://fenzodigital.com/wp-content/uploads/2018/08/Mobile-App.png',
  'https://bethebudget.com/wp-content/uploads/2021/04/make-money-as-a-calligrapher.jpg',
  'https://citybook.pk/wp-content/uploads/2019/09/Top-10-Inspirational-Photographers-You-Must-Hire-In-Pakistan-750x400.jpg',
  'https://leverageedu.com/blog/pu/wp-content/uploads/sites/3/2020/02/Clinical-Psychologist.jpg',
  'https://wyss.harvard.edu/app/uploads/2017/03/Athlete-running-636887598_5778x3250-e1489782353646-4096x2304.jpeg',
  'https://www.imf.org/external/pubs/ft/fandd/2020/06/images/frieden-1600.jpg'
];
const List<String> catListImages = [
  "",
  "https://www.mesarya.university/wp-content/uploads/2020/05/1-5.jpg",
  'https://images.theconversation.com/files/45159/original/rptgtpxd-1396254731.jpg?ixlib=rb-1.1.0&q=45&auto=format&w=754&fit=clip',
  'https://business-review.eu/wp-content/uploads/2016/03/biggest-deals-media-communication-and-technology.jpg',
  'https://ensia.com/wp-content/uploads/2018/01/Voices_Arts_main-760x378.jpg',
  'https://www.jpinternational.co.in/wp-content/uploads/2019/05/94381231-mind-map-on-the-topic-of-health-and-healthy-lifestyle-mental-map-vector-illustration-isolated-on-whi.jpg',
  'https://www.state.gov/wp-content/uploads/2019/04/shutterstock_683522173-2560x852.jpg',
  'https://en.unesco.org/sites/default/files/unesco-paragraphs/sport_3.jpg',
  'https://d4r15a7jvr7vs.cloudfront.net/ewoJICAgICAgICAgICAgICAgICJidWNrZXQiOiAiZmlsZXMubGJyLmNsb3VkIiwKCSAgICAgICAgICAgICAgICAia2V5IjogInB1YmxpYy8yMDIxLTAyL3NodXR0ZXJzdG9ja18yNDE2NTAxODcuanBnIiwKCSAgICAgICAgICAgICAgICAiZWRpdHMiOiB7CgkgICAgICAgICAgICAgICAgICAicmVzaXplIjogewoJICAgICAgICAgICAgICAgICAgICAid2lkdGgiOiA5NDUsCgkgICAgICAgICAgICAgICAgICAgICJoZWlnaHQiOiA1MjYsCgkgICAgICAgICAgICAgICAgICAgICJmaXQiOiAiY292ZXIiCgkgICAgICAgICAgICAgICAgICB9CgkgICAgICAgICAgICAgICAgfQoJICAgICAgICAgICAgfQ=='
];
const iconsOptions = [
  Icons.business,
  Icons.bookmark,
  Icons.settings,
  Icons.format_paint,
  Icons.lightbulb_outline,
  Icons.healing,
  Icons.directions_run,
  Icons.next_week
];
Map<String, String> icons = {
  "Business": "assets/categories/business.png",
  "Education": 'assets/categories/education.png',
  "Tech": 'assets/categories/tech.png',
  "Arts": 'assets/categories/art.png',
  "LifeStyle": 'assets/categories/lifestyle.png',
  "Medical": 'assets/categories/medical.png',
  "Sports": 'assets/categories/sports.png',
  "News": 'assets/categories/news.png',
};
Map<String, List<String>> subs = {
  "Select": [
    "Select",
  ],
  'Business': [
    "Select",
    "Accounting",
    "Tax Services",
    "Customer Care",
    "Entrepreneur",
    "Banking",
    "Finance",
    "Management",
    "Legal",
    "Sales",
    "Other",
  ],
  'Education': [
    "Select",
    "Teacher",
    "Professor",
    "Tutor",
    "Mathematician",
    "Historian",
    "Scientist",
    "Author",
    "Librarian",
    "Guidance Counselor",
    "Other",
  ],
  'Tech': [
    "Select",
    "Cybersecurity",
    "Game Development",
    "App Development",
    "Web Designer",
    "Graphics Designer",
    "Data Scientist",
    "Programmer",
    "Engineer",
    "Support Technicians",
    "Other",
  ],
  'Arts': [
    "Select",
    "Painter",
    "Curator",
    "Artist",
    "Sculptor",
    "Musician",
    "Music Producer",
    "DJ",
    "Choreographer",
    "Crafting",
    "Woodcarver",
    "Calligraphers",
    "Other",
  ],
  'LifeStyle': [
    "Select",
    "Home Decorator",
    "Photographer",
    "Pet Services",
    "Fitness Trainer",
    "Nutritionists",
    "Barber",
    "Beautician",
    "Tattoo Artist",
    "Fashion Designer",
    "Event Planner",
    "Jewelry Designer",
    "Modeling",
    "Other",
  ],
  'Medical': [
    "Select",
    "Psychologist",
    "Doctor",
    "Nurse",
    "Veterinarian",
    "Therapist",
    "Massage Therapist",
    "Medical Assistant",
    "Pharmacist",
    "Dentist",
    "Orthodontist",
    "Other",
  ],
  'Sports': [
    "Select",
    "Athlete",
    "Trainer",
    "Coach",
    "Agent",
    "Sports Anchor",
    "Physical Therapist",
    "Sports Nutritionist",
    "Statisticians",
    "Mascot",
    "Public Relations",
    "Other",
  ],
  'News': [
    "Select",
    "News Anchors",
    "Editor",
    "Journalist",
    "News Producer",
    "Political",
    "Weather Presenter",
    "Meteorologist",
    "Reporter",
    "News Director",
    "Camera Operator",
    "Broadcast Technician",
    "News Director",
    "Other",
  ],
};
const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);
Color colorDark = Colors.white;
const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
String khtml = """
<p style="text-align: center;"><strong>Terms and Conditions</strong></p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;"><strong>Agreement between User and INPREP</strong></p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">Welcome to www.InPrepApp.com The www.InPrep website is offered to you conditioned on your acceptance without modification of the terms, conditions, and notices contained herein (the "Terms"). Your use of the InPrep constitutes your agreement to all such Terms. Please read these terms carefully and keep a copy of them for your reference.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">The purpose of this website is to provide services and products we offer. These services and products include but is not limited to consulting, reviews, apparel, flyers, videos, and anything else provided by INPREP and it's subsidiaries, partners, and affiliates.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;"><strong>Privacy</strong></p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">Your use of the InPrep is subject to INPREP's Privacy Policy. Please review our Privacy Policy, which also governs InPrep and informs users of our data collection practices.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;"><strong>Electronic Communications</strong></p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">Visiting www.InPrep or sending emails to INPREP constitutes electronic communications. You consent to receive electronic communications and you agree that all agreements, notices, disclosures and other communications that we provide to you electronically, via email and on InPrep, satisfy any legal requirement that such communications be in writing.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;"><strong>Your Account</strong></p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">If you use this InPrep, you are responsible for maintaining the confidentiality of your account and password and for restricting access to your computer, and you agree to accept responsibility for all activities that occur under your account or password. You may not assign or otherwise transfer your account to any other person or entity. You acknowledge that INPREP is not responsible for third party access to your account that results from theft or misappropriation of your account. INPREP and its associates reserve the right to refuse or cancel service, terminate accounts, or remove or edit content in our sole discretion.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;"><strong>Children Under Eighteen</strong></p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">INPREP does not knowingly collect, either online or offline, personal information from persons under the age of thirteen. If you are under 18, you may use www.InPrep only with permission of a parent or guardian.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;"><strong>Links to Third Party Sites/Third Party Services</strong></p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">www.InPrep may contain links to other websites ("Linked Sites"). The Linked Sites are not under the control of INPREP and INPREP is not responsible for the contents of any Linked Site, including without limitation any link contained in a Linked Site, or any changes or updates to a Linked Site. INPREP is providing these links to you only as a convenience, and the inclusion of any link does not imply endorsement by INPREP of the InPrep or any association with its operators.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">Certain services made available via www.InPrep are delivered by third party sites and organizations. By using any product, service or functionality originating from the www.InPrep domain, you hereby acknowledge and consent that INPREP may share such information and data with any third party with whom INPREP has a contractual relationship to provide the requested product, service or functionality on behalf of www.InPrep users and customers.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;"><strong>No Unlawful or Prohibited Use/Intellectual Property&nbsp;</strong></p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">You are granted a non-exclusive, non-transferable, revocable license to access and use www.InPrep strictly in accordance with these terms of use. As a condition of your use of InPrep, you warrant to INPREP that you will not use the InPrep for any purpose that is unlawful or prohibited by these Terms. You may not use InPrep in any manner which could damage, disable, overburden, or impair InPrep or interfere with any other party's use and enjoyment of InPrep. You may not obtain or attempt to obtain any materials or information through any means not intentionally made available or provided for through InPrep.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">All content included as part of the Service, such as text, graphics, logos, images, as well as the compilation thereof, and any software used on InPrep, is the property of INPREP or its suppliers and protected by copyright and other laws that protect intellectual property and proprietary rights. You agree to observe and abide by all copyright and other proprietary notices, legends or other restrictions contained in any such content and will not make any changes thereto.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">You will not modify, publish, transmit, reverse engineer, participate in the transfer or sale, create derivative works, or in any way exploit any of the content, in whole or in part, found on InPrep. INPREP content is not for resale. Your use of InPrep does not entitle you to make any unauthorized use of any protected content, and in particular you will not delete or alter any proprietary rights or attribution notices in any content. You will use protected content solely for your personal use, and will make no other use of the content without the express written permission of INPREP and the copyright owner. You agree that you do not acquire any ownership rights in any protected content. We do not grant you any licenses, express or implied, to the intellectual property of INPREP or our licensors except as expressly authorized by these Terms.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;"><strong>Use of Communication Services</strong></p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">InPrep may contain bulletin board services, chat areas, news groups, forums, communities, personal web pages, calendars, and/or other message or communication facilities designed to enable you to communicate with the public at large or with a group (collectively, "Communication Services"). You agree to use the Communication Services only to post, send and receive messages and material that are proper and related to the particular Communication Service.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">By way of example, and not as a limitation, you agree that when using a Communication Service, you will not: defame, abuse, harass, stalk, threaten or otherwise violate the legal rights (such as rights of privacy and publicity) of others; publish, post, upload, distribute or disseminate any inappropriate, profane, defamatory, infringing, obscene, indecent or unlawful topic, name, material or information; upload files that contain software or other material protected by intellectual property laws (or by rights of privacy of publicity) unless you own or control the rights thereto or have received all necessary consents; upload files that contain viruses, corrupted files, or any other similar software or programs that may damage the operation of another's computer; advertise or offer to sell or buy any goods or services for any business purpose, unless such Communication Service specifically allows such messages; conduct or forward surveys, contests, pyramid schemes or chain letters; download any file posted by another user of a Communication Service that you know, or reasonably should know, cannot be legally distributed in such manner; falsify or delete any author attributions, legal or other proper notices or proprietary designations or labels of the origin or source of software or other material contained in a file that is uploaded; restrict or inhibit any other user from using and enjoying the Communication Services; violate any code of conduct or other guidelines which may be applicable for any particular Communication Service; harvest or otherwise collect information about others, including e-mail addresses, without their consent; violate any applicable laws or regulations.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">INPREP has no obligation to monitor the Communication Services. However, INPREP reserves the right to review materials posted to a Communication Service and to remove any materials in its sole discretion. INPREP reserves the right to terminate your access to any or all of the Communication Services at any time without notice for any reason whatsoever.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">INPREP reserves the right at all times to disclose any information as necessary to satisfy any applicable law, regulation, legal process or governmental request, or to edit, refuse to post or to remove any information or materials, in whole or in part, in INPREP 's sole discretion.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">Always use caution when giving out any personally identifying information about yourself or your children in any Communication Service. INPREP does not control or endorse the content, messages or information found in any Communication Service and, therefore, INPREP specifically disclaims any liability with regard to the Communication Services and any actions resulting from your participation in any Communication Service. Managers and hosts are not authorized INPREP spokespersons, and their views do not necessarily reflect those of INPREP.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">Materials uploaded to a Communication Service may be subject to posted limitations on usage, reproduction and/or dissemination. You are responsible for adhering to such limitations if you upload the materials.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">Materials Provided to www.InPrep or Posted on Any INPREP Web Page</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">INPREP does not claim ownership of the materials you provide to www.InPrep (including feedback and suggestions) or post, upload, input or submit to any INPREP InPrep or our associated services (collectively "Submissions"). However, by posting, uploading, inputting, providing or submitting your Submission you are granting INPREP, our affiliated companies and necessary sublicensees permission to use your Submission in connection with the operation of their Internet businesses including, without limitation, the rights to: copy, distribute, transmit, publicly display, publicly perform, reproduce, edit, translate and reformat your Submission; and to publish your name in connection with your Submission.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">No compensation will be paid with respect to the use of your Submission, as provided herein. INPREP is under no obligation to post or use any Submission you may provide and may remove any Submission at any time in INPREP 's sole discretion.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">By posting, uploading, inputting, providing or submitting your Submission you warrant and represent that you own or otherwise control all of the rights to your Submission as described in this section including, without limitation, all the rights necessary for you to provide, post, upload, input or submit the Submissions.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;"><strong>Third Party Accounts</strong></p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">You will be able to connect your INPREP account to third party accounts. By connecting your INPREP account to your third party account, you acknowledge and agree that you are consenting to the continuous release of information about you to others (in accordance with your privacy settings on those third party sites). If you do not want information about you to be shared in this manner, do not use this feature.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;"><strong>International Users</strong></p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">The Service is controlled, operated and administered by INPREP from our offices within the USA. If you access the Service from a location outside the USA, you are responsible for compliance with all local laws. You agree that you will not use the INPREP Content accessed through www.InPrep in any country or in any manner prohibited by any applicable laws, restrictions or regulations.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;"><strong>Indemnification</strong></p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">You agree to indemnify, defend and hold harmless INPREP, its officers, directors, employees, agents and third parties, for any losses, costs, liabilities and expenses (including reasonable attorney's fees) relating to or arising out of your use of or inability to use InPrep or services, any user postings made by you, your violation of any terms of this Agreement or your violation of any rights of a third party, or your violation of any applicable laws, rules or regulations. INPREP reserves the right, at its own cost, to assume the exclusive defense and control of any matter otherwise subject to indemnification by you, in which event you will fully cooperate with INPREP in asserting any available defenses.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;"><strong>Arbitration</strong></p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">In the event the parties are not able to resolve any dispute between them arising out of or concerning these Terms and Conditions, or any provisions hereof, whether in contract, tort, or otherwise at law or in equity for damages or any other relief, then such dispute shall be resolved only by final and binding arbitration pursuant to the Federal Arbitration Act, conducted by a single neutral arbitrator and administered by the American Arbitration Association, or a similar arbitration service selected by the parties, in a location mutually agreed upon by the parties. The arbitrator's award shall be final, and judgment may be entered upon it in any court having jurisdiction. In the event that any legal or equitable action, proceeding or arbitration arises out of or concerns these Terms and Conditions, the prevailing party shall be entitled to recover its costs and reasonable attorney's fees. The parties agree to arbitrate all disputes and claims in regards to these Terms and Conditions or any disputes arising as a result of these Terms and Conditions, whether directly or indirectly, including Tort claims that are a result of these Terms and Conditions. The parties agree that the Federal Arbitration Act governs the interpretation and enforcement of this provision. The entire dispute, including the scope and enforceability of this arbitration provision shall be determined by the Arbitrator. This arbitration provision shall survive the termination of these Terms and Conditions.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;"><strong>Class Action Waiver</strong></p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">Any arbitration under these Terms and Conditions will take place on an individual basis; class arbitrations and class/representative/collective actions are not permitted. THE PARTIES AGREE THAT A PARTY MAY BRING CLAIMS AGAINST THE OTHER ONLY IN EACH'S INDIVIDUAL CAPACITY, AND NOT AS A PLAINTIFF OR CLASS MEMBER IN ANY PUTATIVE CLASS, COLLECTIVE AND/ OR REPRESENTATIVE PROCEEDING, SUCH AS IN THE FORM OF A PRIVATE ATTORNEY GENERAL ACTION AGAINST THE OTHER. Further, unless both you and INPREP agree otherwise, the arbitrator may not consolidate more than one person's claims, and may not otherwise preside over any form of a representative or class proceeding.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;"><strong>Liability Disclaimer</strong></p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">THE INFORMATION, SOFTWARE, PRODUCTS, AND SERVICES INCLUDED IN OR AVAILABLE THROUGH INPREP MAY INCLUDE INACCURACIES OR TYPOGRAPHICAL ERRORS. CHANGES ARE PERIODICALLY ADDED TO THE INFORMATION HEREIN. INPREP AND/OR ITS SUPPLIERS MAY MAKE IMPROVEMENTS AND/OR CHANGES IN THE INPREP AT ANY TIME.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">INPREP AND/OR ITS SUPPLIERS MAKE NO REPRESENTATIONS ABOUT THE SUITABILITY, RELIABILITY, AVAILABILITY, TIMELINESS, AND ACCURACY OF THE INFORMATION, SOFTWARE, PRODUCTS, SERVICES AND RELATED GRAPHICS CONTAINED ON THE INPREP FOR ANY PURPOSE. TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, ALL SUCH INFORMATION, SOFTWARE, PRODUCTS, SERVICES AND RELATED GRAPHICS ARE PROVIDED "AS IS" WITHOUT WARRANTY OR CONDITION OF ANY KIND. INPREP AND/OR ITS SUPPLIERS HEREBY DISCLAIM ALL WARRANTIES AND CONDITIONS WITH REGARD TO THIS INFORMATION, SOFTWARE, PRODUCTS, SERVICES AND RELATED GRAPHICS, INCLUDING ALL IMPLIED WARRANTIES OR CONDITIONS OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, IN NO EVENT SHALL INPREP AND/OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, PUNITIVE, INCIDENTAL, SPECIAL, CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF USE, DATA OR PROFITS, ARISING OUT OF OR IN ANY WAY CONNECTED WITH THE USE OR PERFORMANCE OF INPREP, WITH THE DELAY OR INABILITY TO USE INPREP OR RELATED SERVICES, THE PROVISION OF OR FAILURE TO PROVIDE SERVICES, OR FOR ANY INFORMATION, SOFTWARE, PRODUCTS, SERVICES AND RELATED GRAPHICS OBTAINED THROUGH INPREP, OR OTHERWISE ARISING OUT OF THE USE OF INPREP, WHETHER BASED ON CONTRACT, TORT, NEGLIGENCE, STRICT LIABILITY OR OTHERWISE, EVEN IF INPREP OR ANY OF ITS SUPPLIERS HAS BEEN ADVISED OF THE POSSIBILITY OF DAMAGES. BECAUSE SOME STATES/JURISDICTIONS DO NOT ALLOW THE EXCLUSION OR LIMITATION OF LIABILITY FOR CONSEQUENTIAL OR INCIDENTAL DAMAGES, THE ABOVE LIMITATION MAY NOT APPLY TO YOU. IF YOU ARE DISSATISFIED WITH ANY PORTION OF INPREP, OR WITH ANY OF THESE TERMS OF USE, YOUR SOLE AND EXCLUSIVE REMEDY IS TO DISCONTINUE USING INPREP.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;"><strong>Termination/Access Restriction&nbsp;</strong></p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">INPREP reserves the right, in its sole discretion, to terminate your access to the InPrep and the related services or any portion thereof at any time, without notice. To the maximum extent permitted by law, this agreement is governed by the laws of the State of Michigan and you hereby consent to the exclusive jurisdiction and venue of courts in Michigan in all disputes arising out of or relating to the use of InPrep. Use of InPrep is unauthorized in any jurisdiction that does not give effect to all provisions of these Terms, including, without limitation, this section.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">You agree that no joint venture, partnership, employment, or agency relationship exists between you and INPREP as a result of this agreement or use of InPrep. INPREP's performance of this agreement is subject to existing laws and legal process, and nothing contained in this agreement is in derogation of INPREP's right to comply with governmental, court and law enforcement requests or requirements relating to your use of InPrep or information provided to or gathered by INPREP with respect to such use. If any part of this agreement is determined to be invalid or unenforceable pursuant to applicable law including, but not limited to, the warranty disclaimers and liability limitations set forth above, then the invalid or unenforceable provision will be deemed superseded by a valid, enforceable provision that most closely matches the intent of the original provision and the remainder of the agreement shall continue in effect.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">Unless otherwise specified herein, this agreement constitutes the entire agreement between the user and INPREP with respect to InPrep and it supersedes all prior or contemporaneous communications and proposals, whether electronic, oral or written, between the user and INPREP with respect to InPrep. A printed version of this agreement and of any notice given in electronic form shall be admissible in judicial or administrative proceedings based upon or relating to this agreement to the same extent and subject to the same conditions as other business documents and records originally generated and maintained in printed form. It is the express wish to the parties that this agreement and all related documents be written in English.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;"><strong>Changes to Terms</strong></p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">INPREP reserves the right, in its sole discretion, to change the Terms under which www.InPrep is offered. The most current version of the Terms will supersede all previous versions. INPREP encourages you to periodically review the Terms to stay informed of our updates.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;"><strong>Privacy Policy</strong></p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">- Your privacy is critically important to us.</p>
<p style="text-align: center;">INPREP is located at: Plano Texas</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">It is INPREP policy to respect your privacy regarding any information we may collect while operating our website. This Privacy Policy applies to www.InPrep (hereinafter, "us", "we", or "www.InPrep"). We respect your privacy and are committed to protecting personally identifiable information you may provide us through the Website. We have adopted this privacy policy ("Privacy Policy") to explain what information may be collected on our Website, how we use this information, and under what circumstances we may disclose the information to third parties. This Privacy Policy applies only to information we collect through the Website and does not apply to our collection of information from other sources.</p>
<p style="text-align: center;">This Privacy Policy, together with the Terms and conditions posted on our Website, set forth the general rules and policies governing your use of our Website. Depending on your activities when visiting our Website, you may be required to agree to additional terms and conditions.</p>
<p style="text-align: center;">(Full Privacy Policy on application)</p>
<p style="text-align: center;"></p>
<p style="text-align: center;"><strong>Website Visitors</strong></p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">Like most website operators, INPREP collects non-personally-identifying information of the sort that web browsers and servers typically make available, such as the browser type, language preference, referring site, and the date and time of each visitor request. INPREP purpose in collecting non-personally identifying information is to better understand how INPREP visitors use its website. From time to time, INPREP may release non-personally-identifying information in the aggregate, e.g., by publishing a report on trends in the usage of its website.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">INPREP also collects potentially personally-identifying information like Internet Protocol (IP) addresses for logged in users and for users leaving comments on http://www.InPrep blog posts. INPREP only discloses logged in user and commenter IP addresses under the same circumstances that it uses and discloses personally-identifying information as described below.</p>
<p style="text-align: center;"></p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;"><strong>Gathering of Personally-Identifying Information</strong></p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">Certain visitors to INPREP websites choose to interact with INPREP in ways that require INPREP to gather personally-identifying information. The amount and type of information that INPREP gathers depends on the nature of the interaction. For example, we ask visitors who request our services on http://www.InPrep to provide a number and email address.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;"></p>
<p style="text-align: center;"><strong>Security</strong></p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">The security of your Personal Information is important to us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your Personal Information, we cannot guarantee its absolute security.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;"><strong>Advertisements</strong></p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">Ads appearing on our website may be delivered to users by advertising partners, who may set cookies. These cookies allow the ad server to recognize your computer each time they send you an online advertisement to compile information about you or others who use your computer. This information allows ad networks to, among other things, deliver targeted advertisements that they believe will be of most interest to you. This Privacy Policy covers the use of cookies by INPREP and does not cover the use of cookies by any advertisers.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;"><strong>Links To External Sites</strong></p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">Our Service may contain links to external sites that are not operated by us. If you click on a third party link, you will be directed to that third party's site. We strongly advise you to review the Privacy Policy and terms and conditions of every site you visit.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">We have no control over, and assume no responsibility for the content, privacy policies or practices of any third party sites, products or services.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;"><strong>Aggregated Statistics</strong></p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">INPREP may collect statistics about the behavior of visitors to its website. INPREP may display this information publicly or provide it to others. However, INPREP does not disclose your personally-identifying information.</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;"><strong>Privacy Policy Changes</strong></p>
<p style="text-align: center;">&nbsp;</p>
<p style="text-align: center;">Although most changes are likely to be minor, INPREP may change its Privacy Policy from time to time, and in INPREP sole discretion. INPREP encourages visitors to frequently check this page for any changes to its Privacy Policy. Your continued use of InPrep after any change in this Privacy Policy will constitute your acceptance of such change.</p>
<p style="text-align: center;">&nbsp;</p>

""";
