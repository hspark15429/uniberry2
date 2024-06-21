import 'package:flutter/material.dart';
import 'package:uniberry/core/utils/core_utils.dart';

class AdvertisementItem extends StatelessWidget {
  const AdvertisementItem({
    required this.imagePath,
    super.key,
    this.link,
  });
  final String imagePath;
  final String? link;

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
        child: Container(
          height: 200, // 고정된 높이 설정
          width: double.infinity, // 가로로 최대한 넓게 설정
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            image: DecorationImage(
              image: NetworkImage(imagePath),
              fit: BoxFit.cover, // 이미지를 카드에 꽉 차게 조정
            ),
          ),
        ),
      ),
    );
  }
}
