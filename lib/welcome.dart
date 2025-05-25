import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  void _navigateToStudentLogin(BuildContext context) {
    Navigator.pushNamed(context, '/login_screen');
  }

  @override
  Widget build(BuildContext context) {
    // Use the app's theme
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A1931), // Dark navy blue background
      appBar: AppBar(
        title: const Text('Get Started'),
        centerTitle: true,
        backgroundColor: const Color(0xFF0A1931), // Match background
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 180,
              width: 180,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset('assets/logo.png', fit: BoxFit.contain),
            ),
            const SizedBox(height: 40),
            Text(
              'Welcome to Student Marks Management',
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _navigateToStudentLogin(context),
              child: const Text('Student Sign In'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent, // Light blue
                foregroundColor: Colors.black, // Text color
                minimumSize: const Size(double.infinity, 48),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: null, // Faculty sign in left blank for now
              child: const Text('Faculty Sign In'),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.teal, // Teal background
                foregroundColor: Colors.white, // Text color
                minimumSize: const Size(double.infinity, 48),
                side: BorderSide.none,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
