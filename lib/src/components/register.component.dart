import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_application/src/services/firebase.service.dart';
import 'package:flutter_firebase_chat_application/src/shared/consts/countries.dart';
import 'package:flutter_firebase_chat_application/src/shared/widgets/verticalSpacing.widget.dart';
import 'package:flutter_firebase_chat_application/src/shared/widgets/wave.widget.dart';
import 'package:wave/config.dart';

class RegisterComponent extends StatefulWidget {
  const RegisterComponent({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<RegisterComponent> createState() => _RegisterComponentState();
}

class _RegisterComponentState extends State<RegisterComponent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _phoneKey = GlobalKey<FormState>();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController countryFlagController = TextEditingController(text: 'US');
  final TextEditingController verificationId = TextEditingController();
  String selectValue = 'US';
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
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    phoneNumberController.text = '+1';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            waveBackInfo(),
            form(),
            verticalSpacing(10),
            hintForCode(),
            verticalSpacing(10),
            phoneNumberInput(),
            verticalSpacing(80),
            sendCodeButton(),
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
              'Information',
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
          verticalSpacing(15),
          firstNameInput(),
          verticalSpacing(15),
          lastNameInput(),
          verticalSpacing(15),
          emailInput(),
        ],
      ),
    );
  }

  Widget firstNameInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: firstNameController,
        decoration: InputDecoration(
          labelText: 'First Name',
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
            return 'Please enter your first name';
          }
          return null;
        },
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget lastNameInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: lastNameController,
        decoration: InputDecoration(
          labelText: 'Last Name',
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
            return 'Please enter your last name';
          }
          return null;
        },
        keyboardType: TextInputType.text,
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
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  Widget hintForCode() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Text(
            'Phone number',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget phoneNumberInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        key: _phoneKey,
        child: Column(
          children: [
            TextFormField(
              controller: phoneNumberController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.only(left: 10, bottom: 20, top: 10),
                  prefix: SizedBox(
                    width: 70,
                    height: 40,
                    child: DropdownButton<String>(
                      value: selectValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectValue = newValue!;
                          countryFlagController.text = newValue;
                        });
                      },
                      underline: Container(
                        height: 0,
                      ),
                      menuMaxHeight: 300,
                      items: COUNTRIES
                          .map<DropdownMenuItem<String>>((Map<String, dynamic> value) {
                        return DropdownMenuItem<String>(
                          value: value['code'],
                          onTap: () {
                            for (Map<String, dynamic> country in COUNTRIES) {
                              if (country['code'] == value['code']) {
                                phoneNumberController.text = country['dial_code'];
                                break;
                              }
                            }
                          },
                          child: SizedBox(
                              width: 40,
                              height: 40,
                              child: Image.asset('assets/flags/${value['code'].toString().toLowerCase()}.png')
                          ),
                        );
                      }).toList(),
                    ),
                  )
              ),
              style: const TextStyle(
                  fontSize: 20
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }

  Widget sendCodeButton() {
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
              'Send Code',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],

        ),
      ),
      onTap: () {
        if (_formKey.currentState!.validate() && _phoneKey.currentState!.validate()) {
          _firebaseService.verifyPhoneNumber(
              phoneNumberController,
              firstNameController,
              lastNameController,
              emailController,
              verificationId,
              context
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('SMS Code sent'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please fill every field'),
            ),
          );
        }
      },
    );
  }

}
