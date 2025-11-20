import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget InfoSection(ThemeData theme, dynamic s, final user) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 8, bottom: 12),
        child: Text(
          s.account_info,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildInfoTile(
              theme,
              icon: Icons.person_outline_rounded,
              color: Colors.blue,
              title: s.fullName,
              value: user.name,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                height: 1,
                color: theme.dividerColor.withOpacity(0.1),
              ),
            ),
            _buildInfoTile(
              theme,
              icon: Icons.email_outlined,
              color: Colors.green,
              title: s.email,
              value: user.email,
            ),
            if (user.createdAt != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  height: 1,
                  color: theme.dividerColor.withOpacity(0.1),
                ),
              ),
              _buildInfoTile(
                theme,
                icon: Icons.calendar_today_rounded,
                color: Colors.orange,
                title: s.memberSince,
                value: _formatDate(user.createdAt!),
              ),
            ],
          ],
        ),
      ),
    ],
  );
}

Widget _buildInfoTile(
  ThemeData theme, {
  required IconData icon,
  required Color color,
  required String title,
  required String value,
}) {
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    leading: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 22),
    ),
    title: Text(
      title,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface.withOpacity(0.6),
      ),
    ),
    subtitle: Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        value,
        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
    ),
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
