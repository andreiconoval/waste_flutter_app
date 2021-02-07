import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:waste_on_map_app/Widgets/MapWidget.dart';

class MapRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Map Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapRoutePage(),
    );
  }
}

class MapRoutePage extends StatefulWidget {
  @override
  _MapRoutePageState createState() => _MapRoutePageState();
}

class _MapRoutePageState extends State<MapRoutePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<Position> getCurrentPosition() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  @override
  Widget build(BuildContext context) {
    Future<Position> currentPosition = getCurrentPosition();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Google Map'),
      ),
      body: Stack(children: <Widget>[
        Positioned.fill(
          child: FutureBuilder<Position>(
            future: currentPosition,
            builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
              if (snapshot.hasData) {
                // while data is loading:
                return MapWidget();
              } else {
                // data loaded:
                return Center(
                  child: Text('mapEror'),
                );
              }
            },
          ),
        )
      ]),
    );
  }
}
