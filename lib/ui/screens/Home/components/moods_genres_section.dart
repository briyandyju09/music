import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harmonymusic/ui/theme.dart';
import 'package:harmonymusic/ui/navigator.dart';

class MoodsGenresSection extends StatelessWidget {
  const MoodsGenresSection({super.key});

  final List<String> moods = const [
    "R&B & Soul",
    "Pop",
    "Chill",
    "Sad",
    "Party",
    "Feel Good",
    "Romance",
    "Metal"
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Moods & genres", style: AppTextStyles.title),
              GestureDetector(
                onTap: () {
                  Get.toNamed(ScreenNavigationSetup.searchScreen,
                      id: ScreenNavigationSetup.id);
                },
                child: Text("More",
                    style: AppTextStyles.caption.copyWith(fontSize: 12)),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 90,
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.28,
            ),
            itemCount: moods.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Navigate to search with mood as query
                  Get.toNamed(
                    ScreenNavigationSetup.searchScreen,
                    id: ScreenNavigationSetup.id,
                    arguments: moods[index],
                  );
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: AppColors.cardColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border(
                        left: BorderSide(color: _getColor(index), width: 3)),
                  ),
                  child: Text(
                    moods[index],
                    style: AppTextStyles.button.copyWith(fontSize: 12),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Color _getColor(int index) {
    List<Color> colors = [
      Colors.redAccent,
      Colors.orangeAccent,
      Colors.greenAccent,
      Colors.blueAccent,
      Colors.purpleAccent,
      Colors.tealAccent,
      Colors.pinkAccent,
      Colors.amberAccent,
    ];
    return colors[index % colors.length];
  }
}
