// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'dart:html' as html;

import 'package:location/location.dart';
// import 'package:permission_handler/permission_handler.dart';

class UserLocationsScreen extends StatefulWidget {
  const UserLocationsScreen({super.key});

  @override
  _UserLocationsScreenState createState() => _UserLocationsScreenState();
}

class _UserLocationsScreenState extends State<UserLocationsScreen> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  late BitmapDescriptor captainIcon;
  LocationData? _userLocation;
  late PermissionStatus permissionStatus;
  CameraPosition? _initialCameraPosition; // Rename to _initialCameraPosition

  Future<void> _requestLocationPermission() async {
    Location location = Location();
    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied ||
        permissionStatus == PermissionStatus.deniedForever) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus == PermissionStatus.denied ||
          permissionStatus == PermissionStatus.deniedForever) {
         
        return;
      }
    }
  }

  void _loadCaptainLocations() async {
    FirebaseFirestore.instance
        .collection('drivers').where('isOnline', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      try {
        setState(() {
          _markers.clear();
          for (var doc in snapshot.docs) {
            var data = doc.data();
            GeoPoint point = data['currentLocation'];
            String phoneNumber = data['phoneNumber'];
            String name = data['userName'];
            LatLng position = LatLng(point.latitude, point.longitude);

            _markers.add(
              Marker(
                markerId: MarkerId(doc.id), 
                position: position,
                icon: captainIcon,
                infoWindow: InfoWindow(
                  title: name,
                  snippet: phoneNumber,
                ),
              ),
            );
          }
        });
      } catch (error) {
        ('Error loading captain locations: ${error.toString()}');
      }
    });
  }

  Future<void> _getUserLocation() async {
     if (GetPlatform.isWeb) {
      _getUserLocationWeb();
    } else {
      await _requestLocationPermission();      Location location = Location();
      _userLocation = await location.getLocation();
    }
  }

  Future<void> _getUserLocationWeb() async {
    try {
      final position =
          await html.window.navigator.geolocation.getCurrentPosition(
        enableHighAccuracy: true,  
        timeout: const Duration(seconds: 10), 
        maximumAge: const Duration(seconds: 60),      );
      setState(() {
        _userLocation = LocationData.fromMap({
          'latitude': position.coords!.latitude,
          'longitude': position.coords!.longitude,
        });
        _initialCameraPosition = CameraPosition(
          target: LatLng(_userLocation!.latitude!, _userLocation!.longitude!),
          zoom: 7,
        );
      });
    } catch (error) {
      ('Error getting user location: ${error.toString()}');
      _showLocationError();    }
  }

  void _showLocationError() {
     ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'Unable to get your location. Please check your browser settings or network connection.'),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _getUserLocation().then((_) {
 
      _loadCaptainLocations();
    });

    init();
  }
 
  Future<void> init() async {
    captainIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/car_1.png');
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    init();
    ('Map created');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Captains Locations'.tr),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: _initialCameraPosition ??
            const CameraPosition(
              target: LatLng(18.0747176, -15.9528449),
             //   target: LatLng(29.99and 0573,31.430581),
              zoom: 5,
            ),
        markers: _markers,
      ),
    );
  }
}
