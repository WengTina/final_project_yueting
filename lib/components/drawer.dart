import 'package:flutter/material.dart';
import 'package:final_yueting/screens/settings_screen.dart';
import '../screens/hastag_list_screen.dart';
import '../screens/calendar_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDarkMode ? const Color.fromARGB(255, 236, 234, 164) : Colors.black;
    final iconColor = textColor;
    final backgroundColor = Theme.of(context).colorScheme.surface;

    return Drawer(
      backgroundColor: backgroundColor,
      child: Column(
        children: [
          DrawerHeader(
            child: Center(
              child: Icon(
                Icons.music_note,
                size: 40,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 25),
            child: ListTile(
              title: Text(
                'H o m e',
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              ),
              leading: Icon(Icons.home, color: iconColor),
              onTap: () => Navigator.pop(context),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: ListTile(
              title: Text(
                'H A S H T A G S',
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              ),
              leading: Icon(Icons.tag, color: iconColor),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => const HashtagListScreen(), 
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: ListTile(
              title: Text(
                'S E T T I N G S',
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              ),
              leading: Icon(Icons.settings, color: iconColor),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: ListTile(
              title: Text(
                'C A L E N D A R',
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              ),
              leading: Icon(Icons.calendar_month, color: iconColor),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  MusicDumpScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
