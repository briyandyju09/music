import 'dart:ui';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harmonymusic/ui/player/player_controller.dart';
import 'package:harmonymusic/ui/theme.dart';

class NewMiniPlayer extends StatelessWidget {
  const NewMiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final PlayerController playerController = Get.find<PlayerController>();
    final size = MediaQuery.of(context).size;

    return Obx(() {
      return Container(
        width: size.width,
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.cardColor.withOpacity(0.85),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Stack(
                children: [
                  // Main Content
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        // Album Art
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: playerController.currentSong.value?.artUri
                                    .toString() ??
                                "",
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade800,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.music_note,
                                  color: Colors.white54, size: 24),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Song Info - Use Flexible to prevent overflow
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                playerController.currentSong.value?.title ??
                                    "Start Listening",
                                style: AppTextStyles.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                playerController.currentSong.value?.artist ??
                                    "Music",
                                style: AppTextStyles.caption.copyWith(
                                  color: Colors.white60,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Controls - Compact
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 36,
                              height: 36,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Obx(() => Icon(
                                      playerController.isCurrentSongFav.isTrue
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: playerController
                                              .isCurrentSongFav.isTrue
                                          ? Colors.red
                                          : Colors.white60,
                                      size: 22,
                                    )),
                                onPressed: playerController.toggleFavourite,
                              ),
                            ),
                            SizedBox(
                              width: 44,
                              height: 44,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Obx(() => Icon(
                                      playerController.buttonState.value ==
                                              PlayButtonState.playing
                                          ? Icons.pause_circle_filled_rounded
                                          : Icons.play_circle_fill_rounded,
                                      color: Colors.white,
                                      size: 38,
                                    )),
                                onPressed: playerController.playPause,
                              ),
                            ),
                            SizedBox(
                              width: 36,
                              height: 36,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.skip_next_rounded,
                                    color: Colors.white, size: 26),
                                onPressed: playerController.next,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Progress Bar at bottom
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 3,
                    child: GetX<PlayerController>(builder: (controller) {
                      final progress = controller
                          .progressBarStatus.value.current.inMilliseconds;
                      final total = controller
                          .progressBarStatus.value.total.inMilliseconds;
                      final percentage = total > 0 ? progress / total : 0.0;
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(20)),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: percentage,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.only(
                                bottomLeft: const Radius.circular(20),
                                bottomRight:
                                    Radius.circular(percentage > 0.95 ? 20 : 0),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
