import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harmonymusic/ui/theme.dart';
import 'package:harmonymusic/ui/widgets/glass_container.dart';
import 'package:ionicons/ionicons.dart';

import '../player_controller.dart';
import 'backgroud_image.dart';
import 'new_lyrics_view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:harmonymusic/ui/widgets/add_to_playlist.dart';
import 'package:harmonymusic/ui/widgets/songinfo_bottom_sheet.dart';

class NewStandardPlayer extends StatelessWidget {
  const NewStandardPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final PlayerController playerController = Get.find<PlayerController>();

    return Stack(
      children: [
        // 1. Full Screen Blurred Background
        BackgroudImage(
          key: Key("${playerController.currentSong.value?.id}_background"),
          cacheHeight: 200,
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            color: Colors.black.withOpacity(0.6),
          ),
        ),

        // 2. Main Content
        SafeArea(
          child: Obx(() {
            if (playerController.playerViewMode.value == 1) {
              return Column(
                children: [
                  _buildTopBar(playerController),
                  const Expanded(child: NewLyricsView()),
                  _buildBottomTabs(playerController),
                ],
              );
            }

            // Main Player View - No Scrolling, Everything Fits
            return Column(
              children: [
                // Top Bar
                _buildTopBar(playerController),

                // Album Art - Flexible size
                Expanded(
                  flex: 5,
                  child: Center(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Calculate max size that fits
                        final maxSize =
                            constraints.maxHeight < constraints.maxWidth
                                ? constraints.maxHeight * 0.95
                                : constraints.maxWidth * 0.75;
                        return GestureDetector(
                          onTap: () {
                            playerController.playerViewMode.value = 1;
                          },
                          child: Container(
                            height: maxSize,
                            width: maxSize,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                )
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CachedNetworkImage(
                                imageUrl: playerController
                                        .currentSong.value?.artUri
                                        .toString() ??
                                    "",
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) => Container(
                                  color: AppColors.cardColor,
                                  child: const Icon(Icons.music_note,
                                      size: 80, color: Colors.white24),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Song Info
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        playerController.currentSong.value?.title ??
                            "Unknown Title",
                        style: AppTextStyles.header.copyWith(fontSize: 22),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        playerController.currentSong.value?.artist ??
                            "Unknown Artist",
                        style: AppTextStyles.body
                            .copyWith(fontSize: 15, color: Colors.white70),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Action Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GlassContainer(
                    height: 50,
                    width: size.width * 0.85,
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                    opacity: 0.1,
                    blur: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Obx(() => Icon(
                                playerController.isCurrentSongFav.isTrue
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: playerController.isCurrentSongFav.isTrue
                                    ? Colors.red
                                    : Colors.white,
                                size: 22,
                              )),
                          onPressed: playerController.toggleFavourite,
                        ),
                        IconButton(
                            icon: const Icon(Icons.bookmark_border,
                                color: Colors.white, size: 22),
                            onPressed: () {
                              final song = playerController.currentSong.value;
                              if (song != null) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AddToPlaylist([song]),
                                ).whenComplete(() =>
                                    Get.delete<AddToPlaylistController>());
                              }
                            }),
                        IconButton(
                            icon: const Icon(Icons.share_outlined,
                                color: Colors.white, size: 22),
                            onPressed: () {
                              final song = playerController.currentSong.value;
                              if (song != null) {
                                Share.share(
                                    "https://youtube.com/watch?v=${song.id}");
                              }
                            }),
                        IconButton(
                            icon: const Icon(Icons.download_outlined,
                                color: Colors.white, size: 22),
                            onPressed: () {
                              final song = playerController.currentSong.value;
                              if (song != null) {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(15)),
                                  ),
                                  builder: (context) => SongInfoBottomSheet(
                                      song,
                                      calledFromPlayer: true),
                                );
                              }
                            }),
                        IconButton(
                            icon: const Icon(Icons.more_horiz,
                                color: Colors.white, size: 22),
                            onPressed: () {
                              final song = playerController.currentSong.value;
                              if (song != null) {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(15)),
                                  ),
                                  builder: (context) => SongInfoBottomSheet(
                                      song,
                                      calledFromPlayer: true),
                                );
                              }
                            }),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Progress Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: GetX<PlayerController>(builder: (controller) {
                    return ProgressBar(
                      progress: controller.progressBarStatus.value.current,
                      total: controller.progressBarStatus.value.total,
                      buffered: controller.progressBarStatus.value.buffered,
                      thumbRadius: 6,
                      barHeight: 4,
                      baseBarColor: Colors.white24,
                      bufferedBarColor: Colors.white38,
                      progressBarColor: Colors.white,
                      thumbColor: Colors.white,
                      timeLabelTextStyle:
                          AppTextStyles.caption.copyWith(color: Colors.white70),
                      onSeek: controller.seek,
                    );
                  }),
                ),

                const SizedBox(height: 10),

                // Playback Controls - Always Visible
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Obx(() => Icon(
                            Ionicons.shuffle,
                            color: playerController.isShuffleModeEnabled.isTrue
                                ? AppColors.accent
                                : Colors.white,
                          )),
                      onPressed: playerController.toggleShuffleMode,
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_previous_rounded,
                          color: Colors.white, size: 35),
                      onPressed: playerController.prev,
                    ),
                    Container(
                      height: 65,
                      width: 65,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: IconButton(
                        icon: Obx(() => Icon(
                            playerController.buttonState.value ==
                                    PlayButtonState.playing
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: Colors.black,
                            size: 38)),
                        onPressed: playerController.playPause,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next_rounded,
                          color: Colors.white, size: 35),
                      onPressed: playerController.next,
                    ),
                    IconButton(
                      icon: Obx(() => Icon(
                            Icons.repeat_rounded,
                            color: playerController.isLoopModeEnabled.isTrue
                                ? AppColors.accent
                                : Colors.white,
                          )),
                      onPressed: playerController.toggleLoopMode,
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Bottom Tabs
                _buildBottomTabs(playerController),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _buildTopBar(PlayerController playerController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down,
                size: 30, color: Colors.white),
            onPressed: playerController.playerPanelController.close,
          ),
          const SizedBox(width: 30),
        ],
      ),
    );
  }

  Widget _buildBottomTabs(PlayerController playerController) {
    return Container(
      padding: const EdgeInsets.only(bottom: 15, top: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.3),
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Up arrow indicator
          Icon(Icons.keyboard_arrow_up, color: Colors.white54, size: 24),
          const SizedBox(height: 8),
          // Tabs
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _BottomTabItem(
                      icon: Icons.queue_music_rounded,
                      label: "Next",
                      isActive: playerController.playerViewMode.value == 0,
                      onTap: () {
                        playerController.playerViewMode.value = 0;
                      }),
                  _BottomTabItem(
                      icon: Icons.lyrics_rounded,
                      label: "Lyrics",
                      isActive: playerController.playerViewMode.value == 1,
                      onTap: () {
                        playerController.playerViewMode.value = 1;
                      }),
                  _BottomTabItem(
                      icon: Icons.music_note_rounded,
                      label: "Related",
                      isActive: playerController.playerViewMode.value == 2,
                      onTap: () {
                        playerController.playerViewMode.value = 2;
                      }),
                ],
              )),
        ],
      ),
    );
  }
}

class _BottomTabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  const _BottomTabItem(
      {super.key,
      required this.icon,
      required this.label,
      required this.onTap,
      this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? Colors.white : Colors.white54),
          const SizedBox(height: 4),
          Text(label,
              style: AppTextStyles.caption
                  .copyWith(color: isActive ? Colors.white : Colors.white54)),
        ],
      ),
    );
  }
}
