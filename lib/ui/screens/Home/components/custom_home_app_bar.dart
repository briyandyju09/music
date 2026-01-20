import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harmonymusic/ui/theme.dart';
import 'package:harmonymusic/ui/navigator.dart';

class CustomHomeAppBar extends StatelessWidget {
  const CustomHomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Basic greeting logic
    var hour = DateTime.now().hour;
    String greeting = "Good Morning";
    if (hour >= 12 && hour < 17) {
      greeting = "Good Afternoon";
    } else if (hour >= 17) {
      greeting = "Good Evening";
    }

    return SliverAppBar(
      backgroundColor: Colors.transparent,
      floating: true,
      snap: true,
      elevation: 0,
      expandedHeight: 80, // Compact height to reduce gap
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.cardColor,
                    child: Icon(Icons.person, color: AppColors.secondary),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        greeting,
                        style: AppTextStyles.title
                            .copyWith(fontSize: 14, color: AppColors.secondary),
                      ),
                      Text(
                        "Briyan Dyju", // Placeholder name
                        style: AppTextStyles.header.copyWith(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  Get.toNamed('/searchScreen', id: ScreenNavigationSetup.id);
                },
                icon: const Icon(Icons.search, size: 28),
                color: AppColors.accent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
