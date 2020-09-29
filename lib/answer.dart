import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:log/services/crud.dart';

class Answer extends StatefulWidget {
  final String emailAsk;
  final String questionID;
  final String question;
  final String questionEmail;
  Answer({this.emailAsk, this.questionID, this.question, this.questionEmail});

  @override
  _Answer createState() => _Answer();
}

class _Answer extends State<Answer> {
  QuerySnapshot answer;
  String isiJawaban;
  crudMethods crudObj = new crudMethods();

  Widget _bottomContent() {
    if (answer != null) {
      return new ListView.builder(
          itemCount: answer.documents.length,
          padding: EdgeInsets.all(5.0),
          itemBuilder: (context, i) {
            return new ListTile(
              title: Text(answer.documents[i].data['email'].toString()),
              subtitle: Text(answer.documents[i].data['jawaban'].toString()),
            );
          });
    } else {
      return new CircularProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Saran'),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                getDataAnswr().then((QuerySnapshot) {
                  setState(() {
                    answer = QuerySnapshot;
                  });
                });
              })
        ],
      ),
      body: new Stack(
        children: <Widget>[
          Container(
              height: 150.0,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.blue),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    text(widget.questionEmail,
                        color: Colors.white,
                        size: 16,
                        isBold: true,
                        padding: EdgeInsets.only(top: 16.0)),
                    text(
                      widget.question,
                      color: Colors.white,
                      size: 14,
                      padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
                    ),
                  ],
                ),
              )),
          Padding(
            padding: EdgeInsets.only(top: 160.0),
            child: _bottomContent(),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addDialog(context);
        },
        child: Icon(Icons.reply),
      ),
    );
  }

  Future<bool> addDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Tambahkan Jawaban', style: TextStyle(fontSize: 15.0)),
            content: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(hintText: 'Masukan Jawaban'),
                  onChanged: (value) {
                    this.isiJawaban = value;
                  },
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Tambah'),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                  crudObj.addDataAnswr({
                    'jawaban': this.isiJawaban,
                    'email': widget.emailAsk,
                    'askId': widget.questionID
                  }).then((result) {
                    dialogTrigger(context);
                  }).catchError((e) {
                    print(e);
                  });
                },
              )
            ],
          );
        });
  }

  Future<bool> dialogTrigger(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('jawaban anda berhasil diproses'),
            actions: <Widget>[
              FlatButton(
                child: Text('Selesai'),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  text(String data,
          {Color color = Colors.black87,
          num size = 16,
          EdgeInsetsGeometry padding = EdgeInsets.zero,
          bool isBold = false}) =>
      Padding(
          padding: padding,
          child: Text(data,
              style: TextStyle(
                  color: color,
                  fontSize: size.toDouble(),
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)));

  @override
  void initState() {
    getDataAnswr().then((QuerySnapshot) {
      setState(() {
        answer = QuerySnapshot;
      });
    });
    super.initState();
  }

  getDataAnswr() async {
    return await Firestore.instance
        .collection('answer')
        .where('askId', isEqualTo: widget.questionID)
        .getDocuments();
  }
}
