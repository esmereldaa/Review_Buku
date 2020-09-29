import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyTask extends StatefulWidget{
  MyTask({this.user,this.googleSignIn});
  final FirebaseUser user;
  final GoogleSignIn googleSignIn;
  @override
  _MyTaskState createState() => new _MyTaskState();
}

class _MyTaskState extends State<MyTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream : Firestore.instance.collection('comment').snapshots(),
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData) return new Container(child: Center(
            child: CircularProgressIndicator(),
          ),);
          return new DList();
    }
      )
    );
  }
}
class DList extends StatelessWidget{
  DList({this.document});
  final List<DocumentSnapshot> document;
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: document.length,
      itemBuilder: (BuildContext context, int i){
        String nama = document[i].data['Nama'].toString();
        String isi = document[i].data['isi'].toString();
      
        return new Padding(
          padding: const EdgeInsets.all(8.0),
          child:Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(nama,style: new TextStyle(fontSize: 20.0, letterSpacing: 1.0),),
              Text(isi,style: new TextStyle(fontSize: 20.0, letterSpacing: 1.0),),
            ],
          ),
        ) ,
        );
      }
    );
  }
}
