import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harmonymusic/ui/theme.dart';
import 'package:harmonymusic/ui/player/player_controller.dart';

class ListenAgainSection extends StatelessWidget {
  final List<MediaItem> songs;
  final String title;

  const ListenAgainSection({
    super.key,
    required this.songs,
    this.title = "Listen again",
  });

  @override
  Widget build(BuildContext context) {
    if (songs.isEmpty) return const SizedBox.shrink();

    // Limit to 5 items for "Listen Again" typically
    final displaySongs = songs.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.title),
              Text("More", style: AppTextStyles.caption.copyWith(fontSize: 12)),
            ],
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: displaySongs.length,
          separatorBuilder: (c, i) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final song = displaySongs[index];
            return InkWell(
              onTap: () {
                Get.find<PlayerController>().pushSongToQueue(song);
              },
              borderRadius: BorderRadius.circular(12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: song.artUri?.toString() ?? "",
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.cardColor,
                        child:
                            const Icon(Icons.music_note, color: Colors.white24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song.title,
                          style: AppTextStyles.body.copyWith(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          song.artist ?? "Unknown Artist",
                          style: AppTextStyles.caption,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert,
                        size: 20, color: AppColors.secondary),
                    onPressed: () {
                      // Show more options
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
