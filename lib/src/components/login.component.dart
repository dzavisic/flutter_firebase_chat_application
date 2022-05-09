import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_application/src/components/layout.component.dart';
import 'package:flutter_firebase_chat_application/src/services/firebase.service.dart';
import 'package:flutter_firebase_chat_application/src/shared/widgets/verticalSpacing.widget.dart';
import 'package:flutter_firebase_chat_application/src/shared/widgets/wave.widget.dart';
import 'package:wave/config.dart';

class LoginComponent extends StatefulWidget {
  const LoginComponent({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LoginComponent> createState() => _LoginComponentState();
}

class _LoginComponentState extends State<LoginComponent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            waveWithLabel(),
            form(),
            verticalSpacing(210),
            loginButton(),
          ],
        ),
      ),
    );
  }

  Widget waveWithLabel() {
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
              'Hello!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          children: const [
            SizedBox(
              width: 20,
            ),
            Text(
              'Glad to see you back',
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
          emailInput(),
          verticalSpacing(20),
          passwordInput(),
        ],
      ),
    );
  }

  Widget emailInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: emailController,
        decoration: InputDecoration(
          labelText: 'Email',
          labelStyle: const TextStyle(
            fontSize: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        style: const TextStyle(
          fontSize: 20,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your email';
          }
          if (!RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(value)) {
            return 'Please enter a valid email';
          }
          return null;
        },
        keyboardType: TextInputType.text,
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

  Widget loginButton() {
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
              'Continue',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      onTap: () async {
        if (_formKey.currentState!.validate()) {
          try {
            final userCredential = await _firebaseService.signIn(emailController.text, passwordController.text);

            if (userCredential.user != null) {
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged in successfully'),
                ),
              );
            }
          } on FirebaseAuthException catch (e) {
            if (e.code == 'user-not-found') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No user found for that email'),
                ),
              );
            } else if (e.code == 'wrong-password') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Wrong password provided for that user'),
                ),
              );
            }
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
