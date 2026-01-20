import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:harmonymusic/models/album.dart';
import 'package:harmonymusic/models/playlist.dart';
import 'package:harmonymusic/ui/theme.dart';

class TrendingSection extends StatelessWidget {
  final String title;
  final List<dynamic> contentList; // List of Album or Playlist

  const TrendingSection({
    super.key,
    required this.title,
    required this.contentList,
  });

  @override
  Widget build(BuildContext context) {
    if (contentList.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Text(title, style: AppTextStyles.title),
        ),
        SizedBox(
          height: 150,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: contentList.length,
            separatorBuilder: (c, i) => const SizedBox(width: 15),
            itemBuilder: (context, index) {
              final item = contentList[index];
              String title = "";
              String subtitle = "";
              String imageUrl = "";

              if (item is Album) {
                title = item.title;
                subtitle = item.artists?.map((e) => e["name"]).join(", ") ??
                    "Unknown Artist";
                imageUrl = item.thumbnailUrl;
              } else if (item is Playlist) {
                title = item.title;
                subtitle =
                    "Playlist"; // Playlist model might typically vary, simplistic here
                imageUrl = item.thumbnailUrl;
              }

              return SizedBox(
                width: 130,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorWidget: (context, url, error) => Container(
                            color: AppColors.cardColor,
                            child: const Icon(Icons.music_note,
                                color: Colors.white24, size: 40),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      title,
                      style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: AppColors.accent),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      subtitle,
                      style: AppTextStyles.caption.copyWith(fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
