// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_task/constants/Utils.dart';

class GoogleSigninController extends GetxController {
  var successMsg = "";
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

        User? user = userCredential.user;

        Utils.userName = user?.displayName;
        Utils.profilePic = user?.photoURL;       
        return user;
        
      } else {
        return null; // User canceled Google Sign-In
      }
    } catch (error) {
      print("Google Sign-In Error: $error");
      return null; // Handle the error gracefully
    }
  }
}