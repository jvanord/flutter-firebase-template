import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  FirebaseAuth firebaseAuth;
  GoogleSignIn googleSignIn;
  AuthService({this.firebaseAuth, this.googleSignIn});

  void lazyInit() {
    if (firebaseAuth == null) firebaseAuth = FirebaseAuth.instance;
    if (googleSignIn == null) googleSignIn = GoogleSignIn();
  }

  Future<void> signUp({String email, String password}) async {
    lazyInit();
    return await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signIn(String email, String password) {
    lazyInit();
    return firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<FirebaseUser> signInWithGoogle() async {
    lazyInit();
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await firebaseAuth.signInWithCredential(credential);
    return firebaseAuth.currentUser();
  }

  Future<void> signOut() async {
    return Future.wait([
      firebaseAuth.signOut(),
      googleSignIn.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    lazyInit();
    final currentUser = await firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<UserInfo> getUser() async {
    lazyInit();
    return UserInfo(await firebaseAuth.currentUser());
  }
}

class UserInfo {
  String name;
  String email;
  String photo;
  UserInfo(FirebaseUser user) {
    this.name = user.displayName
      ?? user.email
      ?? '${user.providerId} User ${user.uid}';
    this.email = user.email;
    this.photo = user.photoUrl;
  }
}
