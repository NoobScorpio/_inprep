import 'package:InPrep/utils/loader_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:InPrep/models/database.dart';
import 'package:InPrep/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

enum authProblems {
  UserNotFound,
  PasswordNotValid,
  NetworkError,
  UserAlreadyRegistered
}

class AuthService {
  authProblems errorType;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> saveGoogleCreds({idToken, accessToken}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (idToken == (prefs.getString('idToken')) &&
          accessToken == (prefs.getString('accessToken'))) {
        await prefs.setString('idToken', idToken);
        await prefs.setString('accessToken', accessToken);
        await prefs.setBool('googleSignIn', true);
        await prefs.setBool('appleSignin', false);
      } else {
        await prefs.setBool('bioAuth', false);
        await prefs.setBool('pinAuth', false);
        await prefs.setString('idToken', idToken);
        await prefs.setString('accessToken', accessToken);
        await prefs.setBool('googleSignIn', true);
        await prefs.setBool('appleSignin', false);
      }
    } catch (e) {
      //print('ERR SAVING GOOGLE CREDS');
    }
  }

  Future<void> saveAppleCreds({idToken, accessToken}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (idToken == (prefs.getString('idToken')) &&
          accessToken == (prefs.getString('accessToken'))) {
        await prefs.setString('idToken', idToken);
        await prefs.setString('accessToken', accessToken);
        await prefs.setBool('appleSignin', true);
        await prefs.setBool('googleSignIn', false);
      } else {
        await prefs.setBool('bioAuth', false);
        await prefs.setBool('pinAuth', false);
        await prefs.setString('idToken', idToken);
        await prefs.setString('accessToken', accessToken);
        await prefs.setBool('appleSignin', true);
        await prefs.setBool('googleSignIn', false);
      }
    } catch (e) {
      //print('ERR SAVING GOOGLE CREDS');
    }
  }

  Future<MyUser> currentUser() async {
    return userFromFirebaseUser(_auth.currentUser);
  }

  Future<MyUser> signInWithEmailPassPin() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var email = prefs.getString('email');
      var password = prefs.getString('pass');
      await prefs.setBool('googleSignIn', false);
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return MyUser(uid: result.user.uid);
    } catch (e) {
      //print(e.message.toString());
      return null;
    }
  }

  Future<bool> resetPassword(String email, context) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      showToast(context, "A reset password link has been sent to your email");
      return true;
    } catch (e) {
      showToast(context, "Could not reset password");
      print(e);
      return false;
    }
  }

  Future<MyUser> signInWIthGoogleCreds() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var idToken = prefs.getString('idToken');
      var accessToken = prefs.getString('accessToken');
      if (idToken == null || accessToken == null) {
        return null;
      } else {
        final AuthCredential credential = GoogleAuthProvider.credential(
            idToken: idToken, accessToken: accessToken);
        final authResults = await _auth.signInWithCredential(credential);
        return userFromFirebaseUser(authResults.user);
      }
      // }

    } catch (e) {
      //print(e.message.toString());
      //print('ERR SIGNIN GOOGLE CREDS');
      return null;
    }
  }

  Future<MyUser> signInWIthAppleCreds() async {
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // var idToken = prefs.getString('idToken');
      // var accessToken = prefs.getString('accessToken');
      // final AuthCredential credential = GoogleAuthProvider.getCredential(
      //     idToken: idToken, accessToken: accessToken);
      final appleIdCredential =
          await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ]);
      final oAuthProvider = OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
          idToken: appleIdCredential.identityToken,
          accessToken: appleIdCredential.authorizationCode);
      final authResults = await _auth.signInWithCredential(credential);

      return userFromFirebaseUser(authResults.user);
      // }

    } catch (e) {
      //print(e.message.toString());
      //print('ERR SIGNIN APPLE CREDS');
      return null;
    }
  }

  Future<dynamic> signInWithApple({seeker, category, subCat, other}) async {
    try {
      final appleIdCredential =
          await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ]);
      final oAuthProvider = OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
          idToken: appleIdCredential.identityToken,
          accessToken: appleIdCredential.authorizationCode);

      final authResults = await _auth.signInWithCredential(credential);
      final user = authResults.user;
      bool find = await DatabaseService().userAvail(user.uid);
      //print('FOUND THE APPLE USER $find');
      //print('USER UID IS ${user.uid}');

      if (find == null || find == false) {
        if (category == 'Select' && !seeker)
          return 'Category';
        else if (subCat == 'Select' && !seeker)
          return 'Sub';
        else {
          bool stored = await DatabaseService().createUserData(
            category: seeker ? "Business" : category,
            subCat: seeker ? "Accounting" : subCat,
            other: other,
            displayName: user.displayName ?? "",
            uid: user.uid,
            photoUrl: user.photoURL ?? "",
            email: user.email.toLowerCase() ?? "",
            seeker: seeker,
          );
          //print(stored);
          if (stored) {
            //print('SAVING APPLE CREDS');
            saveAppleCreds(
                idToken: credential.idToken,
                accessToken: credential.accessToken);
            return userFromFirebaseUser(authResults.user);
          } else {
            //print(' STORED IF COULDNOT SAVING APPLE CREDS');
            return null;
          }
        }
      } else {
        //print('SAVING APPLE CREDS');
        saveAppleCreds(
            idToken: credential.idToken, accessToken: credential.accessToken);
        return userFromFirebaseUser(authResults.user);
      }
    } catch (e) {
      ////print('null');
      //print('COULDNOT SAVING APPLE CREDS');
      //print(e.toString());
      return null;
    }
  }

  Future<dynamic> signInWithGoogle({seeker, category, subCat, other}) async {
    //print('inside signin');
    try {
      GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      var idToken = googleSignInAuthentication.idToken;
      var accessToken = googleSignInAuthentication.accessToken;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      final authResults = await _auth.signInWithCredential(credential);
      final user = authResults.user;
      bool find = await DatabaseService().userAvail(user.uid);
      if (find == null || find == false) {
        print("FIND");
        if (category == 'Select' && !seeker)
          return 'Category';
        else if (subCat == 'Select' && !seeker)
          return 'Sub';
        else {
          bool stored = await DatabaseService().createUserData(
            category: seeker ? "Business" : category,
            subCat: seeker ? "Accounting" : subCat,
            displayName: user.displayName.toLowerCase(),
            uid: user.uid,
            photoUrl: user.photoURL,
            email: user.email.toLowerCase(),
            seeker: seeker,
            other: other,
          );
          //print(stored);
          if (stored) {
            // //print('SAVING GOOGLE CREDS');
            saveGoogleCreds(idToken: idToken, accessToken: accessToken);
            return userFromFirebaseUser(authResults.user);
          } else {
            ////print('null');
            return null;
          }
        }
      } else {
        // //print('SAVING GOOGLE CREDS');
        print("NOT FIND");
        saveGoogleCreds(idToken: idToken, accessToken: accessToken);
        return userFromFirebaseUser(authResults.user);
      }
    } catch (e) {
      print("ERROR IN Google SIGNIN METHOD $e");
      return null;
    }
//    FirebaseUser user=await _auth.signinwithg
  }

  //auth change user stream
  Stream<MyUser> get onAuthStateChanged {
    return _auth.authStateChanges().map(userFromFirebaseUser);
  }

  //SIGN IN WITH EMAIL PASS
  Future signIn(email, password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User user = result.user;
      // user.se
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (email.toString() == (prefs.getString('email')) &&
          password.toString() == (prefs.getString('pass'))) {
        await prefs.setString('email', email);
        await prefs.setString('pass', password);
        await prefs.setBool('googleSignIn', false);
        return MyUser(uid: user.uid);
      } else {
        await prefs.setBool('bioAuth', false);
        await prefs.setBool('pinAuth', false);
        await prefs.setString('email', email);
        await prefs.setString('pass', password);
        await prefs.setBool('googleSignIn', false);
        return MyUser(uid: user.uid);
      }
    } catch (e) {
      if (e.message.toString().contains(
          'There is no user record corresponding to this identifier')) {
        //print('YESYEDSYSAT');
        return 'NOUSER';
      }
      //print(e.message);
      return null;
    }
  }

  MyUser userFromFirebaseUser(User user) {
    return user != null
        ? MyUser(
            uid: user.uid, email: user.email, displayName: user.displayName)
        : null;
  }

//  REGISTER WITH EMAIL PASS
  Future register(
      {String email, password, uname, seeker, category, subCat, other}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email.trim().trimRight().trimLeft(), password: password);
      User user = result.user;

      bool saved = await DatabaseService().createUserData(
          uid: user.uid,
          email: email,
          pass: password,
          other: other,
          seeker: seeker,
          displayName: uname,
          verified: false,
          category: category,
          subCat: subCat);
      if (saved) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);
        await prefs.setString('pass', password);
        await prefs.setBool('googleSignIn', false);
        return MyUser(uid: user.uid);
      } else
        return null;
    } catch (e) {
      if (e.toString().contains('email-already-in-use'))
        return 'ERROR_EMAIL_ALREADY_IN_USE';
      print(e);
      return null;
    }
  }

//  SIGN OUT
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      //print(e.toString());

      return null;
    }
  }
}
