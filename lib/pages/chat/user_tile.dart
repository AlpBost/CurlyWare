import 'package:flutter/material.dart';

// This widget shows one user in the list
class UserTile extends StatelessWidget {
  // Text is the user's email
  final String text;
  final void Function()? onTap;

  const UserTile({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // GestureDetector lets us tap on the container
    return GestureDetector(
      onTap: onTap, // Call the onTap function when tapped
      child: Container(

        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),

        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),

        padding: const EdgeInsets.all(20),

        child: Row(
          children: [
            const Icon(Icons.person),
            const SizedBox(width: 20),
            Text(text.split('@').first), // Show only the name (not full email)
          ],
        ),
      ),
    );
  }
}
