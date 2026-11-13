
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference<Map<String, dynamic>> _usersRef =
  FirebaseFirestore.instance.collection('users');


  Future<void> createUserProfile({
    required String uid,
    required String name,
    required String email,
    required String phone,
    required String avatar,
  }) {
    return _usersRef.doc(uid).set({
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> createUserProfileIfMissing({
    required String uid,
    required String name,
    required String email,
    required String avatar,
  }) async {
    final doc = await _usersRef.doc(uid).get();

    if (!doc.exists) {
      await _usersRef.doc(uid).set({
        'name': name,
        'email': email,
        'phone': '',
        'avatar': avatar,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final doc = await _usersRef.doc(uid).get();
    return doc.data();
  }

  Stream<Map<String, dynamic>?> watchUserProfile(String uid) {
    return _usersRef.doc(uid).snapshots().map(
          (doc) => doc.data(),
    );
  }


  Future<void> updateUserProfile({
    required String uid,
    String? name,
    String? phone,
    String? avatar,
  }) {
    final data = <String, dynamic>{};

    if (name != null) data['name'] = name;
    if (phone != null) data['phone'] = phone;
    if (avatar != null) data['avatar'] = avatar;

    if (data.isEmpty) return Future.value();

    return _usersRef.doc(uid).update(data);
  }

  Future<void> deleteUserProfile(String uid) {
    return _usersRef.doc(uid).delete();
  }
  Future<void> toggleFavorite(
      String uid,
      int movieId,
      bool isFavorite,
      ) {
    final favRef =
    _usersRef.doc(uid).collection('favorites').doc('$movieId');

    if (isFavorite) {
      return favRef.set({
        'movieId': movieId,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }

    return favRef.delete();
  }


  Stream<List<int>> watchFavoriteIds(String uid) {
    return _usersRef
        .doc(uid)
        .collection('favorites')
        .snapshots()
        .map(
          (snap) => snap.docs
          .map((doc) => doc['movieId'] as int)
          .toList(),
    );
  }
}
