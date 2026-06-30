import '../entities/user_profile.dart';

abstract class UserProfileRepository {
  Future<void> createProfile(UserProfile profile);
  Future<UserProfile?> getProfile(String uid);
}
