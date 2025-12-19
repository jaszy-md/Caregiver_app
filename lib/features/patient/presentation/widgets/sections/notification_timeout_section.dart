import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationTimeoutSection extends StatefulWidget {
  final DateTime timeoutUntil;
  final VoidCallback onFinished;

  const NotificationTimeoutSection({
    super.key,
    required this.timeoutUntil,
    required this.onFinished,
  });

  @override
  State<NotificationTimeoutSection> createState() =>
      _NotificationTimeoutSectionState();
}

class _NotificationTimeoutSectionState
    extends State<NotificationTimeoutSection> {
  late Duration _remaining;
  Timer? _timer;
  bool _finishedCalled = false;

  @override
  void initState() {
    super.initState();
    _remaining = widget.timeoutUntil.difference(DateTime.now());
    if (_remaining.isNegative) _remaining = Duration.zero;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final diff = widget.timeoutUntil.difference(DateTime.now());

      if (diff.isNegative || diff == Duration.zero) {
        _timer?.cancel();
        if (!_finishedCalled) {
          _finishedCalled = true;
          widget.onFinished();
        }
        if (mounted) {
          setState(() => _remaining = Duration.zero);
        }
        return;
      }

      if (mounted) {
        setState(() => _remaining = diff);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _format(Duration d) {
    final totalSeconds = d.inSeconds;
    final m = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  /// ✅ EXACT dezelfde bel-logica als ConcernedNotificationDialog
  Future<void> _callEmergencyContact() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    final emergencyContact = doc.data()?['emergencyContact'];
    final phone =
        (emergencyContact is String && emergencyContact.trim().isNotEmpty)
            ? emergencyContact.trim()
            : '112';

    final uri = Uri(scheme: 'tel', path: phone);
    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    if (_remaining == Duration.zero) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
        decoration: BoxDecoration(
          color: const Color(0xFFCAE7EA),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color.fromARGB(255, 67, 6, 6),
            width: 3,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Time-out actief',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF003F43),
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.hourglass_top, size: 22, color: Color(0xFF003F43)),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              _format(_remaining),
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color(0xFF003F43),
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 14),

            const Text(
              'Deze functie is tijdelijk geblokkeerd, omdat u te veel berichten heeft gestuurd achter elkaar.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Color(0xFF003F43),
              ),
            ),

            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _callEmergencyContact,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 80, 8, 8),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.call, color: Colors.white),
                label: const Text(
                  'Bel noodcontact',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
