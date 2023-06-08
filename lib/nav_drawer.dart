import 'package:flutter/material.dart';

import 'about.dart';
import 'creator_page.dart';
import 'home.dart';

enum DrawerSelection { home, creator, about }

class NavDrawer extends StatefulWidget {
  final DrawerSelection selected;
  const NavDrawer({super.key, required this.selected});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 102.5,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              child: Center(
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          ListTile(
            selected: widget.selected == DrawerSelection.home,
            selectedColor: Colors.indigoAccent,
            selectedTileColor: Colors.indigo.shade50,
            title: const Text('Meme of the Day'),
            leading: const Icon(Icons.home),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
          ListTile(
            selected: widget.selected == DrawerSelection.creator,
            selectedColor: Colors.indigoAccent,
            selectedTileColor: Colors.indigo.shade50,
            title: const Text('Meme Creator'),
            leading: const Icon(Icons.whatshot),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const CreatorPage()),
              );
            },
          ),
          ListTile(
            selected: widget.selected == DrawerSelection.about,
            selectedColor: Colors.indigoAccent,
            selectedTileColor: Colors.indigo.shade50,
            title: const Text('About'),
            leading: const Icon(Icons.info),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
