import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QrScannerDialog extends StatefulWidget {
  const QrScannerDialog({super.key});

  @override
  State<QrScannerDialog> createState() => _QrScannerDialogState();
}

class _QrScannerDialogState extends State<QrScannerDialog> {
  bool _isProcessing = false;
  String _statusMessage = "Scan uw QR-code";
  Color _statusColor = Colors.white;

  Future<void> _handleScan(String sensorId) async {
    if (_isProcessing) return;
    _isProcessing = true;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Navigator.pop(context);
      return;
    }

    if (!sensorId.startsWith("sensor_")) {
      setState(() {
        _statusMessage = "Ongeldige QR-code";
        _statusColor = const Color(0xFFFF6B6B);
      });

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _statusMessage = "Scan uw QR-code";
            _statusColor = Colors.white;
          });
        }
      });

      _isProcessing = false;
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'sensorId': sensorId,
        'sensorConnectedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      setState(() {
        _statusMessage = "Ketting gekoppeld ✓";
        _statusColor = Colors.greenAccent;
      });

      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) Navigator.pop(context);
      });
    } catch (e) {
      setState(() {
        _statusMessage = "Fout bij koppelen";
        _statusColor = const Color(0xFFFF6B6B);
      });

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _statusMessage = "Scan uw QR-code";
            _statusColor = Colors.white;
          });
        }
      });

      _isProcessing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.only(
        left: 0,
        right: 0,
        top: 120,
        bottom: 120,
      ),

      child: GestureDetector(
        onTap: () {},
        child: Container(
          width: width,
          height: 390,
          padding: const EdgeInsets.only(bottom: 10),

          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 0, 25, 28),
            borderRadius: BorderRadius.zero,

            border: Border(
              bottom: BorderSide(
                color: Color.fromARGB(255, 255, 255, 255),
                width: 3,
              ),
            ),
          ),

          child: Column(
            children: [
              Expanded(
                child: MobileScanner(
                  onDetect: (capture) {
                    final barcode = capture.barcodes.first;
                    final value = barcode.rawValue;
                    if (value != null) _handleScan(value);
                  },
                ),
              ),

              Container(width: double.infinity, height: 2, color: Colors.white),

              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: TextStyle(
                    color: _statusColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  child: Text(_statusMessage),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
