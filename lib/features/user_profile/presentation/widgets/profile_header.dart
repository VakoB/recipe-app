import 'package:flutter/material.dart';
import '../../domain/entities/user_profile.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfile profile;
  final int favoritesCount;

  const ProfileHeader({
    super.key,
    required this.profile,
    required this.favoritesCount,
  });

  @override
  Widget build(BuildContext context) {
    final initials = profile.username.trim().isEmpty
        ? '?'
        : profile.username
              .trim()
              .split(' ')
              .map((s) => s[0])
              .take(2)
              .join()
              .toUpperCase();

    final monthsActive =
        DateTime.now().difference(profile.createdAt).inDays ~/ 30;

    return Column(
      children: [
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF3DE),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              initials,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w500,
                color: Color(0xFF3B6D11),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          profile.username,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 2),
        Text(
          profile.email,
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Stat(value: '$favoritesCount', label: 'Favorites'),
            const SizedBox(width: 28),
            _Stat(
              value: monthsActive < 1 ? '<1' : '$monthsActive',
              label: 'Months active',
            ),
          ],
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
