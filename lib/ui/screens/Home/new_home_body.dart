import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harmonymusic/ui/screens/Home/components/ai_playlist_card.dart';
import 'package:harmonymusic/ui/screens/Home/components/custom_home_app_bar.dart';
import 'package:harmonymusic/ui/screens/Home/components/listen_again_section.dart';
import 'package:harmonymusic/ui/screens/Home/components/moods_genres_section.dart';
import 'package:harmonymusic/ui/screens/Home/components/trending_section.dart';
import 'package:harmonymusic/ui/screens/Home/home_screen_controller.dart';
import 'package:harmonymusic/models/album.dart';
import 'package:harmonymusic/models/playlist.dart';

class NewHomeBody extends StatelessWidget {
  const NewHomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeScreenController>();

    return CustomScrollView(
      slivers: [
        const CustomHomeAppBar(),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Listen Again / Quick Picks
              Obx(() {
                if (controller.quickPicks.value.songList.isNotEmpty) {
                  return ListenAgainSection(
                    songs: controller.quickPicks.value.songList,
                    title: controller.quickPicks.value.title ?? "Listen Again",
                  );
                }
                return const SizedBox.shrink();
              }),

              // Trending Songs (From Middle Content)
              Obx(() {
                if (controller.middleContent.isNotEmpty) {
                  return Column(
                    children: controller.middleContent.map((content) {
                      if (content is AlbumContent) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: TrendingSection(
                              title: content.title,
                              contentList: content.albumList),
                        );
                      } else if (content is PlaylistContent) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: TrendingSection(
                              title: content.title,
                              contentList: content.playlistList),
                        );
                      }
                      return const SizedBox.shrink();
                    }).toList(),
                  );
                }
                return const SizedBox.shrink();
              }),

              const AIPlaylistCard(),

              const MoodsGenresSection(),

              // Fixed Content
              Obx(() {
                if (controller.fixedContent.isNotEmpty) {
                  return Column(
                    children: controller.fixedContent.map((content) {
                      if (content is AlbumContent) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: TrendingSection(
                              title: content.title,
                              contentList: content.albumList),
                        );
                      } else if (content is PlaylistContent) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: TrendingSection(
                              title: content.title,
                              contentList: content.playlistList),
                        );
                      }
                      return const SizedBox.shrink();
                    }).toList(),
                  );
                }
                return const SizedBox.shrink();
              }),

              const SizedBox(height: 120), // Bottom padding for player
            ],
          ),
        ),
      ],
    );
  }
}
