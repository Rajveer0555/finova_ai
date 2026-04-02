import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final monthlyIncomeProvider = StreamProvider<double>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return Stream.value(0.0);
  }

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .map((doc) {
        final data = doc.data();
        final raw = data?['monthlyIncome'];
        if (raw is num) {
          return raw.toDouble();
        }
        return double.tryParse(raw?.toString() ?? '') ?? 0.0;
      });
});
