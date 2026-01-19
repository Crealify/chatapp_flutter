// ignore_for_file: use_build_context_synchronously
import 'package:chatapp_flutter/auth/screen/google_login_screen.dart';
import 'package:chatapp_flutter/auth/screen/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../chat/screen/app_home_screen.dart';
import '../../core/utils/snackbar.dart';
import '../../my_button.dart';
import '../../route.dart';
import '../service/auth_provider.dart';
import '../service/auth_service.dart';

class UserLoginScreen extends ConsumerWidget {
  const UserLoginScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double height = MediaQuery.of(context).size.height;
    final formState = ref.watch(authFormProvider);
    final formNotifer = ref.read(authFormProvider.notifier);
    final authMethod = ref.read(authMethodProvider);
    void login() async {
      formNotifer.setLoading(true);
      final res = await authMethod.loginUser(
        email: formState.email,
        password: formState.password,
      );
      formNotifer.setLoading(false);
      if (res == "success") {
        NavigationHelper.pushReplacement(context, MainHomeScreen());
        // mySnackBar(message: "Successful Login.", context: context);
        showAppSnackbar(
          context: context,
          type: SnackbarType.success,
          description: "Successful Login",
        );
      } else {
        showAppSnackbar(
          context: context,
          type: SnackbarType.error,
          description: res,
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              SizedBox(
                // height: height / 3.1,
                height: height / 2.5,
                width: double.maxFinite,
                child: Image.asset(
                  "assets/images/message_image.avif",
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Divider(thickness: 1),
                    TextField(
                      autocorrect: false,
                      onChanged: (value) => formNotifer.updateEmail(value),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: "Enter your email",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(15),
                        errorText: formState.emailError,
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      autocorrect: false,
                      onChanged: (value) => formNotifer.updatePassword(value),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: formState.isPasswordHidden,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        labelText: "Enter your password",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(15),
                        errorText: formState.passwordError,
                        suffixIcon: IconButton(
                          onPressed: () =>
                              formNotifer.togglePasswordVisibility(),
                          icon: Icon(
                            formState.isPasswordHidden
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    formState.isLoading
                        ? Center(child: CircularProgressIndicator())
                        : MyButton(
                            onTab: formState.isFormValid ? login : null,
                            buttonText: "Login",
                          ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Container(height: 1, color: Colors.black26),
                        ),
                        Text(" or "),
                        Expanded(
                          child: Container(height: 1, color: Colors.black26),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),

                    // for google auth
                    GoogleSignInButton(),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Spacer(),

                        Text("Don't have an account? "),
                        GestureDetector(
                          onTap: () {
                            NavigationHelper.push(context, SignupScreen());
                          },
                          child: Text(
                            "SignUp",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
