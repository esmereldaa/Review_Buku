import 'dart:io';

import 'package:flutter/material.dart';
import 'package:log/credit.dart';
import 'package:log/detail.dart';
import 'package:log/recommend.dart';
import 'data.dart';

class Home extends StatelessWidget {
  final String emailUsr;
  Home({this.emailUsr});

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Review App'),
    );
    createTile(Buku buku) => Hero(
          tag: buku.judul,
          child: Material(
            elevation: 15.0,
            shadowColor: Colors.blue.shade900,
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Detail(
                              buku,
                              email: this.emailUsr,
                            )));
              },
              child: Image(
                image: AssetImage(buku.gambar),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
    final grid = CustomScrollView(
      primary: false,
      slivers: <Widget>[
        SliverPadding(
          padding: EdgeInsets.all(16.0),
          sliver: SliverGrid.count(
            childAspectRatio: 2 / 3,
            crossAxisCount: 3,
            mainAxisSpacing: 20.0,
            crossAxisSpacing: 20.0,
            children: bukuu.map((buku) => createTile(buku)).toList(),
          ),
        )
      ],
    );
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: appBar,
      body: grid,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(

              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child:  Image(
                image: AssetImage('img/logo.png'),
              ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Minta rekomendasi'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Recommend(
                              emailUser: this.emailUsr,
                            )));
              },
            ),
            ListTile(
              title: Text('Credit'),
              onTap: () {
               Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Credit()));
              },
            ),
            ListTile(
              title: Text('Exit'),
              onTap: () {exit(0);},
            ),
          ],
        ),
      ),
    );
  }
}
