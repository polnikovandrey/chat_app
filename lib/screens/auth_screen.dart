import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }

  void _submitAuthForm({required BuildContext ctx, required String email, required String username, required String password, required bool isLogin}) async {
    setState(() => _isLoading = true);
    final UserCredential userCredential;
    try {
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        var user = userCredential.user;
        if (user != null) {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({'username': username, 'email': email});
        }
      }
    } on FirebaseAuthException catch(exception) {
      _showSnackbarMessage(ctx, exception.message);
    } on PlatformException catch(exception) {
      _showSnackbarMessage(ctx, exception.message);
    } catch(exception) {
      print(exception);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackbarMessage(BuildContext ctx, String? exceptionMessage) {
    final message = exceptionMessage ?? 'An error occurred, please check your credentials';
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      backgroundColor: Theme.of(ctx).errorColor,
      content: Text(message),
    ));
  }
}
