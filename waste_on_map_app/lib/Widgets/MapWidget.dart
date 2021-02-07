import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:waste_on_map_app/Models/MarkerModel.dart';
import 'package:waste_on_map_app/Routes/ImagePickerRoute.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({Key key}) : super(key: key);
  @override
  MapWidgetState createState() => MapWidgetState();
}

typedef Marker MarkerUpdateAction(Marker marker);

class MapWidgetState extends State<MapWidget> {
  MapWidgetState();
  final _googleMapKey = GlobalKey();

  static LatLng center = const LatLng(-33.86711, 151.1947171);
  bool _addIsHidden = false;

  GoogleMapController controller;
  Map<MarkerId, MarkerModel> markers = <MarkerId, MarkerModel>{};
  MarkerId selectedMarker;

  int _markerIdCounter = 1;

  @override
  void dispose() {
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
  }

  void _onMarkerTapped(MarkerId markerId) {
    final Marker tappedMarker = markers[markerId].marker;
    if (tappedMarker != null) {
      setState(() {
        if (markers.containsKey(selectedMarker)) {
          final Marker resetOld = markers[selectedMarker]
              .marker
              .copyWith(iconParam: BitmapDescriptor.defaultMarker);
          markers[selectedMarker].marker = resetOld;
        }
        selectedMarker = markerId;
        final Marker newMarker = tappedMarker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
        markers[markerId].marker = newMarker;
      });
    }
  }

  void _onMarkerDragEnd(MarkerId markerId, LatLng newPosition) async {
    final Marker tappedMarker = markers[markerId].marker;
    if (tappedMarker != null) {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                actions: <Widget>[
                  FlatButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
                content: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 66),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('Old position: ${tappedMarker.position}'),
                        Text('New position: $newPosition'),
                      ],
                    )));
          });
    }
  }

  void _addMarker() {
    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: center,
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      onTap: () {
        _onMarkerTapped(markerId);
      },
      onDragEnd: (LatLng position) {
        _onMarkerDragEnd(markerId, position);
      },
    );

    setState(() {
      markers[markerId] = new MarkerModel(marker, null);
    });
  }

  void _remove() {
    setState(() {
      if (markers.containsKey(selectedMarker)) {
        markers.remove(selectedMarker);
      }
    });
  }

  void _onCameraMove(CameraPosition cameraPosition) {
    center = cameraPosition.target;
  }

  void _onAdd() {
    setState(() {
      _addIsHidden = true;
    });
  }

  void _cancelAdd() {
    setState(() {
      _addIsHidden = false;
    });
  }

  double getMapSize() {
    if (_googleMapKey.currentContext == null)
      return 50;
    else {
      final RenderBox box = _googleMapKey.currentContext.findRenderObject();
      final size = box.size;
      return size.height / 2 - 40;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        Positioned(
          child: new Scaffold(
            body: GoogleMap(
              key: _googleMapKey,
              onMapCreated: _onMapCreated,
              onCameraMove: _onCameraMove,
              initialCameraPosition: const CameraPosition(
                target: LatLng(-33.852, 151.211),
                zoom: 11.0,
              ),
              markers: Set<Marker>.of(markers.values.map((e) => e.marker)),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton:
                _addIsHidden ? renderAddMarkerBar(context) : renderAddButton(),
          ),
        ),
        Visibility(
            visible: _addIsHidden,
            child: Positioned(
              top: getMapSize(),
              left: MediaQuery.of(context).size.width / 2,
              child: Icon(
                Icons.maps_ugc,
                color: Colors.red[900],
                size: 40,
              ),
            ))
      ],
    );
  }

  Widget renderAddButton() => FloatingActionButton(
        onPressed: () => _onAdd(),
        child: Icon(Icons.add),
        backgroundColor: Colors.redAccent,
      );

  Widget renderAddMarkerBar(BuildContext context) {
    return Card(
      elevation: 8,
      margin: EdgeInsets.fromLTRB(60, 0, 60, 0),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: MediaQuery.of(context).size.height * .80,
        height: 110,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    _addMarker();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImagePickerRoute()));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.add_location_alt,
                        color: Colors.green,
                        size: 40,
                      ),
                      Text("Add marker")
                    ],
                  ),
                ),
                Container(
                  height: 70,
                  width: 2,
                  color: Colors.deepPurple,
                ),
                InkWell(
                    onTap: _cancelAdd,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.cancel_rounded,
                          color: Colors.red[900],
                          size: 30,
                        ),
                        Text("Cancel")
                      ],
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
