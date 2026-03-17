import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final monthlyIncomeProvider = StreamProvider<double>((ref) {
  final user = FirebaseAuth.instance.currentUser;

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .snapshots()
      .map((doc) {
        final data = doc.data();
        return (data?['monthlyIncome'] ?? 0).toDouble();
      });
});
