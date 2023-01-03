import 'package:budget_app_starting/components.dart';
import 'package:budget_app_starting/view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_button/create_button.dart';
import 'package:sign_button/sign_button.dart';

class LoginViewMobile extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // hooks package theke useTextEditingContoller nilam
    TextEditingController _emailField = useTextEditingController();
    TextEditingController _passwordField = useTextEditingController();
    final viewModelProvider = ref.watch(viewModel);
    final double deviceHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: deviceHeight / 5.5,
              ),
              Image.asset(
                'assets/logo.png',
                fit: BoxFit.contain,
                width: 210.0,
              ),
              SizedBox(
                height: 30.0,
              ),
              SizedBox(
                width: 350,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  controller: _emailField,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
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
              SizedBox(
                width: 350,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  controller: _passwordField,
                  obscureText: viewModelProvider.isObscure,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
                          )),
                      hintStyle: GoogleFonts.openSans(),
                      hintText: 'Password'),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Register
                  SizedBox(
                    height: 50,
                    width: 140.0,
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
                          borderRadius: BorderRadius.circular(10.0)),
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
                  //Login button
                  SizedBox(
                    height: 50.0,
                    width: 140.0,
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
                      color: Colors.black,
                      splashColor: Colors.grey,
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
              //Google signIn
              SignInButton(
                  buttonType: ButtonType.google,
                  btnTextColor: Colors.white,
                  buttonSize: ButtonSize.medium,
                  btnColor: Colors.black,
                  onPressed: () async {
                    if (kIsWeb) {
                      await viewModelProvider.signInWithGoogleWeb(context);
                    } else {
                      await viewModelProvider.signInWithGoogleMobile(context);
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
