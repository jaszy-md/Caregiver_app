import 'package:care_link/core/utils/dialog_utils.dart';
import 'package:care_link/features/network_check/state/network_status_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NetworkListener extends StatefulWidget {
  final Widget child;
  const NetworkListener({super.key, required this.child});

  @override
  State<NetworkListener> createState() => _NetworkListenerState();
}

class _NetworkListenerState extends State<NetworkListener> {
  bool dialogOpen = false;

  @override
  Widget build(BuildContext context) {
    final isOnline = context.watch<NetworkStatusNotifier>().isOnline;

    if (!isOnline && !dialogOpen) {
      dialogOpen = true;

      Future.microtask(() async {
        await showCareLinkErrorDialog(
          context,
          title: 'Geen verbinding',
          message:
              'Je verbinding is verbroken. Controleer je internet en probeer opnieuw.',
        );

        dialogOpen = false;
      });
    }

    return widget.child;
  }
}
