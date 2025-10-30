// import 'package:firebase_auth/firebase_auth.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   // Lấy user hiện tại
//   User? get currentUser => _auth.currentUser;

//   // Stream theo dõi trạng thái đăng nhập
//   Stream<User?> get authStateChanges => _auth.authStateChanges();

//   // Đăng ký với email và password
//   Future<UserCredential?> signUpWithEmailPassword({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       UserCredential userCredential = await _auth
//           .createUserWithEmailAndPassword(email: email, password: password);
//       return userCredential;
//     } on FirebaseAuthException catch (e) {
//       // Xử lý các lỗi cụ thể
//       if (e.code == 'weak-password') {
//         throw 'Mật khẩu quá yếu.';
//       } else if (e.code == 'email-already-in-use') {
//         throw 'Email này đã được sử dụng.';
//       } else if (e.code == 'invalid-email') {
//         throw 'Email không hợp lệ.';
//       } else {
//         throw 'Đã xảy ra lỗi: ${e.message}';
//       }
//     } catch (e) {
//       throw 'Đã xảy ra lỗi không xác định.';
//     }
//   }

//   // Đăng nhập với email và password
//   Future<UserCredential?> signInWithEmailPassword({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return userCredential;
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         throw 'Không tìm thấy tài khoản với email này.';
//       } else if (e.code == 'wrong-password') {
//         throw 'Mật khẩu không chính xác.';
//       } else if (e.code == 'invalid-email') {
//         throw 'Email không hợp lệ.';
//       } else if (e.code == 'user-disabled') {
//         throw 'Tài khoản đã bị vô hiệu hóa.';
//       } else {
//         throw 'Đã xảy ra lỗi: ${e.message}';
//       }
//     } catch (e) {
//       throw 'Đã xảy ra lỗi không xác định.';
//     }
//   }

//   // Đăng xuất
//   Future<void> signOut() async {
//     await _auth.signOut();
//   }

//   // Gửi email reset password
//   Future<void> sendPasswordResetEmail(String email) async {
//     try {
//       await _auth.sendPasswordResetEmail(email: email);
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         throw 'Không tìm thấy tài khoản với email này.';
//       } else {
//         throw 'Đã xảy ra lỗi: ${e.message}';
//       }
//     }
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Lấy user hiện tại
  User? get currentUser => _auth.currentUser;

  // Stream theo dõi trạng thái đăng nhập
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ==================== EMAIL/PASSWORD ====================

  // Đăng ký với email và password
  Future<UserCredential?> signUpWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Tự động gửi email verification sau khi đăng ký
      await userCredential.user?.sendEmailVerification();

      return userCredential;
    } on FirebaseAuthException catch (e) {
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
      } else if (e.code == 'invalid-credential') {
        throw 'Thông tin đăng nhập không hợp lệ.';
      } else {
        throw 'Đã xảy ra lỗi: ${e.message}';
      }
    } catch (e) {
      throw 'Đã xảy ra lỗi không xác định.';
    }
  }

  // ==================== GOOGLE SIGN-IN ====================

  // Đăng nhập với Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Nếu user hủy đăng nhập
      if (googleUser == null) {
        throw 'Đăng nhập Google bị hủy.';
      }

      // Lấy auth details từ request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Tạo credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Đăng nhập vào Firebase với credential
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        throw 'Tài khoản đã tồn tại với phương thức đăng nhập khác.';
      } else if (e.code == 'invalid-credential') {
        throw 'Thông tin xác thực không hợp lệ.';
      } else {
        throw 'Đã xảy ra lỗi: ${e.message}';
      }
    } catch (e) {
      throw 'Đã xảy ra lỗi: $e';
    }
  }

  // ==================== EMAIL VERIFICATION ====================

  // Gửi email verification
  Future<void> sendEmailVerification() async {
    try {
      User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      } else if (user == null) {
        throw 'Không có user đang đăng nhập.';
      } else {
        throw 'Email đã được xác thực.';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'too-many-requests') {
        throw 'Đã gửi quá nhiều yêu cầu. Vui lòng thử lại sau.';
      } else {
        throw 'Đã xảy ra lỗi: ${e.message}';
      }
    }
  }

  // Reload user để cập nhật emailVerified status
  Future<void> reloadUser() async {
    await _auth.currentUser?.reload();
  }

  // Kiểm tra email đã verified chưa
  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  // ==================== PASSWORD RESET ====================

  // Gửi email reset password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'Không tìm thấy tài khoản với email này.';
      } else if (e.code == 'invalid-email') {
        throw 'Email không hợp lệ.';
      } else {
        throw 'Đã xảy ra lỗi: ${e.message}';
      }
    }
  }

  // ==================== UPDATE PROFILE ====================

  // Cập nhật display name
  Future<void> updateDisplayName(String displayName) async {
    try {
      await _auth.currentUser?.updateDisplayName(displayName);
      await reloadUser();
    } on FirebaseAuthException catch (e) {
      throw 'Đã xảy ra lỗi: ${e.message}';
    }
  }

  // Cập nhật photo URL
  Future<void> updatePhotoURL(String photoURL) async {
    try {
      await _auth.currentUser?.updatePhotoURL(photoURL);
      await reloadUser();
    } on FirebaseAuthException catch (e) {
      throw 'Đã xảy ra lỗi: ${e.message}';
    }
  }

  // Cập nhật cả tên và ảnh
  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    try {
      if (displayName != null) {
        await _auth.currentUser?.updateDisplayName(displayName);
      }
      if (photoURL != null) {
        await _auth.currentUser?.updatePhotoURL(photoURL);
      }
      await reloadUser();
    } on FirebaseAuthException catch (e) {
      throw 'Đã xảy ra lỗi: ${e.message}';
    }
  }

  // Đổi password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) throw 'Không có user đang đăng nhập.';

      // Re-authenticate user trước khi đổi password
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw 'Mật khẩu hiện tại không đúng.';
      } else if (e.code == 'weak-password') {
        throw 'Mật khẩu mới quá yếu.';
      } else if (e.code == 'requires-recent-login') {
        throw 'Vui lòng đăng nhập lại để thực hiện thao tác này.';
      } else {
        throw 'Đã xảy ra lỗi: ${e.message}';
      }
    }
  }

  // ==================== SIGN OUT ====================

  // Đăng xuất
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(), // Đăng xuất khỏi Google
    ]);
  }

  // ==================== DELETE ACCOUNT ====================

  // Xóa tài khoản
  Future<void> deleteAccount(String password) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) throw 'Không có user đang đăng nhập.';

      // Re-authenticate trước khi xóa
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
      await user.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw 'Mật khẩu không đúng.';
      } else if (e.code == 'requires-recent-login') {
        throw 'Vui lòng đăng nhập lại để xóa tài khoản.';
      } else {
        throw 'Đã xảy ra lỗi: ${e.message}';
      }
    }
  }
}
