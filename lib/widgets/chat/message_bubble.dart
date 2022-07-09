import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String _username;
  final String _userImage;
  final String _message;
  final bool _isMe;

  const MessageBubble({required String username, required String userImage, required String message, required bool isMe, Key? key})
      : _username = username,
        _userImage = userImage,
        _message = message,
        _isMe = isMe,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisAlignment: _isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: _isMe ? Colors.grey[300] : Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: _isMe ? const Radius.circular(12) : const Radius.circular(0),
                  bottomRight: _isMe ? const Radius.circular(0) : const Radius.circular(12),
                ),
              ),
              width: 140,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                crossAxisAlignment: _isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    _username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _isMe ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  Text(
                    _message,
                    style: TextStyle(
                      color: _isMe ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSecondary,
                    ),
                    textAlign: _isMe ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          left: _isMe ? null : 120,
          right: _isMe ? 120 : null,
          child: CircleAvatar(backgroundImage: NetworkImage(_userImage),),
        ),
      ],
    );
  }
}
