// import 'package:flutter/material.dart';
// import 'package:mega_news_app/core/constants/app_const.dart';
// import 'package:mega_news_app/core/theme/app_theme_helper.dart';

// Widget buildSummaryView(
//   BuildContext context,
//   AppThemeHelper theme,
//   final topic,
//   final summary,
// ) {
//   return Scaffold(
//     appBar: AppBar(title: Text('AI Summary for "$topic"')),
//     body: SingleChildScrollView(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Center(
//             child: Icon(
//               Icons.auto_awesome_rounded,
//               size: 60,
//               color: theme.colorScheme.primary,
//             ),
//           ),
//           AppConst.h16,
//           Text(
//             'Summary for "$topic"',
//             style: theme.textTheme.headlineSmall?.copyWith(
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           AppConst.h20,
//           Text(
//             summary ?? 'No summary could be generated.',
//             style: theme.textTheme.bodyLarge?.copyWith(
//               fontSize: 16,
//               height: 1.6,
//               color: theme.colorScheme.onSurface.withOpacity(0.9),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
