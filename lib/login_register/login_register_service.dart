part of 'login_register_controller.dart';

class _LoginRegisterService {
  static final _auth = FirebaseAuth.instance;

  static Future<User?> loginRegister(Map<String, dynamic> data, bool isLogin) async {
    final prefs = await SharedPreferences.getInstance();
    UserCredential userCredential;

    if (isLogin) {
      userCredential = await _auth.signInWithEmailAndPassword(email: data['email'], password: data['password']);
    } else {
      userCredential = await _auth.createUserWithEmailAndPassword(email: data['email'], password: data['password']);
    }

    await prefs.setString('token', userCredential.user!.uid);

    return userCredential.user;
  }
}
