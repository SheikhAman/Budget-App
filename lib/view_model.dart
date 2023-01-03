import 'package:budget_app_starting/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:google_sign_in/google_sign_in.dart';

final viewModel = ChangeNotifierProvider.autoDispose<ViewModel>(
  (ref) => ViewModel(),
);

class ViewModel extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  // ai variable check korbe user ki sign in koreche? user signin korle value true hoye  jabe

  // firestore user collection variable
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  bool isSignedIn = false;
  bool isObscure = true;

  var logger = Logger();

  List expensesName = [];
  List expensesAmount = [];
  List incomesName = [];
  List incomesAmount = [];

// Check if Signed  In
  Future<void> isLoggedIn() async {
    //Notifies about changes to the user's sign-in state (such as sign-in or sign-out).
    await _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        isSignedIn = false;
      } else {
        isSignedIn = true;
      }
    });
    // at the end we will notify all the listeners
    notifyListeners();
  }

  toggleObscure() {
    isObscure = !isObscure;
    notifyListeners();
  }

//Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  //Authentication
  Future<void> createUserWithEmailPassword(
      BuildContext context, String email, String password) async {
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) => logger.d('Success'))
        .onError(
      (error, stackTrace) {
        logger.d('Registration error $error');
        DialogBox(
            context, error.toString().replaceAll(RegExp('\\[.*?\\]'), ''));
      },
    );
  }

  Future<void> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) => logger.d('Login Successful'))
        .onError((error, stackTrace) {
      logger.e('SignIn error $error');
      DialogBox(context, error.toString().replaceAll(RegExp('\\[.*?\\]'), ''));
    });
  }

  Future<void> signInWithGoogleWeb(BuildContext context) async {
    GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
    // signInWithPopup ar SignInWithRedirect same kaj kore
    await _auth.signInWithPopup(googleAuthProvider).onError(
        (error, stackTrace) => DialogBox(
            context, error.toString().replaceAll(RegExp('\\[.*?\\]'), '')));
    logger
        .d('Current user in not empty = ${_auth.currentUser!.uid.isNotEmpty}');
  }

  Future<void> signInWithGoogleMobile(BuildContext context) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn()
        .signIn()
        .onError((error, stackTrace) => DialogBox(
            context, error.toString().replaceAll(RegExp('\\[.*?\\]'), '')));

    final GoogleSignInAuthentication? googleAuth =
        await googleUser!.authentication;

// now we need to connect google sign in authentication with firebase authentication

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

// this line of code will connect the google sign in with the firebase auth
    await _auth.signInWithCredential(credential).then((value) {
      logger.d('Google Sign in successful');
    }).onError((error, stackTrace) {
      logger.d('Google Sign in error $error');
      DialogBox(context, error.toString().replaceAll(RegExp('\\[.*?\\]'), ''));
    });
  }

  // Database

  Future addExpense(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    TextEditingController controllerName = TextEditingController();
    TextEditingController controllerAmount = TextEditingController();
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        contentPadding: EdgeInsets.all(32.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: Form(
          key: formKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextForm(
                text: 'Name',
                containerWidth: 130.0,
                hintText: 'Name',
                controller: controllerName,
                validator: (text) {
                  if (text.toString().isEmpty) {
                    return 'Required';
                  }
                },
              ),
              SizedBox(
                width: 10.0,
              ),
              TextForm(
                text: 'Amount',
                containerWidth: 100.0,
                hintText: 'Amount',
                digitsOnly: true,
                controller: controllerAmount,
                validator: (text) {
                  if (text.toString().isEmpty) {
                    return 'Required';
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                await userCollection
                    .doc(_auth.currentUser!.uid)
                    .collection('expenses')
                    .add({
                  'name': controllerName.text,
                  'amount': controllerAmount.text,
                }).then((value) {
                  logger.d('add expense successful');
                }).onError((error, stackTrace) {
                  logger.d('add expense error = $error');
                  return DialogBox(context, error.toString());
                });
                Navigator.pop(context);
              }
            },
            child: OpenSans(
              text: 'Save',
              size: 15.0,
              color: Colors.white,
            ),
            splashColor: Colors.grey,
            color: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          )
        ],
      ),
    );
  }

  Future addIncome(BuildContext context) async {
    final formKey = GlobalKey<FormState>();

    TextEditingController controllerName = TextEditingController();
    TextEditingController controllerAmount = TextEditingController();

    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(32.0),
        elevation: 10.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(width: 1.0, color: Colors.black)),
        actionsAlignment: MainAxisAlignment.center,
        title: Form(
          key: formKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextForm(
                text: 'Name',
                containerWidth: 130.0,
                hintText: 'Name',
                controller: controllerName,
                validator: (text) {
                  if (text.toString().isEmpty) {
                    return 'Required';
                  }
                },
              ),
              SizedBox(
                width: 10.0,
              ),
              TextForm(
                text: 'Amount',
                containerWidth: 100.0,
                hintText: 'Amount',
                controller: controllerAmount,
                validator: (text) {
                  if (text.toString().isEmpty) {
                    return 'Required';
                  }
                },
                digitsOnly: true,
              ),
            ],
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                await userCollection
                    .doc(_auth.currentUser!.uid)
                    .collection('incomes')
                    .add({
                  'name': controllerName.text,
                  'amount': controllerAmount.text,
                }).then((value) {
                  logger.d('Income successful');
                }).onError((error, stackTrace) {
                  logger.d('add income error = $error');
                  return DialogBox(context, error.toString());
                });
                Navigator.pop(context);
              }
            },
            child: OpenSans(
              text: 'Save',
              size: 15.0,
              color: Colors.white,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            color: Colors.black,
            splashColor: Colors.grey,
          ),
        ],
      ),
    );
  }

  void expensesStream() async {
    await for (var snapshot in userCollection
        .doc(_auth.currentUser!.uid)
        .collection('expenses')
        .snapshots()) {
      expensesName = [];
      expensesAmount = [];
      for (var expenses in snapshot.docs) {
        expensesName.add(expenses.data()['name']);
        expensesAmount.add(expenses.data()['amount']);
        notifyListeners();
      }
    }
  }

  void incomeStream() async {
    await for (var snapshot in userCollection
        .doc(_auth.currentUser!.uid)
        .collection('incomes')
        .snapshots()) {
      // empty list nilam karon  jokhon new snapshot asbe tokhon full data r shate ager data plus hoye list e add hobe
      // tai empty list nilam jate kore new data asle akbare full data empty list e add hoi, ta na korle data repeat hoto
      incomesName = [];
      incomesAmount = [];
      for (var incomes in snapshot.docs) {
        incomesName.add(incomes.data()['name']);
        incomesAmount.add(incomes.data()['amount']);
        notifyListeners();
      }
    }
  }

  Future<void> reset() async {
    await userCollection
        .doc(_auth.currentUser!.uid)
        .collection('expenses')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
    await userCollection
        .doc(_auth.currentUser!.uid)
        .collection('incomes')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }
}
