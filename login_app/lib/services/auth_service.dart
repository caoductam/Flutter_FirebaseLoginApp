import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Lấy user hiện tại
  User? get currentUser => _auth.currentUser;

  // Stream theo dõi trạng thái đăng nhập
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Đăng ký với email và password
  Future<UserCredential?> signUpWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Xử lý các lỗi cụ thể
      if (e.code == 'weak-password') {
        throw 'Mật khẩu quá yếu.';
      } else if (e.code == 'email-already-in-use') {
        throw 'Email này đã được sử dụng.';
      } else if (e.code == 'invalid-email') {
        throw 'Email không hợp lệ.';
      } else {
        throw 'Đã xảy ra lỗi: ${e.message}';
      }
    } catch (e) {
      throw 'Đã xảy ra lỗi không xác định.';
    }
  }

  // Đăng nhập với email và password
  Future<UserCredential?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'Không tìm thấy tài khoản với email này.';
      } else if (e.code == 'wrong-password') {
        throw 'Mật khẩu không chính xác.';
      } else if (e.code == 'invalid-email') {
        throw 'Email không hợp lệ.';
      } else if (e.code == 'user-disabled') {
        throw 'Tài khoản đã bị vô hiệu hóa.';
      } else {
        throw 'Đã xảy ra lỗi: ${e.message}';
      }
    } catch (e) {
      throw 'Đã xảy ra lỗi không xác định.';
    }
  }

  // Đăng xuất
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Gửi email reset password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'Không tìm thấy tài khoản với email này.';
      } else {
        throw 'Đã xảy ra lỗi: ${e.message}';
      }
    }
  }
}
