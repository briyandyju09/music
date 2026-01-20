import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:harmonymusic/ui/screens/AIPlaylist/ai_playlist_screen.dart';
import 'package:harmonymusic/ui/theme.dart';
import 'package:harmonymusic/ui/widgets/glass_container.dart';

class AIPlaylistCard extends StatelessWidget {
  const AIPlaylistCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
      child: GestureDetector(
        onTap: () => Get.to(() => const AiPlaylistScreen()),
        child: GlassContainer(
          height: 140,
          width: double.infinity,
          color: const Color(0xFF2A2A2E), // Slightly lighter than background
          opacity: 0.4,
          blur: 20,
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "AI BETA",
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Create various\nplaylists using AI",
                      style: AppTextStyles.title
                          .copyWith(fontSize: 18, height: 1.2),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Music intelligence",
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              // Placeholder for schematic or icon
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple.withOpacity(0.5),
                      Colors.blue.withOpacity(0.5)
                    ],
                  ),
                ),
                child: const Icon(Icons.auto_awesome,
                    color: Colors.white, size: 30),
              )
                  .animate(
                      onPlay: (controller) => controller.repeat(reverse: true))
                  .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.1, 1.1),
                      duration: const Duration(seconds: 2)),
            ],
          ),
        ),
      ),
    );
  }
}
