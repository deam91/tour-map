import 'package:latlong2/latlong.dart';

const path = 'assets/markers';

class MapMarker {
  String image;
  String title;
  String address;
  String description;
  LatLng location;

  MapMarker({required this.image, required this.title, required this.address, required this.description,
    required this.location});
}

var markers = [
  MapMarker(
      image: '$path/marker_place.png',
      title: 'Marker 1',
      address: 'Addresssssssssss',
      description: 'Descriptionnnnn',
      location: LatLng(23.1432978, -82.3604176)
  ),
  MapMarker(
      image: '$path/marker_place.png',
      title: 'Marker 2',
      address: 'Addresssssssssss',
      description: 'Descriptionnnnn',
      location: LatLng(23.1432878, -82.3607076)
  )
];
