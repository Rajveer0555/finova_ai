import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final budgetAmountProvider = StateProvider.family<double, String>((ref, id) {
  return 0.0;
});
final budgetStreamProvider = StreamProvider<DocumentSnapshot>((ref) {
  final user = FirebaseAuth.instance.currentUser;

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .snapshots();
});
