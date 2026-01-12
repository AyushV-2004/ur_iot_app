import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> saveReading(String mac, Map<String, dynamic> data) async {
    final uid = _auth.currentUser!.uid;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('devices')
        .doc(mac)
        .collection('readings')
        .add({
      ...data,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
