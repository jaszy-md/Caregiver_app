import 'package:firebase_auth/firebase_auth.dart';
import 'package:care_link/core/firestore/services/user_service.dart';

class AuthFlowService {
  final _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();

  /// Deze functie bepaalt waar de gebruiker heen moet
  Future<String> resolveNextRoute() async {
    final user = _auth.currentUser;
    if (user == null) return '/login';

    final userDoc = await _userService.getUser(user.uid);

    // Bestaat Firestore document niet?
    if (userDoc == null) {
      // Maak nieuw Firestore user-profiel aan
      await _userService.createUser(user.uid, {
        'email': user.email ?? '',
        'name': user.displayName ?? '',
        'createdAt': DateTime.now(),
        'linkedUserIds': [],
        'role': null, // user moet rol nog kiezen
        'userID': _generateUserID(),
      });

      return '/prehome'; // Nieuwe gebruiker -> rol kiezen
    }

    // Bestaat document wel, maar heeft geen rol?
    if (userDoc['role'] == null) {
      return '/prehome';
    }

    // Gebruiker heeft al een rol → direct doorsturen
    if (userDoc['role'] == 'caregiver') {
      return '/caregiverhome';
    } else if (userDoc['role'] == 'patient') {
      return '/patienthome';
    }

    return '/prehome';
  }

  /// Simpele code-generator voor userID (zoals D3JF5L)
  String _generateUserID() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    chars.split('');
    final random = List.generate(
      6,
      (index) =>
          chars[(DateTime.now().millisecondsSinceEpoch + index) % chars.length],
    );
    return random.join();
  }
}
