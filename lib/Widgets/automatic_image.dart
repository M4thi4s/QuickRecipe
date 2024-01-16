import 'dart:io';
import 'package:flutter/material.dart';

class AutomaticImage extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;
  final BoxFit fit;

  const AutomaticImage({super.key, 
    required this.imagePath,
    this.width = 150.0,
    this.height = 150.0,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    // Vérifie si le chemin de l'image est un URL de réseau
    bool isNetworkImage = imagePath.startsWith('http://') || imagePath.startsWith('https://');

    if (isNetworkImage) {
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: fit,
      );
    } else {
      return Image.file(
        File(imagePath),
        width: width,
        height: height,
        fit: fit,
      );
    }
  }
}
