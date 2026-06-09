import 'package:flutter/material.dart';

class AvatarSelectionDialog extends StatelessWidget {
  final String currentAvatar;

  const AvatarSelectionDialog({super.key, required this.currentAvatar});

  // Predefined avatar list
  static const List<String> availableAvatars = [
    'avatar_1',
    'avatar_2',
    'avatar_3',
    'avatar_4',
    'avatar_5',
    'avatar_6',
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: const Text('Select Avatar', style: TextStyle(color: Colors.white)),
      content: SizedBox(
        width: 300,
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: availableAvatars.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final avatar = availableAvatars[index];
            final isSelected = avatar == currentAvatar;

            return GestureDetector(
              onTap: () => Navigator.of(context).pop(avatar),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
                    width: 3,
                  ),
                  color: Colors.black54,
                ),
                child: Center(
                  child: Icon(
                    Icons.face, // Placeholder for actual avatar assets
                    color: isSelected ? Colors.white : Colors.white54,
                    size: 32,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CANCEL'),
        ),
      ],
    );
  }
}
