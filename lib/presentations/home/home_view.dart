import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meong_g/presentations/home/home_viewmodel.dart';
import 'package:meong_g/presentations/home/kakao_map_widget.dart';
import 'package:meong_g/presentations/home/widgets/pet_carousel_view.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);
    // final homeViewModel = ref.read(homeViewModelProvider.notifier);

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
                    onAlarmTap: () => Navigator.of(context).pushNamed('/alarm'),
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

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? KakaoMapWidget()
        : Center(child: Text("Not Supported OS"));
  }
}
