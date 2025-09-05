import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meong_g/core/theme/app_styles.dart';
import 'package:meong_g/features/home/domain/entity/meong_g.dart';
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
                    onAlarmTap: () {
                      // homeState.meongGs != null
                      //     ? print("Pets: ${homeState.meongGs?.first.name}")
                      //     : viewModel.fetchPets();
                      print("Alarm Clicked");
                    },
                  ),
                  SizedBox(
                    height: 176,
                    width: double.infinity,
                    // color: Colors.blue,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 4, 0, 20),
                      child: PetCarouselView(meongGs: homeState.meongGs ?? []),
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
  final VoidCallback onAlarmTap;

  const MapTitleBarView({super.key, required this.onAlarmTap});

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
            GestureDetector(onTap: onAlarmTap, child: Image.asset('assets/img/ic_alarm.png', height: 28)),
          ],
        ),
      ),
    );
  }
}

class PetCarouselView extends StatelessWidget {
  final List<MeongG> meongGs;
  const PetCarouselView({super.key, required this.meongGs});

  @override
  Widget build(BuildContext context) {
    final List<Widget> meongGsCard = meongGs.map((meongG) {
      return PetInfoCardView(
        meongGInfo: meongG,
        onProfileTap: () {
          print("Pet Info Profile Clicked: ${meongG.name}");
        },
      );
    }).toList();

    final List<Widget> allCards = [
      ...meongGsCard,
      PetAddCardView(
        onProfileTap: () {
          print("Pet Add Profile Clicked");
        },
      ),
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth - 40; // 20px 양쪽 마진
    final viewportFraction = (cardWidth + 8) / screenWidth; // 카드 너비 + 8px 간격

    return PageView.builder(
      controller: PageController(viewportFraction: viewportFraction),
      itemCount: allCards.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(left: index == 0 ? 0 : 4, right: index == allCards.length - 1 ? 0 : 4),
          child: allCards[index],
        );
      },
    );
  }
}

class PetInfoCardView extends StatelessWidget {
  final MeongG meongGInfo;
  final VoidCallback onProfileTap;

  const PetInfoCardView({super.key, required this.meongGInfo, required this.onProfileTap});

  String _convertGoogleDriveUrl(String url) {
    if (url.contains('drive.google.com/file/d/')) {
      final fileId = url.split('/d/')[1].split('/')[0];
      return 'https://drive.google.com/uc?export=view&id=$fileId';
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _convertGoogleDriveUrl(meongGInfo.imageUrl);
    return Container(
      decoration: BoxDecoration(color: AppStyles.primary, borderRadius: BorderRadius.circular(12)),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: AppStyles.gray500,
                                  child: Icon(Icons.pets, color: Colors.white, size: 32),
                                );
                              },
                            )
                          : Icon(Icons.pets, color: Colors.white, size: 32),
                    ),
                  ),

                  SizedBox(width: 14),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meongGInfo.name,
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            "${meongGInfo.breed} · ",
                            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal),
                          ),
                          Text(
                            "${meongGInfo.age}살",
                            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(color: AppStyles.primary700, borderRadius: BorderRadius.circular(12)),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            children: [
                              Text(
                                "오늘 산책",
                                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
                              ),

                              Spacer(),
                              Text(
                                "0회",
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(color: AppStyles.primary700, borderRadius: BorderRadius.circular(12)),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            children: [
                              Text(
                                "산책 시간",
                                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
                              ),

                              Spacer(),
                              Text(
                                "0분",
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
      decoration: BoxDecoration(color: AppStyles.primary, borderRadius: BorderRadius.circular(12)),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(color: AppStyles.gray500, borderRadius: BorderRadius.circular(20)),
                    width: 64,
                    height: 64,
                    // child: Text("HI"),
                  ),

                  SizedBox(width: 14),

                  Text(
                    "반려견의 프로필을\n완성해 주세요!",
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              SizedBox(height: 12),
              GestureDetector(
                onTap: onProfileTap,
                child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(color: AppStyles.primary100, borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Text(
                      "반려견 프로필 등록하기",
                      style: TextStyle(color: AppStyles.primary, fontSize: 14, fontWeight: FontWeight.normal),
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
    return Platform.isIOS ? KakaoMapWidget() : Center(child: Text("Not Supported OS"));
  }
}
