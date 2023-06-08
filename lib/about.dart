import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: <Widget>[
          const Text('Align Button to the Bottom in Flutter'),
          const Text('Align Button to the Bottom in Flutter'),
          const Text('Align Button to the Bottom in Flutter'),
          const Text('Align Button to the Bottom in Flutter'),
          const Text('Align Button to the Bottom in Flutter'),
          const Text('Align Button to the Bottom in Flutter'),
          const Text('Align Button to the Bottom in Flutter'),
          const Text('Align Button to the Bottom in Flutter'),
          const Text('Align Button to the Bottom in Flutter'),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Bottom Button!'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Bottom Button!'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Bottom Button!'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Bottom Button!'),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Bottom Button!'),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
