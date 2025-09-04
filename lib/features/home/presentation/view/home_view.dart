import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meong_g/core/theme/app_styles.dart';
import 'dart:io' show Platform;

import 'package:meong_g/features/home/presentation/view/kakao_map_widget.dart';
import 'package:meong_g/features/home/presentation/viewmodel/home_viewmodel.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);
    final viewModel = ref.read(homeViewModelProvider.notifier);

    return Container(
      color: Colors.white, // 전체 배경을 흰색으로
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              height: 240,
              child: Column(
                children: [
                  MapTitleBarView(
                    petNames: homeState.petNames,
                    onAlarmTap: () {
                      homeState.petNames != null
                          ? print("Pets: ${homeState.petNames}")
                          : viewModel.fetchPets();
                      print("Alarm Clicked");
                    },
                  ),
                  SizedBox(
                    height: 176,
                    width: double.infinity,
                    // color: Colors.blue,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 4, 20, 20),
                      child: PetAddCardView(
                        onProfileTap: () {
                          print("Profile Complete Clicked");
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(child: MapView()),
          ],
        ),
      ),
    );
  }
}

class MapTitleBarView extends StatelessWidget {
  final List<String>? petNames;
  final VoidCallback onAlarmTap;

  const MapTitleBarView({
    super.key,
    required this.petNames,
    required this.onAlarmTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Image.asset('assets/img/ic_icon.png', height: 40),
            Expanded(child: SizedBox()),
            GestureDetector(
              onTap: onAlarmTap,
              child: Image.asset('assets/img/ic_alarm.png', height: 28),
            ),
          ],
        ),
      ),
    );
  }
}

class PetAddCardView extends StatelessWidget {
  final VoidCallback onProfileTap;

  const PetAddCardView({super.key, required this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppStyles.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppStyles.gray500,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: 64,
                    height: 64,
                    // child: Text("HI"),
                  ),

                  SizedBox(width: 14),

                  Text(
                    "반려견의 프로필을\n완성해 주세요!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              GestureDetector(
                onTap: onProfileTap,
                child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppStyles.primary100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      "반려견 프로필 등록하기",
                      style: TextStyle(
                        color: AppStyles.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? KakaoMapWidget()
        : Center(child: Text("Not Supported OS"));
  }
}
