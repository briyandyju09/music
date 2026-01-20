import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:harmonymusic/ui/player/player_controller.dart';
import 'package:harmonymusic/ui/theme.dart';
import 'package:harmonymusic/ui/widgets/loader.dart';

class NewLyricsView extends StatefulWidget {
  const NewLyricsView({super.key});

  @override
  State<NewLyricsView> createState() => _NewLyricsViewState();
}

class _NewLyricsViewState extends State<NewLyricsView> {
  late PlayerController playerController;
  final ScrollController _scrollController = ScrollController();
  int _currentLineIndex = 0;
  List<LyricLine> _parsedLyrics = [];

  @override
  void initState() {
    super.initState();
    playerController = Get.find<PlayerController>();
    _loadLyrics();
  }

  void _loadLyrics() {
    if (playerController.lyrics['synced'].isEmpty &&
        playerController.lyrics['plainLyrics'].isEmpty &&
        playerController.isLyricsLoading.isFalse) {
      Future.microtask(() {
        playerController.showLyricsflag.value = true;
        playerController.showLyrics();
      });
    }
  }

  List<LyricLine> _parseSyncedLyrics(String lrcContent) {
    final lines = <LyricLine>[];
    final regex = RegExp(r'\[(\d{2}):(\d{2})\.(\d{2,3})\](.*)');

    for (final line in lrcContent.split('\n')) {
      final match = regex.firstMatch(line);
      if (match != null) {
        final minutes = int.parse(match.group(1)!);
        final seconds = int.parse(match.group(2)!);
        final millisStr = match.group(3)!;
        final millis = int.parse(millisStr.padRight(3, '0'));
        final text = match.group(4)?.trim() ?? '';

        if (text.isNotEmpty) {
          lines.add(LyricLine(
            timeMs: (minutes * 60 + seconds) * 1000 + millis,
            text: text,
          ));
        }
      }
    }
    return lines;
  }

  int _findCurrentLineIndex(int positionMs) {
    for (int i = _parsedLyrics.length - 1; i >= 0; i--) {
      if (positionMs >= _parsedLyrics[i].timeMs) {
        return i;
      }
    }
    return 0;
  }

  void _scrollToCurrentLine(int index) {
    if (_scrollController.hasClients && _parsedLyrics.isNotEmpty) {
      final targetOffset = index * 80.0 - 100; // Approximate line height
      _scrollController.animateTo(
        targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Lyrics Content
        Expanded(
          child: Obx(() {
            if (playerController.isLyricsLoading.isTrue) {
              return const Center(child: LoadingIndicator());
            }

            final syncedLyrics =
                playerController.lyrics['synced']?.toString() ?? '';
            final plainLyrics =
                playerController.lyrics['plainLyrics']?.toString() ?? '';

            // Parse synced lyrics
            if (syncedLyrics.isNotEmpty && syncedLyrics != 'NA') {
              _parsedLyrics = _parseSyncedLyrics(syncedLyrics);

              if (_parsedLyrics.isNotEmpty) {
                return _buildSyncedLyricsView();
              }
            }

            // Fall back to plain lyrics
            if (plainLyrics.isNotEmpty && plainLyrics != 'NA') {
              return _buildPlainLyricsView(plainLyrics);
            }

            // No lyrics available
            return _buildNoLyricsView();
          }),
        ),

        // Bottom Mini Player
        _buildBottomMiniPlayer(),
      ],
    );
  }

  Widget _buildSyncedLyricsView() {
    return Obx(() {
      final positionMs =
          playerController.progressBarStatus.value.current.inMilliseconds;
      final newIndex = _findCurrentLineIndex(positionMs);

      if (newIndex != _currentLineIndex) {
        _currentLineIndex = newIndex;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToCurrentLine(_currentLineIndex);
        });
      }

      return ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        itemCount: _parsedLyrics.length,
        itemBuilder: (context, index) {
          final line = _parsedLyrics[index];
          final isCurrent = index == _currentLineIndex;
          final isPast = index < _currentLineIndex;
          final distance = (index - _currentLineIndex).abs();

          // Calculate opacity based on distance from current line
          double opacity;
          if (isCurrent) {
            opacity = 1.0;
          } else if (isPast) {
            opacity = (0.5 - (distance * 0.1)).clamp(0.15, 0.5);
          } else {
            opacity = (0.6 - (distance * 0.1)).clamp(0.2, 0.6);
          }

          return GestureDetector(
            onTap: () {
              // Seek to this lyric line
              playerController.seek(Duration(milliseconds: line.timeMs));
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  fontSize: isCurrent ? 26 : 22,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                  color: Colors.white.withOpacity(opacity),
                  height: 1.3,
                ),
                child: Text(
                  line.text,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildPlainLyricsView(String lyrics) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      physics: const BouncingScrollPhysics(),
      child: Text(
        lyrics,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.white70,
          height: 1.6,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildNoLyricsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lyrics_outlined, size: 60, color: Colors.white24),
          const SizedBox(height: 16),
          Text(
            "lyricsNotAvailable".tr,
            style: AppTextStyles.body.copyWith(color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomMiniPlayer() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Action Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  children: [
                    IconButton(
                      icon: Obx(() => Icon(
                            playerController.isCurrentSongFav.isTrue
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: playerController.isCurrentSongFav.isTrue
                                ? Colors.red
                                : Colors.white70,
                            size: 22,
                          )),
                      onPressed: playerController.toggleFavourite,
                    ),
                    IconButton(
                      icon: const Icon(Icons.bookmark_border,
                          color: Colors.white70, size: 22),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.share_outlined,
                          color: Colors.white70, size: 22),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.thumb_up_outlined,
                          color: Colors.white70, size: 22),
                      onPressed: () {},
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.more_vert,
                          color: Colors.white70, size: 22),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // Divider
              Container(height: 0.5, color: Colors.white12),

              // Song Info and Controls
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    // Album Art
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Obx(() => CachedNetworkImage(
                            imageUrl: playerController.currentSong.value?.artUri
                                    .toString() ??
                                "",
                            width: 45,
                            height: 45,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Container(
                              width: 45,
                              height: 45,
                              color: Colors.grey.shade800,
                              child: const Icon(Icons.music_note,
                                  color: Colors.white54, size: 22),
                            ),
                          )),
                    ),
                    const SizedBox(width: 10),

                    // Song Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Obx(() => Text(
                                playerController.currentSong.value?.title ??
                                    "Unknown",
                                style: AppTextStyles.body.copyWith(
                                    fontWeight: FontWeight.w600, fontSize: 13),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                          const SizedBox(height: 2),
                          Obx(() => Text(
                                playerController.currentSong.value?.artist ??
                                    "Unknown",
                                style: AppTextStyles.caption.copyWith(
                                    color: Colors.white60, fontSize: 11),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                        ],
                      ),
                    ),

                    // Playback Controls
                    IconButton(
                      icon: const Icon(Icons.skip_previous_rounded,
                          color: Colors.white, size: 26),
                      onPressed: playerController.prev,
                      padding: EdgeInsets.zero,
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Obx(() => Icon(
                            playerController.buttonState.value ==
                                    PlayButtonState.playing
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: Colors.black,
                            size: 26)),
                        onPressed: playerController.playPause,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LyricLine {
  final int timeMs;
  final String text;

  LyricLine({required this.timeMs, required this.text});
}
