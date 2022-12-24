import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

final db = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;
final storage = FirebaseStorage.instance;
final user = FirebaseAuth.instance.currentUser!;

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

  bool isLoggedIn() {
    return auth.currentUser != null;
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
  Future<List<Object>> getDocuments() async {
    return await collectionRef.get().then((QuerySnapshot querySnapshot) {
      var results = {};
      querySnapshot.docs.forEach((doc) {
        results[doc.id] = doc.data();
      });
      return results;
    });
  }
}

class UseDocument {
  late final docRef;
  UseDocument(String collectionID, String docID) {
    docRef = db.collection(collectionID).doc(docID);
  }
  Future<Map<String, dynamic>> getDocument() async {
    return await docRef.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        return documentSnapshot.data() as Map<String, dynamic>;
      } else {
        return {};
      }
    });
  }

  Future<void> updateDocument(Map<String, dynamic> data) async {
    return await docRef.update(data);
  }

  Future<void> deleteDocument() async {
    return await docRef.delete();
  }
}

class UseStorage {
  Future<String> uploadFile(String filePath, String fileName) async {
    return await storage
        .ref(filePath)
        .child(fileName)
        .putFile(File(filePath))
        .then((value) => value.ref.getDownloadURL());
  }

  Future<void> deleteFile(String filePath, String fileName) async {
    return await storage.ref(filePath).child(fileName).delete();
  }

  Future<String> downloadFile(String filePath, String fileName) async {
    final fileURL =
        await storage.ref(filePath).child(fileName).getDownloadURL();
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    File downloadToFile = File('${appDocDir.path}/$fileName');
    await FirebaseStorage.instance
        .refFromURL(fileURL)
        .writeToFile(downloadToFile);
    return downloadToFile.path;
  }
}
