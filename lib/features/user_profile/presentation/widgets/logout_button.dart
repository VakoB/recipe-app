import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onPressed;
  const LogoutButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
          onPressed();
        },
        icon: const Icon(Icons.logout, size: 16, color: Color(0xFFD85A30)),
        label: const Text(
          'Log out',
          style: TextStyle(
            color: Color(0xFFD85A30),
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFF0997B), width: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          minimumSize: const Size.fromHeight(44),
        ),
      ),
    );
  }
}
