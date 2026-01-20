import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harmonymusic/ui/theme.dart';
import 'package:harmonymusic/ui/widgets/glass_container.dart';

class AiPlaylistController extends GetxController {
  final promptController = TextEditingController();
  final selectedMoods = <String>[].obs;
  final isGenerating = false.obs;

  final moods = [
    "Chill",
    "Upbeat",
    "Focus",
    "Workout",
    "Party",
    "Melancholy",
    "Romantic",
    "Driving",
    "Sleep",
    "Nature"
  ];

  void toggleMood(String mood) {
    if (selectedMoods.contains(mood)) {
      selectedMoods.remove(mood);
    } else {
      if (selectedMoods.length < 5) {
        selectedMoods.add(mood);
      } else {
        Get.snackbar("Limit Reached", "You can only select up to 5 moods",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white24,
            colorText: Colors.white);
      }
    }
  }

  Future<void> generatePlaylist() async {
    if (promptController.text.isEmpty && selectedMoods.isEmpty) {
      Get.snackbar("Empty Input", "Please enter a prompt or select a mood",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white24,
          colorText: Colors.white);
      return;
    }

    isGenerating.value = true;

    try {
      final prompt = promptController.text.isNotEmpty
          ? promptController.text
          : "Create a playlist for these moods: ${selectedMoods.join(', ')}";

      final response = await http.post(
        Uri.parse("https://ai.hackclub.com/proxy/v1/chat/completions"),
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer sk-hc-v1-33da79b337b04dbf91de18f553d199a51b2647244a4b4a81bf15cef5003d5e20"
        },
        body: jsonEncode({
          "model": "qwen/qwen3-32b",
          "messages": [
            {
              "role": "user",
              "content":
                  "$prompt. Return ONLY a JSON array of 15 song objects with 'title' and 'artist' keys. Do not include markdown formatting or extra text."
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];

        // Sanitize content if it contains markdown code blocks
        String jsonStr = content;
        if (jsonStr.contains("```json")) {
          jsonStr = jsonStr.split("```json")[1].split("```")[0].trim();
        } else if (jsonStr.contains("```")) {
          jsonStr = jsonStr.split("```")[1].split("```")[0].trim();
        }

        List<dynamic> songs = [];
        try {
          songs = jsonDecode(jsonStr);
        } catch (e) {
          print("JSON Parsing error: $e");
        }

        Get.dialog(
          Dialog(
            backgroundColor: AppColors.cardColor.withOpacity(0.95),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              constraints: BoxConstraints(maxHeight: Get.height * 0.7),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle,
                      color: AppColors.accent, size: 50),
                  const SizedBox(height: 15),
                  Text(
                    "Playlist Generated!",
                    style: AppTextStyles.title,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${songs.length} songs created based on your inputs",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body,
                  ),
                  const SizedBox(height: 15),
                  if (songs.isNotEmpty)
                    Flexible(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: songs.length,
                          itemBuilder: (context, index) {
                            final song = songs[index];
                            return ListTile(
                              dense: true,
                              leading: CircleAvatar(
                                backgroundColor:
                                    AppColors.accent.withOpacity(0.2),
                                child: Text(
                                  "${index + 1}",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                              title: Text(
                                song['title'] ?? 'Unknown',
                                style:
                                    AppTextStyles.body.copyWith(fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                song['artist'] ?? 'Unknown Artist',
                                style: AppTextStyles.caption,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  if (songs.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text("Could not parse songs from response",
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                    ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back(); // Close dialog
                        Get.back(); // Go back to home
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("Done",
                          style: AppTextStyles.button
                              .copyWith(color: Colors.black)),
                    ),
                  )
                ],
              ),
            ),
          ),
          barrierDismissible: false,
        );
      } else {
        Get.snackbar(
            "Error", "Failed to generate playlist: ${response.statusCode}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
    } finally {
      isGenerating.value = false;
    }
  }

  @override
  void onClose() {
    promptController.dispose();
    super.onClose();
  }
}

class AiPlaylistScreen extends StatelessWidget {
  const AiPlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AiPlaylistController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("AI Playlist Generator", style: AppTextStyles.title),
        centerTitle: true,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.background,
              AppColors.cardColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Describe your vibe",
                  style: AppTextStyles.header,
                ),
                const SizedBox(height: 20),
                GlassContainer(
                  width: double.infinity,
                  height: 150,
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: controller.promptController,
                    style: AppTextStyles.body,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "E.g., A rainy night in Tokyo playing jazz...",
                      hintStyle:
                          AppTextStyles.body.copyWith(color: Colors.white38),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  "Or choose moods",
                  style: AppTextStyles.title,
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: controller.moods.map((mood) {
                        return Obx(() {
                          final isSelected =
                              controller.selectedMoods.contains(mood);
                          return GestureDetector(
                            onTap: () => controller.toggleMood(mood),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.accent
                                    : Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.accent
                                      : Colors.white.withOpacity(0.1),
                                ),
                              ),
                              child: Text(
                                mood,
                                style: AppTextStyles.body.copyWith(
                                  color:
                                      isSelected ? Colors.black : Colors.white,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        });
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() => SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: controller.isGenerating.value
                            ? null
                            : controller.generatePlaylist,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          disabledBackgroundColor:
                              AppColors.accent.withOpacity(0.5),
                        ),
                        child: controller.isGenerating.value
                            ? const CircularProgressIndicator(
                                color: Colors.black)
                            : Text(
                                "Generate Playlist",
                                style: AppTextStyles.title
                                    .copyWith(color: Colors.black),
                              ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
