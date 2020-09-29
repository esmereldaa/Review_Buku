 import 'dart:async';
 import 'package:cloud_firestore/cloud_firestore.dart';
 import 'package:firebase_auth/firebase_auth.dart';

 class crudMethods {
   bool isLoggedIn(){
     if (FirebaseAuth.instance.currentUser() != null){
       return true;
     } else {
       return false;
     }
   }

   Future<void> addData(dataComment) async{
     if (isLoggedIn()){
      // Firestore.instance.collection('comment').add(dataComment).catchError((e){
       //  print(e);
       //});
      
      Firestore.instance.runTransaction((Transaction crudTransaction) async {
        CollectionReference reference = await Firestore.instance.collection('comment');

        reference.add(dataComment);
      });
     } else {
       print('Loggin');
     }
   }
   Future<void> addDataFav(dataFavorite) async{
     if (isLoggedIn()){
      Firestore.instance.runTransaction((Transaction crudTransaction) async {
        CollectionReference reference = await Firestore.instance.collection('favorit');

        reference.add(dataFavorite);
      });
     } else {
       print('Loggin');
     }
   }
   Future<void> addDataAsk(dataAsk) async{
     if (isLoggedIn()){
      Firestore.instance.runTransaction((Transaction crudTransaction) async {
        CollectionReference reference = await Firestore.instance.collection('ask');

        reference.add(dataAsk);
      });
     } else {
       print('Loggin');
     }
   }
   Future<void> addDataAnswr(dataAnswr) async{
     if (isLoggedIn()){
      Firestore.instance.runTransaction((Transaction crudTransaction) async {
        CollectionReference reference = await Firestore.instance.collection('answer');

        reference.add(dataAnswr);
      });
     } else {
       print('Loggin');
     }
   }

   getData() async {
     return await Firestore.instance.collection('comment').getDocuments();
   }
 }