import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuthService authService = FirebaseAuthService();

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  get user => _auth.currentUser;

  bool isAuthenticated() {
    final User? currentUser = _auth.currentUser;
    final bool isAuth = currentUser != null;
    return isAuth;
  }

  String? getUserId() {
    final User? currentUser = _auth.currentUser;
    return currentUser?.uid;
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      String uid = userCredential.user?.uid ?? '';
      return uid;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  Future signOut() async {
    await _auth.signOut();
  }
}
