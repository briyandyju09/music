import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harmonymusic/ui/screens/Home/home_screen_controller.dart';
import 'glass_container.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final homeScreenController = Get.find<HomeScreenController>();
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: GlassContainer(
        opacity: 0.8,
        blur: 20,
        borderRadius: BorderRadius.circular(30),
        child: Obx(() => NavigationBar(
                height: 70,
                elevation: 0,
                backgroundColor: Colors.transparent,
                indicatorColor:
                    Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                onDestinationSelected:
                    homeScreenController.onBottonBarTabSelected,
                selectedIndex: homeScreenController.tabIndex.toInt(),
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                destinations: [
                  NavigationDestination(
                    selectedIcon: const Icon(Icons.home),
                    icon: const Icon(Icons.home_outlined),
                    label: modifyNgetlabel('home'.tr),
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.search),
                    label: modifyNgetlabel('search'.tr),
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.library_music),
                    label: modifyNgetlabel('library'.tr),
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.settings),
                    label: modifyNgetlabel('settings'.tr),
                  ),
                ])),
      ),
    );
  }

  String modifyNgetlabel(String label) {
    if (label.length > 9) {
      return "${label.substring(0, 8)}..";
    }
    return label;
  }
}
