import 'package:flutter/material.dart';
import 'package:place_finder/utils/urlHelper.dart';
import 'package:place_finder/viewmodels/placeViewModel.dart';

class PlaceList extends StatelessWidget {
  final List<PlaceViewModel> places;
  Function(PlaceViewModel) onSelected;

  PlaceList({this.places, this.onSelected});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, index) {
        final place = this.places[index];
        return ListTile(
          onTap: () {
            return onSelected(place);
          },
          leading: Container(
            width: 100,
            height: 100,
            child: Image.network(
              UrlHelper.urlFOrReferenceImage(place.photoUrl),
              fit: BoxFit.cover,
            ),
          ),
          title: Text(place.name),
        );
      },
    );
  }
}
