import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user;
  int counter = 0;

  @override
  void initState() {
    super.initState();
    loadCounterValue();
  }

  void loadCounterValue() async {
    user = auth.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await firestore.collection('users').doc(user!.uid).get();
      if (userData.exists) {
        setState(() {
          counter = userData['counter'] ?? 0;
        });
      }
    }
  }

  void _incrementCounter() async {
    setState(() {
      counter++;
    });
    if (user != null) {
      await firestore.collection('users').doc(user!.uid).set({
        'counter': counter,
      }, SetOptions(merge: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              auth.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current Value: $counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}
