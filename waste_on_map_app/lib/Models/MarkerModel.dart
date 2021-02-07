import 'dart:ui';
import 'package:google_maps_flutter/google_maps_flutter.dart';

typedef Marker MarkerUpdateAction(Marker marker);

class MarkerModel {
  Marker marker;
  Image image;

  MarkerModel(this.marker, this.image);
}
