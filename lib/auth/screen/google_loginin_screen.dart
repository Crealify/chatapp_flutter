// import 'package:chatapp_flutter/auth/service/google_auth_service.dart';
// import 'package:flutter/material.dart';
// //import 'package:your_app/services/google_signin_service.dart';
// import '../../core/utils/colors.dart';
// import '../../core/utils/snackbar.dart';

// class GoogleLoginScreen extends StatefulWidget {
//   const GoogleLoginScreen({super.key});

//   @override
//   State<GoogleLoginScreen> createState() => _GoogleLoginScreenState();
// }

// class _GoogleLoginScreenState extends State<GoogleLoginScreen> {
//   bool _isLoading = false;

//   Future<void> _signInWithGoogle() async {
//     setState(() => _isLoading = true);

//     try {
//       final userCredential = await GoogleSignInService.signInWithGoogle();

//       if (!mounted) return;

//       if (userCredential != null) {
//         // Navigate to home or chat screen
//         // NavigationHelper.pushAndRemoveUntil(context, const HomeScreen());
//       }
//     } catch (e) {
//       if (!mounted) return;

//       showAppSnackbar(
//         context: context,
//         type: SnackbarType.error,
//         description: "Google Login failed",
//       );
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: bodyColor,
//       body: Column(
//         children: [
//           SizedBox(height: 100),

//           SizedBox(height: size.height * 0.13),

//           _isLoading
//               ? const CircularProgressIndicator()
//               : SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton.icon(
//                     onPressed: _signInWithGoogle,
//                     icon: Image.network(
//                       'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/60px-Google_%22G%22_logo.svg.png?20230822192911',
//                       height: 24,
//                       width: 24,
//                     ),
//                     label: const Text(
//                       "Sign in with Google",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         color: OColors.black,
//                       ),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: appBarColor,
//                       elevation: 0,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 14,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ),
//         ],
//       ),
//     );
//   }
// }
import 'package:chatapp_flutter/chat/screen/app_home_screen.dart';
import 'package:flutter/material.dart';
import '../../auth/service/google_auth_service.dart';
import '../../core/utils/snackbar.dart';

// class GoogleLoginButton extends StatefulWidget {
//   const GoogleLoginButton({super.key});

//   @override
//   State<GoogleLoginButton> createState() => _GoogleLoginButtonState();
// }

// class _GoogleLoginButtonState extends State<GoogleLoginButton> {
//   bool _isLoading = false;

//   Future<void> _signInWithGoogle() async {
//     setState(() => _isLoading = true);

//     try {
//       final userCredential = await GoogleSignInService.signInWithGoogle();

//       if (!mounted) return;

//       if (userCredential != null) {
//         // Navigate after login
//       }
//     } catch (e) {
//       if (!mounted) return;
//       showAppSnackbar(
//         context: context,
//         type: SnackbarType.error,
//         description: "Google Login failed",
//       );
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _isLoading
//         ? const CircularProgressIndicator()
//         : SizedBox(
//             width: double.infinity,
//             child: ElevatedButton.icon(
//               onPressed: _signInWithGoogle,
//               icon: Image.network(
//                 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/60px-Google_%22G%22_logo.svg.png',
//                 height: 22,
//               ),
//               label: const Text(
//                 "Sign in with Google",
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: OColors.black,
//                 ),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: appBarColor,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                   vertical: 14,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//           );
//   }
// }

// class GoogleLoginButton extends StatefulWidget {
//   const GoogleLoginButton({super.key});

//   @override
//   State<GoogleLoginButton> createState() => _GoogleLoginButtonState();
// }

// class _GoogleLoginButtonState extends State<GoogleLoginButton> {
//   bool _isLoading = false;

//   Future<void> _signInWithGoogle() async {
//     setState(() => _isLoading = true);

//     try {
//       final userCredential = await GoogleSignInService.signInWithGoogle();

//       if (!mounted) return;

//       if (userCredential != null) {
//         // Navigate after login
//       }
//     } catch (e) {
//       if (!mounted) return;
//       showAppSnackbar(
//         context: context,
//         type: SnackbarType.error,
//         description: "Google Login failed",
//       );
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _isLoading
//         ? const CircularProgressIndicator()
//         : MyButton(
//             onTab: _signInWithGoogle,
//             buttonText: "Sign in with Google",
//             icon: Image.network(
//               'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/60px-Google_%22G%22_logo.svg.png',
//               height: 22,
//             ),
//           );
//   }
// }
// import 'package:flutter/material.dart';
// import '../../auth/service/google_auth_service.dart';
// import '../../core/utils/snackbar.dart';
import '../../core/utils/colors.dart';
import '../../route.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({super.key});

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isLoading = false;

  Future<void> _handleGoogleLogin() async {
    setState(() => _isLoading = true);

    try {
      final userCredential = await GoogleSignInService.signInWithGoogle();

      if (!mounted) return;

      // if (userCredential != null) {
      //   // TODO: Navigate to home screen
      //   NavigationHelper.pushReplacement(context, MainHomeScreen());
      // }
      if (userCredential != null) {
        NavigationHelper.pushReplacement(context, MainHomeScreen());
      }
    } catch (e) {
      if (!mounted) return;

      showAppSnackbar(
        context: context,
        type: SnackbarType.error,
        description: "Google Login failed",
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = _isLoading;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isDisabled ? null : _handleGoogleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled
              ? Colors.grey.shade400
              : Theme.of(context).primaryColor.withValues(
                  alpha: 0.8,
                ), // your Google button color
          // : appBarColor, // your Google button color
          foregroundColor: OColors.black,
          elevation: isDisabled ? 0 : 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/60px-Google_%22G%22_logo.svg.png',
                    height: 22,
                    width: 22,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Sign in with Google",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: OColors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
