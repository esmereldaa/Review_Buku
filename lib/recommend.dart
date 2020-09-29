import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:log/answer.dart';
import 'services/crud.dart';

class Recommend extends StatefulWidget {
  final String emailUser;
  Recommend({this.emailUser});

  @override
  _Recommend createState() => _Recommend();
}

class _Recommend extends State<Recommend> {
  QuerySnapshot ask;
  crudMethods crudObj = new crudMethods();
  String isiPertanyaan;
  int documentID = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Minta Rekomendasi'),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                getDataAsk().then((QuerySnapshot) {
                  setState(() {
                    ask = QuerySnapshot;
                  });
                });
              })
        ],
      ),
      body: listSuggestion(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          documentID++;
          addDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget listSuggestion() {
    if (ask != null) {
      return ListView.builder(
          itemCount: ask.documents.length,
          padding: EdgeInsets.all(5.0),
          itemBuilder: (context, i) {
            return new ListTile(
              title: Text(ask.documents[i].data['email'].toString()),
              subtitle: Text(ask.documents[i].data['pertanyaan'].toString()),
              trailing: new Material(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
                shadowColor: Colors.white,
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Answer(
                                  emailAsk: widget.emailUser,
                                  questionID:
                                      ask.documents[i].data['id'].toString(),
                                  question: ask.documents[i].data['pertanyaan']
                                      .toString(),
                                  questionEmail:
                                      ask.documents[i].data['email'].toString(),
                                )));
                  },
                  minWidth: 20,
                  child: new Icon(Icons.arrow_forward),
                ),
              ),
            );
          });
    } else {
      return CircularProgressIndicator();
    }
  }

  Future<bool> addDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title:
                Text('Tambahkan pertanyaan', style: TextStyle(fontSize: 15.0)),
            content: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(hintText: 'Masukan pertanyaan'),
                  onChanged: (value) {
                    this.isiPertanyaan = value;
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
                  crudObj.addDataAsk({
                    'pertanyaan': this.isiPertanyaan,
                    'email': widget.emailUser,
                    'id': widget.emailUser + documentID.toString()
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
            title: Text('Pertanyaan anda berhasil diproses'),
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

  @override
  void initState() {
    getDataAsk().then((QuerySnapshot) {
      setState(() {
        ask = QuerySnapshot;
      });
    });
    super.initState();
  }

  getDataAsk() async {
    return await Firestore.instance.collection('ask').getDocuments();
  }
}
