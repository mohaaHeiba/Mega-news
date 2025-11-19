import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget InfoSection(ThemeData theme, dynamic s, final user) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 8, bottom: 12),
        child: Text(
          'Account Info', // (أو s.accountInfo)
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.person_outline),
              title: Text(s.fullName),
              subtitle: Text(user.name),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            ),
            Divider(height: 1, indent: 16, endIndent: 16),
            ListTile(
              leading: Icon(Icons.email_outlined),
              title: Text(s.email),
              // [تصليح 5] شيلنا (isGuest)
              subtitle: Text(user.email),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            ),
            // [تصليح 6] شيلنا (isGuest) من الشرط
            if (user.createdAt != null) ...[
              Divider(height: 1, indent: 16, endIndent: 16),
              ListTile(
                leading: Icon(Icons.calendar_today_outlined),
                title: Text(s.memberSince),
                subtitle: Text(_formatDate(user.createdAt!)),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ],
          ],
        ),
      ),
    ],
  );
}

String _formatDate(String dateString) {
  try {
    final date = DateTime.parse(dateString);
    return '${date.day}/${date.month}/${date.year}';
  } catch (e) {
    return dateString;
  }
}
