import 'package:flutter/material.dart';
import 'package:uniberry/core/utils/core_utils.dart';

class AdvertisementItem extends StatelessWidget {
  const AdvertisementItem({
    required this.imagePath,
    super.key,
    this.link,
    required this.title,
    required this.author,
  });

  final String imagePath;
  final String? link;
  final String title;
  final String author;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (link != null) {
          await CoreUtils.launchWebpage(Uri.parse(link!)).catchError((e) {});
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 14), // 제목과 사진 사이에 약간의 거리 추가
            Container(
              height: 330,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: NetworkImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16), // 사진과 게시자 사이에 약간의 거리 추가
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.verified,
                    color: Colors.deepPurpleAccent,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    author,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
