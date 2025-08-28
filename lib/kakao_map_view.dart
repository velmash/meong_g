import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

class IOSKakaoMapView extends StatefulWidget {
  const IOSKakaoMapView({super.key});

  @override
  State<IOSKakaoMapView> createState() => _IOSKakaoMapViewState();
}

class _IOSKakaoMapViewState extends State<IOSKakaoMapView> {
  Position? _currentPosition;
  String? _error;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _error = 'Location services are disabled.';
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _error = 'Location permissions are denied';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _error =
            'Location permissions are permanently denied, we cannot request permissions.';
      });
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      setState(() {
        _currentPosition = position;
      });
      print(
        '✅ Flutter: Got position: ${position.latitude}, ${position.longitude}',
      );
    } catch (e) {
      print('❌ Flutter: Failed to get position: $e');
      // 위치를 가져오지 못했을 때 기본값 사용 (서울시청)
      setState(() {
        _currentPosition = Position(
          latitude: 37.566535,
          longitude: 126.9779692,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          floor: null,
          isMocked: false,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Map Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _determinePosition,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_currentPosition == null) {
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

    print(
      '🗺️ Flutter: Creating UiKitView with coordinates: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}',
    );

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: UiKitView(
          viewType: "KakaoMapView",
          creationParams: <String, dynamic>{
            'lat': _currentPosition!.latitude,
            'lon': _currentPosition!.longitude,
          },
          creationParamsCodec: const StandardMessageCodec(),
          onPlatformViewCreated: (int id) {
            print('🎯 Flutter: Platform view created with ID: $id');
          },
        ),
      ),
    );
  }
}
