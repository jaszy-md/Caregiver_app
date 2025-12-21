import 'package:care_link/features/caregiver/presentation/widgets/dialogs/clear_notifications_dialog.dart';
import 'package:flutter/material.dart';

class NotificationTitleTile extends StatelessWidget {
  final String label;
  final Future<void> Function() onClearAll;

  const NotificationTitleTile({
    super.key,
    required this.label,
    required this.onClearAll,
  });

  void _openDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => ClearNotificationsDialog(
            onConfirm: () async {
              await onClearAll();
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: SizedBox(
        width: double.infinity, // 🔒 voorkomt her-layout
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            height: 50,
            padding: const EdgeInsets.only(left: 20, right: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF008F9D),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              border: Border(
                top: BorderSide(color: Color(0xFF00282C), width: 2),
                right: BorderSide(color: Color(0xFF00282C), width: 2),
                bottom: BorderSide(color: Color(0xFF00282C), width: 2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min, // visueel identiek
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _openDialog(context),
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
