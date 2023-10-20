import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignoutController extends GetxController{
  Future<void> signOutFromGoogle() async {
  final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signOut();

  if (googleSignInAccount != null) {
    // User is successfully signed out from Google
  } else {
    // There was an issue signing out
  }
}
}