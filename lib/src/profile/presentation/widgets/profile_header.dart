import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uniberry2/core/providers/user_provider.dart';
import 'package:uniberry2/core/res/colours.dart';
import 'package:uniberry2/core/res/res.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Consumer<UserProvider>(
      builder: (_, provider, __) {
        final image = provider.user?.profilePic == null ||
                provider.user!.profilePic!.isEmpty
            ? null
            : provider.user!.profilePic;
        return Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: image != null
                  ? NetworkImage(image)
                  : const AssetImage(Res.user) as ImageProvider,
            ),
            const SizedBox(height: 16),
            Text(
              provider.user?.fullName ?? 'No User',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
            if (provider.user?.bio != null &&
                provider.user!.bio!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * .15),
                child: Text(
                  provider.user!.bio!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Colours.neutralTextColour,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}