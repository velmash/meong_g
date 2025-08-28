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
        _error = 'Location permissions are permanently denied, we cannot request permissions.';
      });
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to get current location: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        body: Center(child: Text(_error!)),
      );
    }

    if (_currentPosition == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return UiKitView(
      viewType: "KakaoMapView", // iOS에서 등록한 ID
      creationParams: <String, dynamic>{
        'lat': _currentPosition!.latitude,
        'lon': _currentPosition!.longitude,
      },
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}