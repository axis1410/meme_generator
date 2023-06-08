// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class MemeGenerator {
  Future<void> askPermission() async {
    var status = await Permission.photos.status;
    if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
      status = await Permission.photos.request();
    }
  }

  Future<File> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return File(pickedFile!.path);
  }

  Future<File> generateMeme(File imageFile, String topText, String bottomText) async {
    // Load the selected image
    final image = await loadImage(imageFile);

    // Load the custom font
    final ByteData fontData = await rootBundle.load('assets/fonts/impact.ttf');
    //  final font = ui.FontLoader('impact')..addFont(Future.value(fontData));
    await ui.loadFontFromList(fontData.buffer.asUint8List(), fontFamily: 'impact');

    // Create a ParagraphStyle and ParagraphBuilder to draw the text
    final textStyle = ui.TextStyle(
      color: Colors.white,
      fontSize: 48,
      fontFamily: 'impact',
      shadows: [
        const Shadow(color: Colors.black, blurRadius: 4, offset: Offset(2, 2)),
        const Shadow(color: Colors.black, blurRadius: 4, offset: Offset(-2, -2)),
      ],
    );
    final topParagraphStyle = ui.ParagraphStyle(textAlign: TextAlign.center);
    final topParagraphBuilder = ui.ParagraphBuilder(topParagraphStyle)
      ..pushStyle(textStyle)
      ..addText(topText);
    final topParagraph = topParagraphBuilder.build()
      ..layout(ui.ParagraphConstraints(width: image.width.toDouble()));
    final bottomParagraphStyle = ui.ParagraphStyle(textAlign: TextAlign.center);
    final bottomParagraphBuilder = ui.ParagraphBuilder(bottomParagraphStyle)
      ..pushStyle(textStyle)
      ..addText(bottomText);
    final bottomParagraph = bottomParagraphBuilder.build()
      ..layout(ui.ParagraphConstraints(width: image.width.toDouble()));

    // Create a PictureRecorder and Canvas to draw on
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(
        0,
        0,
        image.width.toDouble(),
        image.height.toDouble(),
      ),
    );

    // Draw the image on the canvas
    canvas.drawImage(image, Offset.zero, Paint());

    // Draw the top and bottom text over the image
    canvas.drawParagraph(topParagraph, const Offset(0, 20));
    canvas.drawParagraph(bottomParagraph, Offset(0, image.height - bottomParagraph.height - 20));

    // Create a new image from the PictureRecorder
    final picture = recorder.endRecording();
    final newImage = await picture.toImage(image.width, image.height);
    final pngBytes = await newImage.toByteData(format: ui.ImageByteFormat.png);

    // Compress the PNG data and save it to a temporary file
    final tempDir = await getTemporaryDirectory();
    final memePath = '${tempDir.path}/meme.png';
    final compressedBytes = await FlutterImageCompress.compressWithList(
      Uint8List.view(pngBytes!.buffer),
      format: CompressFormat.png,
      minHeight: image.height,
      minWidth: image.width,
      quality: 100,
    );
    await File(memePath).writeAsBytes(compressedBytes);

    return File(memePath);
  }

  Future<void> saveMeme(File meme, Function(bool, String) callback) async {
    try {
      final result = await ImageGallerySaver.saveFile(meme.path);
      print('Saved meme to gallery: $result');

      // Call the callback function with success status
      callback(true, 'Saved successfully!');
    } catch (e) {
      print(e.toString());

      // Call the callback function with error status and message
      callback(false, e.toString());
    }
  }

  Future<ui.Image> loadImage(File file) async {
    final data = await file.readAsBytes();
    final codec = await ui.instantiateImageCodec(data);
    final frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }
}
