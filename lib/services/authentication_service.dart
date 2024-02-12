import 'package:firebase_auth/firebase_auth.dart';

// Followed along with video https://www.youtube.com/watch?v=oJ5Vrya3wCQ

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> signIn({String email, String password}) async {
    UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    User user = result.user;
    return user.uid;
  }

  Future<String> createAccount({String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "Account created";
    } on FirebaseAuthException catch (e) {
      return Future.error(e);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  User getUser() {
    return _firebaseAuth.currentUser;
  }

  Future<void> passwordReset({String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> emailVerification() async {
    await getUser().sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    return getUser().emailVerified;
  }
}
