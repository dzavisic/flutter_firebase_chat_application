import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_application/src/components/login.component.dart';
import 'package:flutter_firebase_chat_application/src/components/register.component.dart';
import 'package:flutter_firebase_chat_application/src/shared/widgets/verticalSpacing.widget.dart';
import 'package:flutter_firebase_chat_application/src/shared/widgets/wave.widget.dart';
import 'package:wave/config.dart';

class LandingComponent extends StatefulWidget {
  const LandingComponent({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LandingComponent> createState() => _LandingComponentState();
}

class _LandingComponentState extends State<LandingComponent> {

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          waveAndTitle(),
          verticalSpacing(20),
          getStartedButton(),
          verticalSpacing(10),
          loginButton(),
        ],
      ),
    );
  }

  Widget waveAndTitle() {
    return Stack(
      children: [
        waveAnimation(
          height: MediaQuery.of(context).size.height / 2 + 150,
          context: context,
          config: animationConfig,
        ),
        Column(
          children: [
            verticalSpacing(200),
            welcomeToCodeVerification(),
          ],
        )
      ],
    );
  }

  Widget getStartedButton() {
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width - 60,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.orange[400],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const RegisterComponent(title: 'Register form'),
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
      },
    );
  }

  Widget loginButton() {
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width - 60,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              'Log In',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const LoginComponent(title: 'Login form'),
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
      },
    );
  }

  Widget colorBall(Color? color, double size, double paddingRight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: size,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
        ),
        SizedBox(
          width: paddingRight,
        ),
      ],
    );
  }

  Widget welcomeToCodeVerification() {
    return Column(
      children: [
        Row(
          children: const [
            SizedBox(
              width: 30,
            ),
            Text(
              'Welcome to',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: const [
            SizedBox(
              width: 30,
            ),
            Text(
              'EXAMPLE APP',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
