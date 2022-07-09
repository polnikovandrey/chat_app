import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) _consumePickedImage;

  const UserImagePicker({required void Function(File pickedImage) consumePickedImage, Key? key})
      : _consumePickedImage = consumePickedImage,
        super(key: key);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: _pickedImage == null ? null : FileImage(_pickedImage!),
        ),
        TextButton.icon(onPressed: _pickImage, icon: const Icon(Icons.image), label: const Text('Add Image')),
      ],
    );
  }

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() => _pickedImage = File(pickedImage.path));
      widget._consumePickedImage(_pickedImage!);
    }
  }
}