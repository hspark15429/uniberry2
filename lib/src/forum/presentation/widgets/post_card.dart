import 'package:any_link_preview/any_link_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:uniberry/src/forum/domain/entities/post.dart';
import 'package:uniberry/src/forum/presentation/views/post_details_view.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    required this.post,
    super.key,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, PostDetailsView.id, arguments: post);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            if (post.type == 'text')
              Text(
                post.content!,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              )
            else if (post.type == 'image')
              CachedNetworkImage(
                imageUrl: post.content!,
                fit: BoxFit.cover,
                errorWidget: (context, error, stackTrace) {
                  return const Icon(Icons.error);
                },
              )
            else if (post.type == 'link')
              AnyLinkPreview(
                link: post.link!,
                displayDirection: UIDirection.uiDirectionHorizontal,
                showMultimedia: true,
                bodyMaxLines: 5,
                bodyTextOverflow: TextOverflow.ellipsis,
                titleStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                bodyStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                errorBody: '내용 미리보기가 없습니다.',
                errorTitle: '제목 미리보기가 없습니다.',
                errorWidget: Container(
                  color: Colors.grey[300],
                  child: Text('Oops!'),
                ),
                errorImage: "https://google.com/",
                cache: Duration(days: 7),
                backgroundColor: Colors.grey[300],
                borderRadius: 12,
                removeElevation: false,
                boxShadow: [BoxShadow(blurRadius: 3, color: Colors.grey)],
                // onTap: () {}, // This disables tap event
              ),
            Row(
              children: [
                const Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                Text(
                  '${post.author}#${post.uid.trim().substring(0, 5)}',
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                ),
                const Spacer(),
                const SizedBox(width: 8),
                const Icon(
                  IconlyBold.chat,
                  color: Colors.green,
                ),
                const SizedBox(width: 4),
                Text(
                  post.commentCount.toString(),
                  style: const TextStyle(fontSize: 14, color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
