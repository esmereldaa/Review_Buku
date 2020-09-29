import 'package:flutter/material.dart';

class Credit extends StatefulWidget {

  @override
  _Credit createState() => _Credit();
}

class _Credit extends State<Credit> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Credit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(35.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                  padding: const EdgeInsets.all(1.0),
                  child:  Image(
                  image: AssetImage('img/logo.png'),
                ),
            ),
            Text('Gunakan untuk Menemukan buku berdasarkan saran.'),
            Text('Terima Kasih')
          ],
        ),
      ),
    );
  }
}