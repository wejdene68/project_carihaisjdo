// lib/services/firebase_services.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crohn/screens/navigations/usermodel.dart';

class FirebaseServices {
  Future<void> storeData(UserModel usermodel, String uid) async {
    final FirebaseFirestore service = FirebaseFirestore.instance;
    await service.collection("users").doc(uid).set(usermodel.toMap());
  }

  Future<Map<String, dynamic>> getData(String uid) async {
    final FirebaseFirestore service = FirebaseFirestore.instance;
    final snapshot = await service.collection("users").doc(uid).get();
    return snapshot.data()!;
  }
}
