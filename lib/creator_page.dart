// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meme_generator/models/meme_generator.dart';
import 'package:meme_generator/shared/styles/icon_button_style.dart';

import 'shared/widgets/custom_icon_button.dart';
import 'shared/widgets/custom_text_field.dart';

class CreatorPage extends StatefulWidget {
  const CreatorPage({super.key});

  @override
  State<CreatorPage> createState() => _CreatorPageState();
}

class _CreatorPageState extends State<CreatorPage> {
  File? _image;
  final TextEditingController _topTextController = TextEditingController();
  final TextEditingController _bottomTextController = TextEditingController();

  final memeGenerator = MemeGenerator();

  @override
  void dispose() {
    super.dispose();
    _topTextController.dispose();
    _bottomTextController.dispose();
  }

  void _deleteImage() {
    setState(() {
      _image = null;
      _topTextController.clear();
      _bottomTextController.clear();
    });
  }

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
                        await memeGenerator.askPermission();
                        final image = await memeGenerator.pickImage();
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
                      controller: _bottomTextController,
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
                            await memeGenerator.askPermission();
                            final image = await memeGenerator.pickImage();
                            setState(() {
                              _image = image;
                            });
                          },
                          child: const Icon(Icons.add_circle_outline_rounded),
                        ),
                        CustomIconButton(
                          decoration: iconButtonDecoration,
                          onPressed: () async {
                            final meme = await memeGenerator.generateMeme(
                              _image!,
                              _topTextController.text,
                              _bottomTextController.text,
                            );

                            await memeGenerator.saveMeme(meme, (success, message) {
                              // Show a SnackBar with the result of the save operation
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(success ? message : 'Error: $message'),
                                ),
                              );
                            });
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
}
