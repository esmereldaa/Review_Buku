import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:log/home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(hintText: 'masukan email'),
            onChanged: (value) {
              this.email = value;
            },
          ),
          SizedBox(
            height: 10.0,
          ),
          TextField(
            decoration: InputDecoration(hintText: 'password'),
            onChanged: (value) {
              this.password = value;
            },
            obscureText: true,
          ),
          SizedBox(height: 10.0),
          RaisedButton(
            onPressed: () {
              FirebaseAuth.instance
                  .signInWithEmailAndPassword(
                      email: this.email, password: this.password)
                  .then((signedInUser) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Home(
                              emailUsr: email,
                            )));
              }).catchError((e) {
                print(e);
              });
            },
            color: Colors.blue,
            child: Text('LOGIN'),
            textColor: Colors.white,
          )
        ],
      ),
    );
  }
}
