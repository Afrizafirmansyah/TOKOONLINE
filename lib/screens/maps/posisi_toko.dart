import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'networking.dart';
import 'package:dahar/global_styles.dart';

class PosisiToko extends StatefulWidget {
  final startLat, startLng, endLat, endLng, distance;
  const PosisiToko(
      {Key? key,
      this.startLat,
      this.startLng,
      this.endLat,
      this.endLng,
      this.distance})
      : super(key: key);

  @override
  _PosisiTokoState createState() => _PosisiTokoState();
}

class _PosisiTokoState extends State<PosisiToko> {
  late GoogleMapController mapController;

  final List<LatLng> polyPoints = []; // For holding Co-ordinates as LatLng
  final Set<Polyline> polyLines = {}; // For holding instance of Polyline
  final Set<Marker> markers = {}; // For holding instance of Marker
  var data;

  // Dummy Start and Destination Points
  // double startLat = -7.5397754;
  // double startLng = 112.2408845;
  // double endLat = -7.551498;
  // double endLng = 112.230074;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setMarkers();
  }

  setMarkers() {
    markers.add(
      Marker(
        markerId: MarkerId("Home"),
        position: LatLng(widget.startLat, widget.startLng),
        infoWindow: InfoWindow(
          title: "Your Location",
          snippet: "Your current location",
        ),
      ),
    );

    markers.add(Marker(
      markerId: MarkerId("Destination"),
      position: LatLng(widget.endLat, widget.endLng),
      infoWindow: InfoWindow(
        title: "Warung Bu Supiah",
        snippet: "Jl Raden Patah no 30, Bandung",
      ),
    ));
    setState(() {});
  }

  void getJsonData() async {
    // Create an instance of Class NetworkHelper which uses http package
    // for requesting data to the server and receiving response as JSON format

    NetworkHelper network = NetworkHelper(
      startLat: widget.startLat,
      startLng: widget.startLng,
      endLat: widget.endLat,
      endLng: widget.endLng,
    );

    try {
      // getData() returns a json Decoded data
      data = await network.getData();

      // We can reach to our desired JSON data manually as following
      LineString ls =
          LineString(data['features'][0]['geometry']['coordinates']);

      for (int i = 0; i < ls.lineString.length; i++) {
        polyPoints.add(LatLng(ls.lineString[i][1], ls.lineString[i][0]));
      }

      if (polyPoints.length == ls.lineString.length) {
        setPolyLines();
      }
    } catch (e) {
      print(e);
    }
  }

  setPolyLines() {
    Polyline polyline = Polyline(
      polylineId: PolylineId("polyline"),
      color: color1,
      points: polyPoints,
    );
    polyLines.add(polyline);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    getJsonData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        // alignment: Alignment.center,
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.endLat, widget.endLng),
              zoom: 15,
            ),
            markers: markers,
            polylines: polyLines,
          ),
          Positioned(
            left: 15,
            top: 40,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: borderRadius1,
                color: Colors.white,
              ),
              child: IconButton(
                  color: color1,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios_rounded)),
            ),
          ),
          Positioned(
              bottom: 30,
              left: 15,
              child: Container(
                width: 290,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: borderRadius1,
                    color: Colors.white,
                    boxShadow: [boxshadow2]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: Text(
                          'Jl Raden Patah no 30, Desa Kaliwungu, Bandung, Jawa Barat',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          margin: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                              image: const DecorationImage(
                                  image: NetworkImage(
                                      "https://images.unsplash.com/photo-1516876437184-593fda40c7ce?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1472&q=80"),
                                  fit: BoxFit.cover),
                              shape: BoxShape.circle,
                              color: color1),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 3),
                              child: const Text(
                                'Warung Bu Supiah',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              '${widget.distance.toStringAsFixed(1)} Km dari posisimu',
                              style: TextStyle(color: color1),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}

//Create a new class to hold the Co-ordinates we've received from the response data

class LineString {
  LineString(this.lineString);
  List<dynamic> lineString;
}
