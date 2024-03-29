import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickrecipe/Configs/Config.dart';
import 'package:quickrecipe/Widgets/automatic_image.dart';

class ImagePickerButton extends StatefulWidget {
  final Function(String) onImagePicked; // Callback pour l'image sélectionnée
  final String? existingImage; // Ajout d'un paramètre pour le chemin d'image existant

  const ImagePickerButton({Key? key, required this.onImagePicked, this.existingImage}) : super(key: key);

  @override
  _ImagePickerButtonState createState() => _ImagePickerButtonState();
}

class _ImagePickerButtonState extends State<ImagePickerButton> {
  String? _image;

  @override
  void initState() {
    super.initState();
    if (widget.existingImage != null) {
      // Initialisation de _image avec le chemin d'image existant
      _image = widget.existingImage;
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? selectedImage = await picker.pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      setState(() {
        _image = selectedImage.path;
      });
      widget.onImagePicked(selectedImage.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (_image != null) AutomaticImage(
          imagePath: _image!,
          width: 150.0,
          height: 150.0,
          fit: BoxFit.cover,
        ),
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
