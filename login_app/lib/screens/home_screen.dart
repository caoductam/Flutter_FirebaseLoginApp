// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../services/auth_service.dart';
// import 'profile_screen.dart';
// import 'email_verification_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final _authService = AuthService();
//   User? _user;

//   @override
//   void initState() {
//     super.initState();
//     _user = _authService.currentUser;
//   }

//   Future<void> _handleLogout() async {
//     // Hiển thị dialog xác nhận
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Đăng Xuất'),
//         content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Hủy'),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text('Đăng Xuất'),
//           ),
//         ],
//       ),
//     );

//     if (confirmed == true) {
//       try {
//         await _authService.signOut();
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Đã đăng xuất'),
//               backgroundColor: Colors.green,
//             ),
//           );
//         }
//         // StreamBuilder sẽ tự động chuyển về LoginScreen
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Lỗi: ${e.toString()}'),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Trang Chủ'),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: _handleLogout,
//             tooltip: 'Đăng xuất',
//           ),
//         ],
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Avatar
//               CircleAvatar(
//                 radius: 60,
//                 backgroundColor: Theme.of(
//                   context,
//                 ).primaryColor.withOpacity(0.2),
//                 child: Icon(
//                   Icons.person,
//                   size: 60,
//                   color: Theme.of(context).primaryColor,
//                 ),
//               ),
//               const SizedBox(height: 32),

//               // Welcome Text
//               Text(
//                 'Chào mừng!',
//                 style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // User Info Card
//               Card(
//                 elevation: 2,
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Thông Tin Tài Khoản',
//                         style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const Divider(height: 24),

//                       // Email
//                       _buildInfoRow(
//                         icon: Icons.email,
//                         label: 'Email',
//                         value: _user?.email ?? 'N/A',
//                       ),
//                       const SizedBox(height: 12),

//                       // User ID
//                       _buildInfoRow(
//                         icon: Icons.fingerprint,
//                         label: 'User ID',
//                         value: _user?.uid ?? 'N/A',
//                       ),
//                       const SizedBox(height: 12),

//                       // Email Verified
//                       _buildInfoRow(
//                         icon: Icons.verified_user,
//                         label: 'Email đã xác thực',
//                         value: _user?.emailVerified == true ? 'Có' : 'Chưa',
//                       ),
//                       const SizedBox(height: 12),

//                       // Creation Time
//                       if (_user?.metadata.creationTime != null)
//                         _buildInfoRow(
//                           icon: Icons.calendar_today,
//                           label: 'Ngày tạo',
//                           value: _formatDate(_user!.metadata.creationTime!),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 32),

//               // Logout Button
//               OutlinedButton.icon(
//                 onPressed: _handleLogout,
//                 icon: const Icon(Icons.logout),
//                 label: const Text('Đăng Xuất'),
//                 style: OutlinedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 32,
//                     vertical: 12,
//                   ),
//                   foregroundColor: Colors.red,
//                   side: const BorderSide(color: Colors.red),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow({
//     required IconData icon,
//     required String label,
//     required String value,
//   }) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(icon, size: 20, color: Colors.grey),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: const TextStyle(fontSize: 12, color: Colors.grey),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   String _formatDate(DateTime date) {
//     return '${date.day}/${date.month}/${date.year}';
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'profile_screen.dart';
import 'email_verification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService();
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = _authService.currentUser;
  }

  Future<void> _handleLogout() async {
    // Hiển thị dialog xác nhận
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đăng Xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Đăng Xuất'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _authService.signOut();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đã đăng xuất'),
              backgroundColor: Colors.green,
            ),
          );
        }
        // StreamBuilder sẽ tự động chuyển về LoginScreen
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang Chủ'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              ).then((_) {
                // Refresh user data khi quay lại
                setState(() {
                  _user = _authService.currentUser;
                });
              });
            },
            tooltip: 'Chỉnh sửa thông tin',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: 'Đăng xuất',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar
              CircleAvatar(
                radius: 60,
                backgroundColor: Theme.of(
                  context,
                ).primaryColor.withOpacity(0.2),
                backgroundImage: _user?.photoURL != null
                    ? NetworkImage(_user!.photoURL!)
                    : null,
                child: _user?.photoURL == null
                    ? Icon(
                        Icons.person,
                        size: 60,
                        color: Theme.of(context).primaryColor,
                      )
                    : null,
              ),
              const SizedBox(height: 32),

              // Welcome Text
              Text(
                _user?.displayName != null
                    ? 'Chào ${_user!.displayName}!'
                    : 'Chào mừng!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // User Info Card
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thông Tin Tài Khoản',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(height: 24),

                      // Display Name
                      if (_user?.displayName != null)
                        _buildInfoRow(
                          icon: Icons.person,
                          label: 'Tên hiển thị',
                          value: _user!.displayName!,
                        ),
                      if (_user?.displayName != null)
                        const SizedBox(height: 12),

                      // Email
                      _buildInfoRow(
                        icon: Icons.email,
                        label: 'Email',
                        value: _user?.email ?? 'N/A',
                      ),
                      const SizedBox(height: 12),

                      // User ID
                      _buildInfoRow(
                        icon: Icons.fingerprint,
                        label: 'User ID',
                        value: _user?.uid ?? 'N/A',
                      ),
                      const SizedBox(height: 12),

                      // Email Verified
                      _buildInfoRow(
                        icon: Icons.verified_user,
                        label: 'Email đã xác thực',
                        value: _user?.emailVerified == true ? 'Có' : 'Chưa',
                      ),
                      const SizedBox(height: 12),

                      // Provider
                      _buildInfoRow(
                        icon: Icons.security,
                        label: 'Phương thức đăng nhập',
                        value: _getProviderName(),
                      ),
                      const SizedBox(height: 12),

                      // Creation Time
                      if (_user?.metadata.creationTime != null)
                        _buildInfoRow(
                          icon: Icons.calendar_today,
                          label: 'Ngày tạo',
                          value: _formatDate(_user!.metadata.creationTime!),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Email Verification Warning
              if (_user?.emailVerified == false &&
                  _user?.providerData.any(
                        (info) => info.providerId == 'password',
                      ) ==
                      true)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber, color: Colors.orange),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Email chưa xác thực',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const EmailVerificationScreen(),
                                  ),
                                ).then((_) {
                                  setState(() {
                                    _user = _authService.currentUser;
                                  });
                                });
                              },
                              child: const Text(
                                'Nhấn để xác thực ngay',
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 32),

              // Verify Email Button (nếu chưa verified)
              if (_user?.emailVerified == false &&
                  _user?.providerData.any(
                        (info) => info.providerId == 'password',
                      ) ==
                      true)
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EmailVerificationScreen(),
                      ),
                    ).then((_) {
                      setState(() {
                        _user = _authService.currentUser;
                      });
                    });
                  },
                  icon: const Icon(Icons.mark_email_read),
                  label: const Text('Xác Thực Email'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    backgroundColor: Colors.orange,
                  ),
                ),
              if (_user?.emailVerified == false) const SizedBox(height: 12),

              // Logout Button
              OutlinedButton.icon(
                onPressed: _handleLogout,
                icon: const Icon(Icons.logout),
                label: const Text('Đăng Xuất'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getProviderName() {
    if (_user?.providerData.isEmpty ?? true) return 'N/A';

    final provider = _user!.providerData.first.providerId;
    switch (provider) {
      case 'google.com':
        return 'Google';
      case 'password':
        return 'Email/Password';
      case 'facebook.com':
        return 'Facebook';
      default:
        return provider;
    }
  }
}
