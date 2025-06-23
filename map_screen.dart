import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  final String busId; // Bus identifier (bus3 or bus13)

  MapScreen({required this.busId});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _currentPosition = LatLng(0, 0);
  final MapController _mapController = MapController();
  List<Marker> _busMarkers = [];
  List<Marker> _busStopMarkers = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _listenToBusLocations();
    _loadBusStops();
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return;

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _mapController.move(_currentPosition, 15);
    });
  }

 void _listenToBusLocations() {
  FirebaseFirestore.instance
      .collection('bus_locations')
      .doc(widget.busId) // Fetch document directly by busId
      .snapshots()
      .listen((snapshot) {
    if (snapshot.exists) {
      double lat = snapshot['latitude'];
      double lng = snapshot['longitude'];

      print("🚍 Live bus location received: ($lat, $lng)");

      setState(() {
        _busMarkers = [
          Marker(
            point: LatLng(lat, lng),
            width: 50,
            height: 50,
            child: const Icon(Icons.directions_bus, size: 40, color: Colors.red),
          ),
        ];
        _mapController.move(LatLng(lat, lng), 15);
      });
    } else {
      print("⚠ No location data found for bus ${widget.busId}");
    }
  }, onError: (error) {
    print("❌ Error fetching bus location: $error");
  });
}

  void _loadBusStops() {
    FirebaseFirestore.instance
        .collection('bus_routes')
        .where('busId', isEqualTo: widget.busId) 
        .snapshots()
        .listen((snapshot) {
      List<Marker> newStopMarkers = [];
      for (var doc in snapshot.docs) {
        List stops = doc['stops'];
        for (var stop in stops) {
          newStopMarkers.add(
            Marker(
              point: LatLng(stop['location'].latitude, stop['location'].longitude),
              width: 40,
              height: 40,
              child: const Icon(Icons.location_on, size: 30, color: Colors.blue),
            ),
          );
        }
      }
      setState(() {
        _busStopMarkers = newStopMarkers;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Live Tracking - ${widget.busId.toUpperCase()}')),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _currentPosition,
          initialZoom: 15,
        ),
        children: [
          TileLayer(urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"),
          MarkerLayer(markers: _busMarkers),
          MarkerLayer(markers: _busStopMarkers),
        ],
      ),
    );
  }
}