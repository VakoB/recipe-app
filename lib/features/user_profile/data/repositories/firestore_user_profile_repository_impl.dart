import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../models/user_profile_model.dart';

class FirestoreUserProfileRepositoryImpl implements UserProfileRepository {
  final FirebaseFirestore _firestore;

  const FirestoreUserProfileRepositoryImpl(this._firestore);

  @override
  Future<void> createProfile(UserProfile profile) async {
    final model = UserProfileModel(
      uid: profile.uid,
      username: profile.username,
      email: profile.email,
      createdAt: profile.createdAt,
    );
    await _firestore.collection('users').doc(profile.uid).set(model.toJson());
  }

  @override
  Future<UserProfile?> getProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserProfileModel.fromJson(doc.data()!);
  }
}
