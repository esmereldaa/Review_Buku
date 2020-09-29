import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:log/services/crud.dart';
import 'dart:async';

class DashboardPage extends StatefulWidget{
  final String judul;
  final String emailUser;
  DashboardPage({this.judul,this.emailUser});
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String isiComment;
  QuerySnapshot comment;
  crudMethods crudObj = new crudMethods();
  

  Future<bool> addDialog(BuildContext context) async{
    return showDialog(
      context:  context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tambahkan Komentar', style : TextStyle(fontSize: 15.0)),
          content: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(hintText: 'Masukan komentar'),
                onChanged: (value) {
                  this.isiComment = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Tambah'),
              textColor: Colors.blue,
              onPressed: (){
                Navigator.of(context).pop();
                crudObj.addData(
                  {
                    'isiComment' : this.isiComment,
                    'buku' : widget.judul,
                    'email' : widget.emailUser
                  }
                ).then((result) {
                  dialogTrigger(context);
                }).catchError((e){
                  print(e);
                });
              },
            )
          ],
        );
      }
    );
  }

  
  Future<bool> dialogTrigger(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Selesai'),
          actions: <Widget>[
            FlatButton(
              child: Text('Oke'),
              textColor: Colors.blue,
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
  }

  @override
  void initState() {
    getData().then((QuerySnapshot){
      setState((){
        comment = QuerySnapshot;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add),
          onPressed: (){
            addDialog(context);
          },
          ),
          IconButton(icon: Icon(Icons.refresh),
          onPressed: (){
            getData().then((QuerySnapshot){
              setState((){
                comment = QuerySnapshot;
              });
            });
          },
          ),
        ],
      ),
      body: _commentList(),
    );
  }
  Widget _commentList(){
    if (comment != null) {
        return ListView.builder( 
        itemCount: comment.documents.length,
        padding: EdgeInsets.all(5.0),
        itemBuilder: (context, i) {
          return new ListTile(
            title: Text(comment.documents[i].data['email'].toString()),
            subtitle: Text(comment.documents[i].data['isiComment'].toString()),
          );
        }
      );  
    } else {
      return CircularProgressIndicator();
    }
  }
  
   getData() async {
     return await Firestore.instance.collection('comment').where('buku',isEqualTo : widget.judul).getDocuments();
   }
}
