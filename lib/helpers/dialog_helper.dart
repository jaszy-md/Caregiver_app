import 'package:flutter/material.dart';
import 'package:care_link/widgets/dialogs/carelink_error_dialog.dart';

Future<void> showCareLinkErrorDialog(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => CareLinkErrorDialog(title: title, message: message),
  );
}
