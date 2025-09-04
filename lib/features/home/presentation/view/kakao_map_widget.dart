import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meong_g/features/home/presentation/viewmodel/home_viewmodel.dart';

class KakaoMapWidget extends ConsumerWidget {
  const KakaoMapWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);

    if (homeState.isMapLoading) {
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
    }

    if (homeState.errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Map Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                homeState.errorMessage!,
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
    }

    if (homeState.location != null) {
      return Scaffold(
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: UiKitView(
            viewType: "KakaoMapView",
            creationParams: <String, dynamic>{
              'lat': homeState.location!.latitude,
              'lon': homeState.location!.longitude,
            },
            creationParamsCodec: const StandardMessageCodec(),
            onPlatformViewCreated: (int id) {},
          ),
        ),
      );
    }

    // Initial state or other unhandled cases
    return const Scaffold(body: Center(child: Text("Waiting for location...")));
  }
}
