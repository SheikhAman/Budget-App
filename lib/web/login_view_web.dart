import 'package:budget_app_starting/components.dart';
import 'package:budget_app_starting/view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';

class LoginViewWeb extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController _emailField = useTextEditingController();
    TextEditingController _passwordField = useTextEditingController();

    final viewModelProvider = ref.watch(viewModel);

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/login_image.png',
              width: deviceWidth / 2.6,
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: deviceHeight / 5.5,
                  ),
                  Image.asset(
                    'assets/logo.png',
                    fit: BoxFit.contain,
                    width: 200.0,
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  SizedBox(
                    width: 350,
                    //email textfield
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      controller: _emailField,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            10.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            10.0,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.black,
                          size: 30.0,
                        ),
                        hintText: 'Email',
                        hintStyle: GoogleFonts.openSans(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  //Password
                  SizedBox(
                    width: 350.0,
                    child: TextFormField(
                      controller: _passwordField,
                      obscureText: viewModelProvider.isObscure,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            10.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            10.0,
                          ),
                        ),
                        prefixIcon: IconButton(
                          onPressed: () {
                            viewModelProvider.toggleObscure();
                          },
                          icon: Icon(
                            viewModelProvider.isObscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black,
                            size: 30.0,
                          ),
                        ),
                        hintText: 'Password',
                        hintStyle: GoogleFonts.openSans(),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),

                  // Login & Register
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50.0,
                        width: 150.0,
                        child: MaterialButton(
                          onPressed: () async {
                            await viewModelProvider.createUserWithEmailPassword(
                                context, _emailField.text, _passwordField.text);
                          },
                          child: OpenSans(
                            text: 'Register',
                            size: 25.0,
                            color: Colors.white,
                          ),
                          splashColor: Colors.grey,
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Text(
                        'Or',
                        style: GoogleFonts.pacifico(
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      // Login button

                      SizedBox(
                        height: 50.0,
                        width: 150.0,
                        child: MaterialButton(
                          onPressed: () async {
                            await viewModelProvider.signInWithEmailAndPassword(
                                context, _emailField.text, _passwordField.text);
                          },
                          child: OpenSans(
                            text: 'Login',
                            size: 25.0,
                            color: Colors.white,
                          ),
                          splashColor: Colors.grey,
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  SignInButton(
                    buttonType: ButtonType.google,
                    btnColor: Colors.black,
                    btnTextColor: Colors.white,
                    buttonSize: ButtonSize.large,
                    onPressed: () async {
                      if (kIsWeb) {
                        await viewModelProvider.signInWithGoogleWeb(context);
                      } else {
                        await viewModelProvider.signInWithGoogleMobile(context);
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
