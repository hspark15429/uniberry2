import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uniberry/core/utils/core_utils.dart';

class AnnouncementItem extends StatelessWidget {
  const AnnouncementItem({
    required this.imagePath,
    required this.title,
    super.key,
    this.link,
  });
  final String imagePath;
  final String title;
  final String? link;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: imagePath,
              width: 60,
              height: 60,
              errorWidget: (context, error, stackTrace) {
                return const Icon(Icons.error);
              },
            ),
            Text(title),
          ],
        ),
      ),
      onTap: () async {
        if (link != null) {
          await CoreUtils.launchWebpage(Uri.parse(link!)).catchError((e) {});
        }
      },
    );
  }
}
