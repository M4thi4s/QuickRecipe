import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickrecipe/Configs/Config.dart';

class ImagePickerButton extends StatefulWidget {
  final Function(String) onImagePicked; // Callback pour l'image sélectionnée

  const ImagePickerButton({Key? key, required this.onImagePicked}) : super(key: key);

  @override
  _ImagePickerButtonState createState() => _ImagePickerButtonState();
}

class _ImagePickerButtonState extends State<ImagePickerButton> {
  XFile? _image;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? selectedImage = await picker.pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      setState(() {
        _image = selectedImage;
      });
      widget.onImagePicked(selectedImage.path); // Utilisez le callback ici
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (_image != null) Image.file(File(_image!.path)),
        OutlinedButton(
          onPressed: _pickImage,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Config.primaryColor,
            ),
          child: const Text('Ajouter une image')
        ),
      ],
    );
  }
}
