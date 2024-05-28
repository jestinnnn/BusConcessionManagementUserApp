import "dart:convert";
import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:geocoding/geocoding.dart";
import "package:latlong2/latlong.dart";
import "package:http/http.dart" as http;

import "package:score/pages/common_scaffold.dart";

import "package:score/pages/home_page.dart";
import "package:score/pages/ticket_booking_history.dart";
import "package:score/qrpage/scannerpage.dart";
import "package:score/utils/constants.dart";
import "package:shared_preferences/shared_preferences.dart";

class mapa extends StatefulWidget {
  const mapa({super.key});
  @override
  State<StatefulWidget> createState() {
    return mapaState();
  }
}

class mapaState extends State<mapa> {
  final String apiKey = "6orMO2iOCxXLPGrVfAKFnaQKttcG8Ojo";
  final List<Marker> markers = List.empty(growable: true);
  final List<Marker> markers2 = List.empty(growable: true);
  MapController? mapcontroller;

  List<List<LatLng>> _routeCoordinates = [];
  @override
  void initState() {
    super.initState();
    getLatLngfrom();
    getLatLngto();
    mapcontroller = MapController();
  }

  void hi() async {
    await getPlaceFromLatLng(latlngfrom!);
    setState(() {});
  }

  void _calculateRoute(
      LatLng source, LatLng destination, String travelMode) async {
    String url =
        'https://api.tomtom.com/routing/1/calculateRoute/${source.latitude},${source.longitude}:${destination.latitude},${destination.longitude}/json?key=6orMO2iOCxXLPGrVfAKFnaQKttcG8Ojo&travelMode=$travelMode';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        List<dynamic> routeSections = jsonResponse['routes'];
        _routeCoordinates.clear();
        for (var routeSection in routeSections) {
          List<LatLng> route = [];
          for (var point in routeSection["legs"][0]['points']) {
            route.add(LatLng(
                point['latitude'].toDouble(), point['longitude'].toDouble()));
          }
          _routeCoordinates.add(route);
        }
      
        setState(() {});
      } else {
        print('Failed to load route. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error calculating route: $e');
    }
  }

  List<Marker> marker = [];
  String a = "";
  String locality = "";
  String street = "";
  String sublocality = "";
  String street2 = "";
  LatLng? latlngfrom;
  LatLng? latlngto;
  void marke() {
    for (List<LatLng> route in _routeCoordinates) {
      for (LatLng point in route) {
        marker.add(Marker(
          point: point,
          child: const Icon(
            Icons.location_on,
            size: 30,
            color:  Color.fromARGB(255, 15, 66, 107),
          ),
        ));
      }
    }
  }

  @override
  void dispose() {
    mapcontroller?.dispose();
    latlngfrom = null;
    latlngto = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (latlngfrom == null) {
      return CommonScaffold(
          currentIndex: 2,
          onTabTapped: (index) {
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Ticket_History(),
                ),
              );
            }
            if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ScanCodePage(),
                ),
              );
            }
            if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            }
          },
          backgroundColor: wh,
          body: Center(
            child: Container(
              height: 150,
              width: 300,
              child: Text(
                "Journey not started yet",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(255, 243, 235, 235),
              ),
            ),
          ));
    }
    _calculateRoute(latlngfrom!, latlngto!, "car");
    hi();
    final tomtomHQ = latlngto;
    final initialMarker = Marker(
      width: 50.0,
      height: 50.0,
      point: tomtomHQ!,
      child: const Icon(Icons.location_on, size: 50.0, color:  Color.fromARGB(255, 15, 66, 107)),
    );
    markers.add(initialMarker);

    final tomtomHQ2 = latlngfrom;

    final initialMarker2 = Marker(
      width: 50.0,
      height: 50.0,
      point: tomtomHQ2!,
      child: const Icon(Icons.directions_bus, size: 50.0, color:  Color.fromARGB(255, 15, 66, 107),),
    );
    markers2.add(initialMarker2);

    marke();

    return CommonScaffold(
      currentIndex: 2,
      onTabTapped: (index) {
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Ticket_History(),
            ),
          );
        }
        if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ScanCodePage(),
            ),
          );
        }
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        }
      },
      backgroundColor: wh,
      body: latlngfrom == null
          ? Center(
              child: Container(
                height: 150,
                width: 300,
                child: Text(
                  "Journey not started yet",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color:  Color.fromARGB(255, 150, 163, 174),),
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[50],
                ),
              ),
            )
          : SafeArea(
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: <Widget>[
                    FlutterMap(
                      mapController: mapcontroller,
                      options: new MapOptions(center: tomtomHQ2, zoom: 13.0),
                      children: [
                        TileLayer(
                          urlTemplate:
                              "https://api.tomtom.com/map/1/tile/basic/main/"
                              "{z}/{x}/{y}.png?key={apiKey}",
                          additionalOptions: {"apiKey": apiKey},
                        ),
                        MarkerLayer(
                          markers: markers,
                        ),
                        MarkerLayer(
                          markers: markers2,
                        ),
                        PolylineLayer(
                          polylines: _routeCoordinates
                              .map((route) => Polyline(
                                    points: route,
                                    strokeWidth: 4,
                                    color:  Color.fromRGBO(31, 154, 255, 1),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                      child: Container( 
                  alignment: Alignment.center, 
                  width: double.infinity, 
                  height: 150, 
                  decoration: BoxDecoration( 
                    border: Border.all(),
                    color: Color.fromARGB(255, 255, 255, 255), 
                    borderRadius: BorderRadius.circular(10) 
                  ), 
                  child: Stack( 
                  children: [ 
                    Positioned( 
                      top: 20, 
                      left: 20, 
                      child: Container( 
                      child: Row( 
                        children: [ 
                        Icon(Icons.streetview,size: 20,color:  Color.fromARGB(255, 15, 66, 107),), 
                        SizedBox( 
                          width: 15, 
                        ), 
                        Text(street,style: TextStyle(fontSize: 15,color:  Color.fromARGB(255, 15, 66, 107),fontWeight: FontWeight.bold),) 
                        ], 
                      ), 
                      )), 
                    Positioned( 
                      top: 45, 
                      left: 20, 
                      child: Container( 
                      child: Row( 
                        children: [ 
                        Icon(Icons.place_outlined,size: 20,color: Color.fromARGB(255, 15, 66, 107),), 
                        SizedBox( 
                          width: 15, 
                        ), 
                        Text(locality,style: TextStyle(fontSize: 15,color: Color.fromARGB(255, 15, 66, 107),fontWeight: FontWeight.bold),) 
                        ], 
                      ), 
                      )), 
                    Positioned( 
                      top: 40, 
                      right: 20, 
                      child: Container( 
                      child: Icon(Icons.alt_route_rounded,size: 20,color:  Color.fromARGB(255, 15, 66, 107),), 
                      )), 
                    Positioned( 
                      top: 75, 
                      left: 20, 
                      child: Container( 
                      child: Row( 
                        children: [ 
                        Row( 
                          mainAxisAlignment: MainAxisAlignment.center, 
                          crossAxisAlignment: CrossAxisAlignment.center, 
                          children: [ 
                          Icon(Icons.place_sharp,size: 20,color: Color.fromARGB(255, 15, 66, 107),), 
                          SizedBox( 
                            width: 15, 
                          ), 
                          Text(sublocality,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color:  Color.fromARGB(255, 15, 66, 107)),) 
                          ], 
                        ), 
                        SizedBox( 
                          width: 80, 
                        ), 
                        Row( 
                          children: [ 
                          Text(street2,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.blueAccent),), 
                          SizedBox( 
                            width: 15, 
                          ), 
                         
                          ], 
                        ) 
                        ], 
                      ), 
                      )), 
                    Positioned( 
                      top: 105, 
                      left: 20, 
                      right: 20, 
                      child: Container( 
                      height: 40, 
                      decoration: BoxDecoration( 
                        color:  Color.fromARGB(255, 15, 66, 107), 
                        borderRadius: BorderRadius.circular(20) 
                      ), 
                      child: Center( 
                        child: Text("RIDE RIGHT",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 18),) 
                      ), 
                      ) 
                    ) 
                  ], 
                  ), 
      
                ),
                    )
                  ],
                ),
              )),
            ),
    );
  }

  Future<void> getPlaceFromLatLng(LatLng latLng) async {
    try {
      final locations =
          await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      if (locations.isNotEmpty) {
        final placemark = locations.first;
        locality = placemark.locality!;
        street = placemark.country!;
        street2 = placemark.isoCountryCode!;
        sublocality = placemark.postalCode!;
      } else {
        print('No results found for ${latLng.latitude}, ${latLng.longitude}');
      }
    } catch (e) {
      print('Error fetching place: $e');
    }
  }

  Future<void> getLatLngfrom() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final encodedString = prefs.getString('fromlatlng');
    if (encodedString != null) {
      final parts = encodedString.split(',');
      final lat = jsonDecode(parts[0]) as double;
      final lng = jsonDecode(parts[1]) as double;
      latlngfrom = LatLng(lat, lng);
      setState(() {});
    } else {
      print("null");
    }
  }

  Future<void> getLatLngto() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final encodedString = prefs.getString('tolatlng');
    if (encodedString != null) {
      final parts = encodedString.split(',');
      final lat = jsonDecode(parts[0]) as double;
      final lng = jsonDecode(parts[1]) as double;
      latlngto = LatLng(lat, lng);
      setState(() {});
    } else {
      print("null");
    }
  }
}
