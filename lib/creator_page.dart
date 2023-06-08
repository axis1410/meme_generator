// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meme_generator/shared/styles/icon_button_style.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'shared/widgets/custom_icon_button.dart';
import 'shared/widgets/custom_text_field.dart';
// import 'package:dio/dio.dart';

class CreatorPage extends StatefulWidget {
  const CreatorPage({super.key});

  @override
  State<CreatorPage> createState() => _CreatorPageState();
}

class _CreatorPageState extends State<CreatorPage> {
  File? _image;
  final TextEditingController _topTextController = TextEditingController();
  final TextEditingController _bottomTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  if (_image == null) ...[
                    const Center(
                      child: Text(
                        'Please select an image',
                        style: TextStyle(color: Colors.redAccent, fontSize: 32),
                      ),
                    ),
                    const SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: () async {
                        await _askPermission();
                        final image = await _pickImage();
                        setState(() {
                          _image = image;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.indigoAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                      child: const Text('Pick Image'),
                    ),
                  ] else ...[
                    CustomTextField(
                      controller: _topTextController,
                      decoration: InputDecoration(
                        labelText: 'Top Text',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Image.file(_image!),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _topTextController,
                      decoration: InputDecoration(
                        labelText: 'Bottom Text',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 80),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomIconButton(
                          decoration: iconButtonDecoration,
                          onPressed: () async {
                            await _askPermission();
                            final image = await _pickImage();
                            setState(() {
                              _image = image;
                            });
                          },
                          child: const Icon(Icons.add_circle_outline_rounded),
                        ),
                        CustomIconButton(
                          decoration: iconButtonDecoration,
                          onPressed: () async {
                            final meme = await _generateMeme(
                              _image!,
                              _topTextController.text,
                              _bottomTextController.text,
                            );

                            try {
                              await _saveMeme(meme);
                            } catch (e) {
                              print(e.toString());
                            }
                          },
                          child: const Icon(Icons.save_alt_rounded),
                        ),
                        CustomIconButton(
                          decoration: iconButtonDecoration,
                          onPressed: _deleteImage,
                          child: const Icon(Icons.delete_outline_rounded),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _deleteImage() {
    setState(() {
      _image = null;
    });
  }

  Future<void> _askPermission() async {
    var status = await Permission.photos.status;
    if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
      status = await Permission.photos.request();
    }
  }

  Future<File> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return File(pickedFile!.path);
  }

  Future<void> _saveMeme(File meme) async {
    final result = await ImageGallerySaver.saveFile(meme.path);
    print('Saved meme to gallery: $result');
  }

  Future<File> _generateMeme(File imageFile, String topText, String bottomText) async {
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

  Future<ui.Image> loadImage(File file) async {
    final data = await file.readAsBytes();
    final codec = await ui.instantiateImageCodec(data);
    final frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }
}
