import 'package:chat_app/widget/Auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isloading = false;
  void _submitAuthForm(
    String email,
    String username,
    String password,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authResult;
    try {
      setState(() {
        _isloading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
      }
      FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user!.uid)
          .set({
        'username': username,
        'email': email,
      });
    } on PlatformException catch (err) {
      var messege = 'an error occured,check login credentials';
      if (err.message != null) {
        messege = err.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(messege),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
      setState(() {
        _isloading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        _submitAuthForm,_isloading,
      ),
    );
  }
}
