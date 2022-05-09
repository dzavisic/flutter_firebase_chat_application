import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_chat_application/src/components/register_password.component.dart';
import 'package:flutter_firebase_chat_application/src/services/firebase.service.dart';
import 'package:flutter_firebase_chat_application/src/shared/widgets/verticalSpacing.widget.dart';
import 'package:flutter_firebase_chat_application/src/shared/widgets/wave.widget.dart';
import 'package:wave/config.dart';

class CodeVerificationComponent extends StatefulWidget {
  const CodeVerificationComponent({
    Key? key,
    required this.phoneNumber,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.verificationID
  }) : super(key: key);

  final String phoneNumber;
  final TextEditingController? firstNameController;
  final TextEditingController? lastNameController;
  final TextEditingController? emailController;
  final TextEditingController? verificationID;
  @override
  State<CodeVerificationComponent> createState() => _CodeVerificationComponentState();
}

final TextEditingController otpController = TextEditingController();

class _CodeVerificationComponentState extends State<CodeVerificationComponent> {
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

  final TextEditingController digit1Controller = TextEditingController();
  final TextEditingController digit2Controller = TextEditingController();
  final TextEditingController digit3Controller = TextEditingController();
  final TextEditingController digit4Controller = TextEditingController();
  final TextEditingController digit5Controller = TextEditingController();
  final TextEditingController digit6Controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            waveBackInfo(),
            verticalSpacing(150),
            confirmButton(),
            verticalSpacing(10),
            resendButton(),
          ],
        ),
      ),
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
          const Icon(Icons.arrow_back_ios_new),
        ],
      ),
    );
  }

  Widget waveBackInfo() {
    return Stack(
      children: [
        waveAnimation(
          height: MediaQuery.of(context).size.height / 1.8,
          context: context,
          config: animationConfig,
        ),
        Column(
          children: [
            verticalSpacing(80),
            backButton(),
            verticalSpacing(50),
            fillInformationBelow(),
            verticalSpacing(150),
            form(),
          ],
        )
      ],
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
              'Verification code',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        verticalSpacing(15),
        Row(
          children: const [
            SizedBox(
              width: 20,
            ),
            Text(
              'We have sent the verification code to',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
        Row(
          children: [
            horizontalSpacing(20),
            Text(
              widget.phoneNumber,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            horizontalSpacing(10),
            TextButton(onPressed: () {}, child: const Text('Change phone number?', style: TextStyle(fontSize: 16, color: Colors.red),)),
          ],
        ),
      ],
    );
  }

  Widget form() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 70,
              width: 50,
              child: TextField(
                controller: digit1Controller,
                style: const TextStyle(
                  fontSize: 26,
                  color: Colors.orange,
                ),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.orange,
                      width: 1,
                    ),
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    FocusScope.of(context).nextFocus();
                  }
                },
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            SizedBox(
              height: 70,
              width: 50,
              child: TextField(
                controller: digit2Controller,
                style: const TextStyle(
                  fontSize: 26,
                  color: Colors.orange,
                ),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.orange,
                      width: 1,
                    ),
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    FocusScope.of(context).nextFocus();
                    otpController.text = otpController.text + value;
                  }
                },
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            SizedBox(
              height: 70,
              width: 50,
              child: TextField(
                controller: digit3Controller,
                style: const TextStyle(
                  fontSize: 26,
                  color: Colors.orange,
                ),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.orange,
                      width: 1,
                    ),
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    FocusScope.of(context).nextFocus();
                    otpController.text = otpController.text + value;
                  }
                },
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            SizedBox(
              height: 70,
              width: 50,
              child: TextField(
                controller: digit4Controller,
                style: const TextStyle(
                  fontSize: 26,
                  color: Colors.orange,
                ),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.orange,
                      width: 1,
                    ),
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    FocusScope.of(context).nextFocus();
                    otpController.text = otpController.text + value;
                  }
                },
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            SizedBox(
              height: 70,
              width: 50,
              child: TextField(
                controller: digit5Controller,
                style: const TextStyle(
                  fontSize: 26,
                  color: Colors.orange,
                ),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.orange,
                      width: 1,
                    ),
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    FocusScope.of(context).nextFocus();
                    otpController.text = otpController.text + value;
                  }
                },
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            SizedBox(
              height: 70,
              width: 50,
              child: TextField(
                controller: digit6Controller,
                style: const TextStyle(
                  fontSize: 26,
                  color: Colors.orange,
                ),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.orange,
                      width: 1,
                    ),
                  ),
                ),
                onChanged: (value) {
                  otpController.text = otpController.text + value;
                },
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget confirmButton() {
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
              'Confirm',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],

        ),
      ),
      onTap: () async {
        otpController.text =
            digit1Controller.text +
                digit2Controller.text +
                digit3Controller.text +
                digit4Controller.text +
                digit5Controller.text +
                digit6Controller.text;

        try {
          final AuthCredential credential = PhoneAuthProvider.credential(
            verificationId: widget.verificationID!.text,
            smsCode: otpController.text,
          );

          final UserCredential auth = await _firebaseService.signInWithCredential(credential);

          if (auth.user != null) {
            Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => RegisterPasswordComponent(
                    title: 'Create Password',
                    phoneNumber: widget.phoneNumber,
                    firstNameController: widget.firstNameController,
                    lastNameController: widget.lastNameController,
                    emailController: widget.emailController,
                    auth: auth,
                  ),
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
                  content: Text('Number verified successfully'),
                ));
          }

        } on FirebaseAuthException catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.toString()),
          ));
        }
      },
    );
  }

  /// TODO: implement functionality to resend OTP
  Widget resendButton() {
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
              'Resend',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('SMS Code sent'),
          ),
        );
      },
    );
  }
}
