import 'package:chat_gpt/profile_pae.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor:
          Theme.of(context).colorScheme.background.withOpacity(0.9),
      child: ListView(padding: EdgeInsets.zero, children: [
        DrawerHeader(
          padding:
              const EdgeInsets.only(top: 25, left: 16, bottom: 16, right: 16),
          decoration: const BoxDecoration(),
          child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    alignment: Alignment.topCenter,
                    image: AssetImage('assets/images/logos.png'),
                    fit: BoxFit.fitWidth)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text(
                  'All Barnds Cars',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Version 1.0',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Home'),
          onTap: () {
            Navigator.pop(context);
            // your code here
          },
        ),
        const Divider(),
        ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfilePage(
                            appDescription:
                                'Find all spaces of all car model and brand in one place!',
                            name: 'Sohrab',
                            lastName: 'Ezzati',
                            email: 's.ezzati.30.dec.1999@gamil.com',
                            playStoreUrl:
                                'https://play.google.com/store/apps/details?id=com.sohrab.ezzati.all_brands_cars',
                          )));
            }),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          onTap: () {
            Navigator.pop(context);
            // your code here
          },
        ),
        const Divider(),
        ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help'),
            onTap: () {
              Navigator.pop(context);
            }),
      ]),
    );
  }
}
