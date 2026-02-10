import 'package:chatapp_flutter/chat/screen/app_home_screen.dart';
import 'package:flutter/material.dart';
import '../../auth/service/google_auth_service.dart';
import '../../core/utils/snackbar.dart';
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
      final userCredential = await FirebaseServices().signInWithGoogle();

      if (!mounted) return;

      // if (userCredential != null) {

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
