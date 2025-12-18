import 'package:care_link/core/firestore/services/user_service.dart';
import 'package:care_link/features/shared/presentation/widgets/tiles/line_dot_title.dart';
import 'package:care_link/features/shared/presentation/widgets/tiles/week_tile.dart';
import 'package:flutter/material.dart';
import 'package:care_link/features/shared/presentation/widgets/sections/graph_section.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  Future<String> _resolveTargetUserId() async {
    final authUid = FirebaseAuth.instance.currentUser!.uid;
    print('[StatsScreen] authUid = $authUid');

    final user = await UserService().getUser(authUid);
    print('[StatsScreen] user doc = $user');

    if (user == null) {
      print('[StatsScreen] user == null, fallback authUid');
      return authUid;
    }

    final role = user['role'];
    print('[StatsScreen] role = $role');

    if (role == 'caregiver') {
      final linked = user['linkedUserIds'];
      print('[StatsScreen] linkedUserIds = $linked');

      if (linked is List && linked.isNotEmpty) {
        final first = linked.first;
        print('[StatsScreen] using patientId = $first');
        return first;
      }
    }

    print('[StatsScreen] fallback authUid');
    return authUid;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _resolveTargetUserId(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // geen loader, geen flits
          return const SizedBox();
        }

        final targetUid = snapshot.data!;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 0),
                      child: LineDotTitle(title: 'Status Check'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 0),
                      child: Transform.translate(
                        offset: const Offset(0, -5),
                        child: const WeekTile(),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: GraphSection(userId: targetUid),
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
