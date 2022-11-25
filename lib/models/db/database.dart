import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final db = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;

class UserAuth {
  Future<User?> signup(
      String email, String password, String displayName) async {
    return await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((userCred) async {
      await userCred.user?.updateDisplayName(displayName);
      return userCred.user;
    });
  }

  Future<User?> login(String email, String password) async {
    return await auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((userCred) async {
      return userCred.user;
    });
  }

  Future<void> logout() async {
    return await auth.signOut();
  }
}

class AddDocument {
  String collectionId;
  AddDocument(this.collectionId);
  Future<String> addDocument(String? docID, Map<String, dynamic> data) async {
    if (docID == null) {
      final collRef = db.collection(collectionId);
      return await collRef.add(data).then((value) => value.id);
    } else {
      final docRef = db.collection(collectionId).doc(docID);
      return await docRef.set(data).then((value) => docRef.id);
    }
  }
}

class GetCollection {
  late final collectionRef;
  GetCollection(String collectionID, List<List<String>> queries) {
    collectionRef = db.collection(collectionID);
    for (var query in queries) {
      collectionRef = collectionRef.where(query.toList());
    }
  }
  // Future<List<Object>> getDocuments() async {
  //   return await 
  // }
}
