// import 'package:flutter/material.dart';

// class TimeoutNotificationDialog extends StatelessWidget {
//   const TimeoutNotificationDialog({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       insetPadding: const EdgeInsets.symmetric(horizontal: 50),
//       child: Container(
//         padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
//         decoration: BoxDecoration(
//           color: const Color(0xFFCAE7EA),
//           borderRadius: BorderRadius.circular(18),
//           border: Border.all(color: const Color(0xFF0A5C60), width: 4),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black26,
//               blurRadius: 14,
//               offset: Offset(0, 6),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: const [
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.pause_circle, size: 22, color: Color(0xFF003F43)),
//                 SizedBox(width: 8),
//                 Text(
//                   'Time-out',
//                   style: TextStyle(
//                     fontFamily: 'Poppins',
//                     fontSize: 17,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF003F43),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Er zijn meerdere meldingen achter elkaar verstuurd.\n\n'
//               'U kunt over enkele minuten weer een bericht sturen.',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontFamily: 'Poppins',
//                 fontSize: 14,
//                 color: Color(0xFF003F43),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
