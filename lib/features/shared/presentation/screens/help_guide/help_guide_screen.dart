import 'package:care_link/features/shared/presentation/widgets/forms/help_request_form.dart';
import 'package:care_link/features/shared/presentation/widgets/tiles/line_dot_title.dart';
import 'package:flutter/material.dart';

class HelpGuideScreen extends StatelessWidget {
  const HelpGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          LineDotTitle(title: 'Help'),
          SizedBox(height: 16),
          Center(child: HelpRequestForm()),
        ],
      ),
    );
  }
}
