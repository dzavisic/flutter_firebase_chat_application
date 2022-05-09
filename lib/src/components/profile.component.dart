import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_application/src/app.dart';
import 'package:flutter_firebase_chat_application/src/services/firebase.service.dart';
import 'package:flutter_firebase_chat_application/src/shared/widgets/verticalSpacing.widget.dart';
import 'package:image_picker/image_picker.dart';

class ProfileComponent extends StatefulWidget {
  const ProfileComponent({Key? key}) : super(key: key);

  @override
  State<ProfileComponent> createState() => _ProfileComponentState();
}

class _ProfileComponentState extends State<ProfileComponent> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  final FirebaseService _firebaseService = FirebaseService();
  late Map<String, dynamic> _userData;
  late ValueNotifier<bool> _passwordVisible;
  late ValueNotifier<bool> _repeatPasswordVisible;
  late File imageFile;

  @override
  void initState() {
    super.initState();
    _passwordVisible = ValueNotifier(false);
    _repeatPasswordVisible = ValueNotifier(false);
    _firebaseService.getDocument('users', _firebaseService.getUserAuth()!.uid).then((document) {
      _firstNameController.text =  document['firstName'];
      _lastNameController.text =  document['lastName'];
      _emailController.text =  document['email'];
      _phoneNumberController.text =  document['phone'];
      _passwordController.text =  '';
      _confirmPasswordController.text =  '';
      _userData = {
        'firstName': document['firstName'],
        'lastName': document['lastName'],
        'email': document['email'],
        'phone': document['phone'],
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          leading: const SizedBox.shrink(),
          actions: [
            changeThemeButton()
          ],
        ),
        floatingActionButton: floatingActionButton(),
        body: body()
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          verticalSpacing(50),
          avatar(),
          verticalSpacing(50),
          inputField('First Name', _firstNameController, false),
          verticalSpacing(10),
          inputField('Last Name', _lastNameController, false),
          verticalSpacing(10),
          inputField('Email', _emailController, false),
          verticalSpacing(10),
          inputField('Phone Number', _phoneNumberController, true),
          verticalSpacing(10),
          passwordInputField('Password', _passwordController, _passwordVisible),
          verticalSpacing(10),
          passwordInputField('Confirm Password', _confirmPasswordController, _repeatPasswordVisible),
          verticalSpacing(80),
        ],
      ),
    );
  }

  Widget avatar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            StreamBuilder(
              stream: _firebaseService.getDocumentChanges('users', _firebaseService.getUserAuth()!.uid),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasData) {
                  return CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(snapshot.data!.data()!['photo']),
                  );
                } else {
                  return const CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage('assets/img/avatar.png'),
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 110.0, top: 110.0),
              child: GestureDetector(
                onTap: _getFromGallery,
                child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.orange,
                        width: 3,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 6,
                        )
                      ],
                    ),
                    child: const Icon(Icons.add_a_photo_rounded, color: Colors.orange,)
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget inputField(String label, TextEditingController controller, bool disableEdit) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          verticalSpacing(10),
          TextField(
            controller: controller,
            enabled: !disableEdit,
            decoration: InputDecoration(
              suffix: disableEdit ? const Icon(Icons.verified, color: Colors.orange) : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget passwordInputField(String label, TextEditingController controller, ValueNotifier<bool> visibilityController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          verticalSpacing(10),
          TextField(
            controller: controller,
            obscureText: !visibilityController.value,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  visibilityController.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () {
                  visibilityController.value = !visibilityController.value;
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      String fileName = _firebaseService.getUserAuth()!.uid;
      try {
        UploadTask uploadTask = _firebaseService.uploadFile('avatar', fileName, imageFile);
        uploadTask.then((snap) {
          snap.ref.getDownloadURL().then((url) {
            setState(() {
              _firebaseService.setDocument('users', _firebaseService.getUserAuth()!.uid, { 'photo': url });
            });
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Uploaded'),
            ),
          );
        });
      } catch (e) {
        print(e);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Uploading...'),
        ),
      );

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No file was selected'),
        ),
      );
    }
  }

  Widget floatingActionButton() {
    return FloatingActionButton(
      child: const Icon(Icons.save),
      onPressed: () {
        Map<String, dynamic> changes = {};

        if (_firstNameController.text != _userData['firstName']) {
          changes['firstName'] = _firstNameController.text;
        }
        if (_lastNameController.text != _userData['lastName']) {
          changes['lastName'] = _lastNameController.text;
        }
        if (_emailController.text != _userData['email']) {
          changes['email'] = _emailController.text;
        }
        if (_phoneNumberController.text != _userData['phone']) {
          changes['phone'] = _phoneNumberController.text;
        }

        if (changes.isNotEmpty) {
          _firebaseService.setDocument('users', _firebaseService.getUserAuth()!.uid, changes).then((value) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile updated'),
                ));
          });
        }


        if (_passwordController.text != '' && _confirmPasswordController.text != '') {
          if (_passwordController.text == _confirmPasswordController.text) {
            _firebaseService.updateUserPassword(_passwordController.text);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password updated'),
                  duration: Duration(seconds: 2),
                ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Passwords do not match'),
                  duration: Duration(seconds: 2),
                ));
          }
        }
      },
    );
  }

  Widget changeThemeButton() {
    return IconButton(
        icon: Icon(MyApp.themeNotifier.value == ThemeMode.light
            ? Icons.dark_mode
            : Icons.light_mode),
        onPressed: () {
          MyApp.themeNotifier.value =
          MyApp.themeNotifier.value == ThemeMode.light
              ? ThemeMode.dark
              : ThemeMode.light;
        });
  }
}
