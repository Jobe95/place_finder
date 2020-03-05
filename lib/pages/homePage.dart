import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_launcher/map_launcher.dart' as launcher;
import 'package:place_finder/viewmodels/placeListViewModel.dart';
import 'package:place_finder/viewmodels/placeViewModel.dart';
import 'package:place_finder/widget/placeList.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controller = Completer();
  Position _currentPosition;

  @override
  void initState() {
    super.initState();
  }

  Set<Marker> _getPlaceMarkers(List<PlaceViewModel> places) {
    return places.map((place) {
      return Marker(
          markerId: MarkerId(place.placeId),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: place.name),
          position: LatLng(place.latitude, place.longitude));
    }).toSet();
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    _currentPosition = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    controller.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
        zoom: 14,
      )),
    );
  }

  Future<void> _openMapsFor(PlaceViewModel vm) async {
    if (await launcher.MapLauncher.isMapAvailable(launcher.MapType.google)) {
      await launcher.MapLauncher.launchMap(
          mapType: launcher.MapType.google,
          coords: launcher.Coords(vm.latitude, vm.longitude),
          title: vm.name,
          description: vm.name);
    } else if (await launcher.MapLauncher.isMapAvailable(
        launcher.MapType.apple)) {
      await launcher.MapLauncher.launchMap(
          mapType: launcher.MapType.apple,
          coords: launcher.Coords(vm.latitude, vm.longitude),
          title: vm.name,
          description: vm.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PlaceListViewModel>(context);
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: vm.mapType,
              markers: _getPlaceMarkers(vm.places),
              myLocationEnabled: true,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                  target: LatLng(45.521563, -122.677433), zoom: 14),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  onSubmitted: (value) {
                    print(value);
                    vm.fetchPlacesByKeywordAndPosition(value,
                        _currentPosition.latitude, _currentPosition.longitude);
                  },
                  decoration: InputDecoration(
                    labelText: 'Search here',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: vm.places.length > 0 ? true : false,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: FlatButton(
                      onPressed: () {
                        print('Hej');
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => PlaceList(
                            places: vm.places,
                            onSelected: _openMapsFor,
                          ),
                        );
                      },
                      child: Text('Visa listan',
                          style: TextStyle(color: Colors.white)),
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 130,
              right: 10,
              child: FloatingActionButton(
                onPressed: () {
                  vm.toggleMapType();
                },
                child: Icon(Icons.map),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
