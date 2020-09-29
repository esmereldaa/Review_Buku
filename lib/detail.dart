import 'package:cloud_firestore/cloud_firestore.dart';
import 'data.dart';
import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'services/crud.dart';

final _saved = new Set<Buku>();

class Detail extends StatelessWidget {
  final Buku buku;
  final String email;
  Detail(this.buku, {this.email});
  final _biggerFont = const TextStyle(fontSize: 18.0);
  get alreadySaved => _saved.contains(buku);
  crudMethods crudObj = new crudMethods();

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      elevation: .5,
      title: Text('Detail'),
      actions: <Widget>[
        IconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.pink,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    final tiles = _saved.map(
                      (buku) {
                        return new ListTile(
                          title: new Text(
                            buku.judul,
                            style: _biggerFont,
                          ),
                        );
                      },
                    );
                    final divided = ListTile.divideTiles(
                      context: context,
                      tiles: tiles,
                    ).toList();

                    return new Scaffold(
                      appBar: new AppBar(
                        title: new Text('Favorite'),
                      ),
                      body: new ListView(children: divided),
                    );
                  },
                ),
              );
            })
      ],
    );

    final topLeft = Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Hero(
            tag: buku.judul,
            child: Material(
              elevation: 15.0,
              shadowColor: Colors.orangeAccent.shade700,
              child: Image(
                image: AssetImage(buku.gambar),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        text('${buku.halaman} halaman', color: Colors.black38, size: 12)
      ],
    );

    final topRight = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        text(buku.judul,
            color: Colors.white,
            size: 16,
            isBold: true,
            padding: EdgeInsets.only(top: 16.0)),
        text(
          '${buku.penulis} | ${buku.jenis}',
          color: Colors.white,
          size: 12,
          padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
        ),
        SizedBox(height: 50),
        Row(
          children: <Widget>[
            Material(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.blue,
              shadowColor: Colors.black,
              elevation: 5.0,
              child: MaterialButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashboardPage(
                                  judul: '${buku.judul}',
                                  emailUser: this.email,
                                )));
                  },
                  minWidth: 140,
                  child: text(
                    'Lihat Komentar',
                    color: Colors.white,
                    size: 13,
                  )),
            ),
            SizedBox(
              width: 10,
            ),
            Material(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.pink,
              shadowColor: Colors.pink.shade200,
              elevation: 5.0,
              child: MaterialButton(
                onPressed: () {
                  if (alreadySaved) {
                    _saved.remove(buku);
                  } else {
                    _saved.add(buku);
                  }
                  return new ListTile(
                      title: new Text(
                    buku.judul,
                    style: _biggerFont,
                  ));
                },
                minWidth: 30,
                child: new Icon(
                  alreadySaved ? Icons.favorite : Icons.favorite_border,
                  color: alreadySaved ? Colors.white : null,
                ),
              ),
            ),
          ],
        )
      ],
    );

    final topContent = Container(
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            flex: 2,
            child: topLeft,
          ),
          Flexible(
            flex: 3,
            child: topRight,
          ),
        ],
      ),
    );

    final bottomContent = Container(
      height: 220.0,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          '${buku.sinopsis}',
          style: TextStyle(fontSize: 13, height: 1.5),
        ),
      ),
    );

    return Scaffold(
        appBar: appBar,
        body: Column(
          children: <Widget>[topContent, bottomContent],
        ));
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
  getData() async {
    return await Firestore.instance
        .collection('favorit')
        .where('email', isEqualTo: this.email)
        .getDocuments();
  }
}
