import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meong_g/presentations/home/home_viewmodel.dart';

class IOSKakaoMapView extends ConsumerWidget {
  const IOSKakaoMapView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsyncValue = ref.watch(homeViewModelProvider);

    return locationAsyncValue.when(
      data: (position) {
        return Scaffold(
          body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: UiKitView(
              viewType: "KakaoMapView",
              creationParams: <String, dynamic>{
                'lat': position.latitude,
                'lon': position.longitude,
              },
              creationParamsCodec: const StandardMessageCodec(),
              onPlatformViewCreated: (int id) {},
            ),
          ),
        );
      },
      loading: () {
        return const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('Getting your location...'),
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        return Scaffold(
          appBar: AppBar(title: const Text('Map Error')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  error.toString(),
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    ref.read(homeViewModelProvider.notifier).refreshLocation();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
