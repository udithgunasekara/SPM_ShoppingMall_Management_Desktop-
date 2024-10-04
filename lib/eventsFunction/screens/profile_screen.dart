import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://www.example.com/profile-pic.jpg'), // Replace with actual image URL or asset
            ),
            SizedBox(height: 20),

            // Name
            Text(
              'John Doe',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            // Email
            Text(
              'johndoe@example.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 20),

            // Edit Profile Button
            ElevatedButton(
              onPressed: () {
                // Add your edit profile functionality here
                print('Edit Profile button pressed');
              },
              child: Text('Edit Profile'),
            ),

            // Logout Button
            ElevatedButton(
              onPressed: () {
                // Add your logout functionality here
                print('Logout button pressed');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red, // Use 'backgroundColor' instead of 'primary'
              ),
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
