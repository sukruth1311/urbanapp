import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  String getNameFromEmail(String email) {
    return email.split('@').first;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(17, 138, 178, 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person, size: 80, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    user != null
                        ? getNameFromEmail(user!.email ?? 'No mail')
                        : 'No mail',
                    // user?.email. ?? 'No Email',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // ListTile(
            //   leading: Icon(Icons.payment),
            //   title: Text('Payments'),
            //   onTap: () {},
            // ),
            // ListTile(
            //   leading: Icon(Icons.card_giftcard),
            //   title: Text('Refer and Earn'),
            //   onTap: () {},
            // ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {},
            ),
            // ListTile(
            //   leading: Icon(Icons.history),
            //   title: Text('History'),
            //   onTap: () {},
            // ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Help'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log Out'),
              onTap: signUserOut,
            ),
          ],
        ),
      ),
      body: Text("data"),
    );
  }
}
