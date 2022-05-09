import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_application/src/components/code_verification.component.dart';

class FirebaseService {
  relevantSearch(String query) {
    return FirebaseFunctions.instance.httpsCallable('relevantSearch')({
      'query': query
    }).then((value) {
      return value.data;
    });
  }

  User? getUserAuth() {
    return FirebaseAuth.instance.currentUser;
  }

  Future<Reference> getStorageFile(String path) async {
    return FirebaseStorage.instance.ref().child(path);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(String collection, String document) {
    return FirebaseFirestore.instance.collection(collection).doc(document).get();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getDocumentChanges(String collection, String document) {
    return FirebaseFirestore.instance.collection(collection).doc(document).snapshots();
  }

  Future<QuerySnapshot> getCollection(String collection) {
    return FirebaseFirestore.instance.collection(collection).get();
  }

  Future<void> setDocument(String collection, String document, Map<String, dynamic> data) {
    return FirebaseFirestore.instance.collection(collection).doc(document).set(data, SetOptions(merge: true));
  }

  Future<void> deleteDocument(String collection, String document) {
    return FirebaseFirestore.instance.collection(collection).doc(document).delete();
  }

  Future<void> updateDocument(String collection, String document, Map<String, dynamic> data) {
    return FirebaseFirestore.instance.collection(collection).doc(document).update(data);
  }

  Future<void> addDocument(String collection, Map<String, dynamic> data) {
    return FirebaseFirestore.instance.collection(collection).add(data);
  }

  Future<UserCredential> signIn(String email, String password) {
    return FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() {
    return FirebaseAuth.instance.signOut();
  }

  Future<void> signUp(String email, String password) {
    return FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> sendPasswordResetEmail(String email) {
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<void> updateUserPassword(String password) {
    return FirebaseAuth.instance.currentUser!.updatePassword(password);
  }

  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) {
    return FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signInWithCredential(AuthCredential credential) {
    return FirebaseAuth.instance.signInWithCredential(credential);
  }

  UploadTask uploadFile(String path, String fileName, File file) {
    return FirebaseStorage.instance.ref().child(path).child(fileName).putFile(file);
  }

  Future verifyPhoneNumber(
      TextEditingController phoneNumberController,
      TextEditingController firstNameController,
      TextEditingController lastNameController,
      TextEditingController emailController,
      TextEditingController verificationID,
      BuildContext context,
      ) {
    return FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumberController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {

      },
      verificationFailed: (FirebaseAuthException verificationFailed) async {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(verificationFailed.message!),
          ),
        );
      },
      codeSent: (String verificationId, int? resendingToken) async {
        verificationID.text = verificationId;
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => CodeVerificationComponent(
                phoneNumber: phoneNumberController.text,
                firstNameController: firstNameController,
                lastNameController: lastNameController,
                emailController: emailController,
                verificationID: verificationID,
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
      },
      codeAutoRetrievalTimeout: (String verificationId) async {

      },
    );
  }

  FirebaseService();
}

