import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:care_link/gen/assets.gen.dart';
import 'package:care_link/core/riverpod_providers/user_providers.dart';

class CaregiverIdScreen extends ConsumerStatefulWidget {
  const CaregiverIdScreen({super.key});

  @override
  ConsumerState<CaregiverIdScreen> createState() => _CaregiverIdScreenState();
}

class _CaregiverIdScreenState extends ConsumerState<CaregiverIdScreen> {
  bool copied = false;

  void handleCopy(String text) {
    Clipboard.setData(ClipboardData(text: text));

    setState(() {
      copied = true;
    });

    // Na 10 seconden terug naar copy icoon
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          copied = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userDocAsync = ref.watch(userDocProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    final double imageWidth = screenWidth * 0.75;
    final double imageHeight = imageWidth * 1.3;

    return userDocAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (data) {
        final name = data?['name'] ?? '';
        final userID = data?['userID'] ?? '------';

        return Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: imageWidth,
            height: imageHeight,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Assets.images.caregiverId.image(
                    fit: BoxFit.contain,
                    alignment: Alignment.topCenter,
                  ),
                ),

                Positioned(
                  right: imageWidth * 0.22,
                  bottom: imageHeight * 0.13,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: imageWidth * 0.09),
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w300,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),

                      Padding(
                        padding: EdgeInsets.only(left: imageWidth * 0.09),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              userID,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 6),

                            GestureDetector(
                              onTap: () => handleCopy(userID),
                              child: Icon(
                                copied ? Icons.check : Icons.copy,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
