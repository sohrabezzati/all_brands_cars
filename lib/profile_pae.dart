import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String name;
  final String lastName;
  final String email;
  final String playStoreUrl;
  final String appDescription;

  const ProfilePage({
    super.key,
    required this.name,
    required this.lastName,
    required this.email,
    required this.playStoreUrl,
    required this.appDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CircleAvatar(
                backgroundColor:
                    Theme.of(context).colorScheme.background.withOpacity(0.5),
                radius: 50,
                backgroundImage: const AssetImage('assets/images/logos.png'),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '$name $lastName',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                email,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'All Brands Cars',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                appDescription,
                maxLines: 3,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'View on Google Play',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
