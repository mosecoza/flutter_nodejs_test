import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NavDrawer extends StatefulWidget {
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Logout",
          ),
          content: new Text(
            "Are you sure you want to logout?",
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                //If yes, user is logged out of the app. See logout function
                _logout();
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.teal[300],
                ),
                child: Center(
                  child: Text(
                    'Yes',
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.teal[300],
                ),
                child: Center(
                  child: Text(
                    'No',
                   
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _logout() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setBool('isSignedIn', false);
    localStorage.remove('user_id');
    localStorage.remove('isSignedIn');

    if (localStorage.getBool('isSignedIn') == null) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/wrapper', (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        CustomListTile(
          Icons.history,
          'History',
          () => {
            Navigator.pushNamed(context, '/historypage'),
          },
        ),
        CustomListTile(
          Icons.lock,
          'Logout',
          () => {_showDialog()},
        ),
      ],
    );
  }
}

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onTap;
  CustomListTile(this.icon, this.text, this.onTap);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey, width: 1),
          ),
        ),
        child: InkWell(
          splashColor: Colors.orangeAccent,
          onTap: onTap(),
          child: Container(
            height: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(icon),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        text,
                       
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_right),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
