import 'dart:io';

import 'package:chat_app/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function({required BuildContext ctx, required String email, required String password, required bool isLogin, String? username, File? userImage}) _submitAuthForm;
  final bool _isLoading;

  const AuthForm(
      void Function({required BuildContext ctx, required String email, required String password, required bool isLogin, String? username, File? userImage}) submitAuthForm,
      bool isLoading,
      {Key? key})
      : _submitAuthForm = submitAuthForm,
        _isLoading = isLoading,
        super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  bool _isLogin = true;
  File? _userImageFile;

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
                  if (!_isLogin) UserImagePicker(consumePickedImage: _consumeImage),
                  TextFormField(
                    key: const ValueKey('email'),
                    validator: (value) => value == null || value.isEmpty || !value.contains('@') ? 'Please enter a valid email address.' : null,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email Address'),
                    onSaved: (value) => _userEmail = value ?? '',
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('username'),
                      validator: (value) => value == null || value.isEmpty || value.length < 4 ? 'Please enter a valid username (min 4 characters).' : null,
                      decoration: const InputDecoration(labelText: 'Username'),
                      onSaved: (value) => _userName = value ?? '',
                    ),
                  TextFormField(
                    key: const ValueKey('password'),
                    validator: (value) => value == null || value.isEmpty || value.length < 7 ? 'Please enter a valid password (min 7 characters).' : null,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onSaved: (value) => _userPassword = value ?? '',
                  ),
                  const SizedBox(height: 12),
                  if (widget._isLoading) const CircularProgressIndicator(),
                  if (!widget._isLoading)
                    ElevatedButton(
                      onPressed: _trySubmit,
                      child: _isLogin ? const Text('Login') : const Text('Signup'),
                    ),
                  if (!widget._isLoading)
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
    FocusScope.of(context).unfocus();
    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Please take an image'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
    } else if (formCurrentState != null && formCurrentState.validate()) {
      formCurrentState.save();
      widget._submitAuthForm(ctx: context, email: _userEmail, password: _userPassword, isLogin: _isLogin, username: _userName, userImage: _userImageFile);
    }
  }

  void _consumeImage(File image) {
    _userImageFile = image;
  }
}
