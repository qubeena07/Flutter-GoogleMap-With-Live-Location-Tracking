import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({Key? key}) : super(key: key);

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng sourceLocation = LatLng(27.6844128, 85.3170161);
  static const LatLng destination = LatLng(27.662000, 85.362838);

  // void getPolyPoints() async{
  //   PolylinePoints polylinePoints = Polu
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Trackk Order",
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ),
        body: GoogleMap(
          initialCameraPosition:
              const CameraPosition(target: sourceLocation, zoom: 12.5),
          markers: {
            const Marker(
                markerId: MarkerId("source"), position: sourceLocation),
            const Marker(
                markerId: MarkerId("destination"), position: destination)
          },
        ));
  }
}
