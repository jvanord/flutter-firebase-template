import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  AuthService(
      {FirebaseAuth injectedFirebaseAuth, GoogleSignIn injectedGoogleSignIn})
      : _firebaseAuth = injectedFirebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = injectedGoogleSignIn ?? GoogleSignIn();

  Future<void> signUp({String email, String password}) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signIn(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential);
    return _firebaseAuth.currentUser();
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<UserInfo> getUser() async {
    return UserInfo(await _firebaseAuth.currentUser());
  }
}

class UserInfo {
  String name;
  String email;
  String photo;
  UserInfo(FirebaseUser user) {
    this.name = user.displayName;
    this.email = user.email;
    this.photo = user.photoUrl;
  }
}
