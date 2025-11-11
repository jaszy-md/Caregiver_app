import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithGoogle() async {
    try {
      // Kies een Google-account
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: ['email']).signIn();

      if (googleUser == null) return null;

      // Haal authenticatiegegevens op
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Maak Firebase-credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Log in bij Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      return userCredential.user;
    } catch (e) {
      print('❌ Fout bij Google-login: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
      await GoogleSignIn().disconnect();
      await _auth.signOut();
    } catch (e) {
      print('❌ Fout bij uitloggen: $e');
    }
  }
}
