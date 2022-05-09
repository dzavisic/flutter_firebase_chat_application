import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_application/src/components/layout.component.dart';
import 'package:flutter_firebase_chat_application/src/services/firebase.service.dart';
import 'package:flutter_firebase_chat_application/src/shared/widgets/verticalSpacing.widget.dart';
import 'package:flutter_firebase_chat_application/src/shared/widgets/wave.widget.dart';
import 'package:wave/config.dart';

class RegisterPasswordComponent extends StatefulWidget {
  const RegisterPasswordComponent({
    Key? key,
    required this.title,
    required this.phoneNumber,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.auth
  }) : super(key: key);

  final String title;
  final String? phoneNumber;
  final TextEditingController? firstNameController;
  final TextEditingController? lastNameController;
  final TextEditingController? emailController;
  final UserCredential auth;

  @override
  State<RegisterPasswordComponent> createState() => _RegisterPasswordComponentState();
}

class _RegisterPasswordComponentState extends State<RegisterPasswordComponent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();
  Config animationConfig = CustomConfig(
    gradients: [
      [Colors.red, Color(0xEEF44336)],
      [Colors.red[800]!, Color(0x77E57373)],
      [Colors.orange, Color(0x66FF9800)],
      [Colors.yellow, Color(0x55FFEB3B)]
    ],
    durations: [35000, 19440, 10800, 6000],
    heightPercentages: [0.20, 0.23, 0.25, 0.30],
    gradientBegin: Alignment.bottomLeft,
    gradientEnd: Alignment.topRight,
  );
  late bool _passwordVisible;
  late bool _repeatPasswordVisible;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _repeatPasswordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            waveBackInfo(),
            form(),
            verticalSpacing(210),
            completeRegistrationButton(),
          ],
        ),
      ),
    );
  }

  Widget waveBackInfo() {
    return Stack(
      children: [
        waveAnimation(
          height: MediaQuery.of(context).size.height / 3,
          context: context,
          config: animationConfig,
        ),
        Column(
          children: [
            verticalSpacing(80),
            backButton(),
            verticalSpacing(150),
            fillInformationBelow(),
          ],
        )
      ],
    );
  }

  Widget backButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Row(
        children: [
          horizontalSpacing(30),
          const Icon(Icons.arrow_back_ios_new)
        ],
      ),
    );
  }

  Widget fillInformationBelow() {
    return Column(
      children: [
        Row(
          children: const [
            SizedBox(
              width: 20,
            ),
            Text(
              'Create Password',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget form() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          verticalSpacing(50),
          passwordInput(),
          verticalSpacing(20),
          repeatPasswordInput(),
        ],
      ),
    );
  }

  Widget passwordInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: passwordController,
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: const TextStyle(
            fontSize: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              _passwordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Theme.of(context).primaryColorDark,
            ),
            onPressed: () {
              // Update the state i.e. toogle the state of passwordVisible variable
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
        ),
        obscureText: !_passwordVisible,
        style: const TextStyle(
          fontSize: 20,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Password is required';
          }
          return null;
        },
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget repeatPasswordInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: repeatPasswordController,
        decoration: InputDecoration(
          labelText: 'Repeat Password',
          labelStyle: const TextStyle(
            fontSize: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _repeatPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Theme.of(context).primaryColorDark,
            ),
            onPressed: () {
              setState(() {
                _repeatPasswordVisible = !_repeatPasswordVisible;
              });
            },
          ),
        ),
        obscureText: !_repeatPasswordVisible,
        style: const TextStyle(
          fontSize: 20,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your password';
          }
          if(value != passwordController.text) {
            return 'Passwords do not match';
          }
          return null;
        },
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget completeRegistrationButton() {
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width - 60,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              'Complete Registration',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      onTap: () async {
        if (_formKey.currentState!.validate()) {
          try {

            _firebaseService.createUserWithEmailAndPassword(
                widget.emailController!.text,
                passwordController.text
            ).then((value) async {
              try {
                HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('generateUser');
                final resp = await callable.call(<String, dynamic>{
                  'uid': value.user!.uid,
                  'email': widget.emailController!.text,
                  'firstName': widget.firstNameController!.text,
                  'lastName': widget.lastNameController!.text,
                  'phone': widget.phoneNumber,
                  'photo': '',
                  'role': 'user',
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Registration completed successfully: ${resp.data}'),
                  ),
                );

              } catch (e) {
                print(e);
              }
            });

            _firebaseService.signIn(
                widget.emailController!.text,
                passwordController.text
            );

            Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => LayoutComponent(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(0.0, 1.0);
                    const end = Offset.zero;
                    const curve = Curves.ease;

                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ));

          } on FirebaseAuthException catch (e) {
            if (e.code == 'weak-password') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('The password provided is too weak.'),
                ),
              );
            } else if (e.code == 'email-already-in-use') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('The account already exists for that email.'),
                ),
              );
            }
          } catch (e) {
            print(e);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please fill all fields'),
            ),
          );
        }
      },
    );
  }

}
