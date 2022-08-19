import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location_tracking/components/constants.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({Key? key}) : super(key: key);

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng sourceLocation = LatLng(37.4221, -122.0841);
  static const LatLng destination = LatLng(37.4116, -122.0713);

  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentIcon = BitmapDescriptor.defaultMarker;

  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then((location) {
      currentLocation = location;
    });

    GoogleMapController googleMapController = await _controller.future;
    location.onLocationChanged.listen((newLoc) {
      currentLocation = newLoc;

      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              zoom: 13.5,
              target: LatLng(newLoc.latitude!, newLoc.longitude!))));

      setState(() {});
    });
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key,
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getCurrentLocation();
    getPolyPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Track Order",
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ),
        body:
            //  currentLocation == null
            //     ? const Center(
            //         child: CircularProgressIndicator(),
            //       )
            //     :
            GoogleMap(
          initialCameraPosition: CameraPosition(
              target: LatLng(
                  currentLocation!.latitude!, currentLocation!.longitude!),
              zoom: 13.5),
          polylines: {
            Polyline(
                polylineId: const PolylineId("route"),
                points: polylineCoordinates,
                color: primaryColor,
                width: 6)
          },
          markers: {
            Marker(
                markerId: const MarkerId("currentLocation"),
                position: LatLng(
                    currentLocation!.latitude!, currentLocation!.longitude!)),
            const Marker(
                markerId: MarkerId("source"), position: sourceLocation),
            const Marker(
                markerId: MarkerId("destination"), position: destination)
          },
          onMapCreated: (mapController) {
            _controller.complete(mapController);
          },
        ));
  }
}
