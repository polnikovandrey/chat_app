import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String? _userEmail;
  String? _userName;
  String? _userPassword;
  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    key: const ValueKey('email'),
                    validator: (value) => value == null || value.isEmpty || !value.contains('@') ? 'Please enter a valid email address.' : null,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email Address'),
                    onSaved: (value) => _userEmail = value,
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('username'),
                      validator: (value) => value == null || value.isEmpty || value.length < 4 ? 'Please enter a valid username (min 4 characters).' : null,
                      decoration: const InputDecoration(labelText: 'Username'),
                      onSaved: (value) => _userName = value,
                    ),
                  TextFormField(
                    key: const ValueKey('password'),
                    validator: (value) => value == null || value.isEmpty || value.length < 7 ? 'Please enter a valid password (min 7 characters).' : null,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onSaved: (value) => _userPassword = value,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _trySubmit,
                    child: _isLogin ? const Text('Login') : const Text('Signup'),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _isLogin = !_isLogin),
                    child: _isLogin ? const Text('Create New Account') : const Text('I have an account already'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _trySubmit() {
    final formCurrentState = _formKey.currentState;
    if (formCurrentState != null && formCurrentState.validate()) {
      FocusScope.of(context).unfocus();
      formCurrentState.save();
      print(_userEmail);
      print(_userName);
      print(_userPassword);
    }
  }
}
