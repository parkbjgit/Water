import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:geolocator/geolocator.dart'; // geolocator 패키지 임포트

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<Polygon> _polygons = [];
  List<List<dynamic>> _csvTable = [];
  LatLng? _currentPosition;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _loadCsvData().then((_) {
      _loadGeoJson();
    });
    _getCurrentLocation();
  }

  Future<void> _loadGeoJson() async {
    final String response =
        await rootBundle.loadString('assets/gadm41_KOR_2.json');
    final data = json.decode(response);
    List<Polygon> polygons = [];

    for (var feature in data['features']) {
      List<List<LatLng>> allPolygons = [];

      if (feature['geometry']['type'] == 'Polygon') {
        List<LatLng> points = [];
        for (var coord in feature['geometry']['coordinates'][0]) {
          points.add(LatLng(coord[1], coord[0]));
        }
        allPolygons.add(points);
      } else if (feature['geometry']['type'] == 'MultiPolygon') {
        for (var polygon in feature['geometry']['coordinates']) {
          List<LatLng> points = [];
          for (var coord in polygon[0]) {
            points.add(LatLng(coord[1], coord[0]));
          }
          allPolygons.add(points);
        }
      }

      for (var points in allPolygons) {
        bool containsCsvPoint = _polygonContainsCsvPoint(points);
        Color polygonColor = _getPolygonColor(points);
        polygons.add(Polygon(
          points: points,
          color: polygonColor.withOpacity(0.5),
          borderStrokeWidth: 2,
          borderColor: polygonColor,
          isFilled: true,
        ));
      }
    }

    setState(() {
      _polygons = polygons;
    });
  }

  Future<void> _loadCsvData() async {
    final String csvString = await rootBundle.loadString('assets/level2.csv');
    List<List<dynamic>> csvTable = CsvToListConverter().convert(csvString);

    setState(() {
      _csvTable = csvTable;
    });
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 서비스 활성화 여부 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // 위치 권한 확인
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // 현재 위치 가져오기
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _mapController.move(_currentPosition!, 14.0); // 현재 위치로 지도 이동
    });
  }

  bool _polygonContainsCsvPoint(List<LatLng> polygonPoints) {
    for (var row in _csvTable) {
      if (row[0] != 'ID') {
        final latitude = double.tryParse(row[5].toString());
        final longitude = double.tryParse(row[6].toString());

        if (latitude != null && longitude != null) {
          LatLng point = LatLng(latitude, longitude);
          if (_pointInPolygon(point, polygonPoints)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  bool _pointInPolygon(LatLng point, List<LatLng> polygonPoints) {
    int intersectCount = 0;
    for (int j = 0; j < polygonPoints.length - 1; j++) {
      if ((polygonPoints[j].latitude > point.latitude) !=
              (polygonPoints[j + 1].latitude > point.latitude) &&
          point.longitude <
              (polygonPoints[j + 1].longitude - polygonPoints[j].longitude) *
                      (point.latitude - polygonPoints[j].latitude) /
                      (polygonPoints[j + 1].latitude -
                          polygonPoints[j].latitude) +
                  polygonPoints[j].longitude) {
        intersectCount++;
      }
    }
    return (intersectCount % 2) == 1;
  }

  double _calculateDistance(LatLng point1, LatLng point2) {
    const R = 6371e3; // metres
    double phi1 = point1.latitude * pi / 180;
    double phi2 = point2.latitude * pi / 180;
    double deltaPhi = (point2.latitude - point1.latitude) * pi / 180;
    double deltaLambda = (point2.longitude - point1.longitude) * pi / 180;

    double a = sin(deltaPhi / 2) * sin(deltaPhi / 2) +
        cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double d = R * c;
    return d;
  }

  Map<String, dynamic> _getClosestLocationData(LatLng tappedPoint) {
    double minDistance = double.infinity;
    Map<String, dynamic> closestLocationData = {
      'location_name': '',
      'bws_label': '',
      'point': tappedPoint
    };

    for (var row in _csvTable) {
      if (row[0] != 'ID') {
        final latitude = double.tryParse(row[5].toString());
        final longitude = double.tryParse(row[6].toString());

        if (latitude != null && longitude != null) {
          LatLng point = LatLng(latitude, longitude);
          double distance = _calculateDistance(tappedPoint, point);
          if (distance < minDistance) {
            minDistance = distance;
            closestLocationData = {
              'location_name': row[2].toString(), // 3번째 열
              'bws_label': row[19].toString(), // 20번째 열
              'point': point
            };
          }
        }
      }
    }

    return closestLocationData;
  }

  Color _getPolygonColor(List<LatLng> polygonPoints) {
    for (var row in _csvTable) {
      final latitude = double.tryParse(row[5].toString());
      final longitude = double.tryParse(row[6].toString());

      if (latitude != null && longitude != null) {
        LatLng point = LatLng(latitude, longitude);
        if (_pointInPolygon(point, polygonPoints)) {
          final bwdScore = double.tryParse(row[21].toString()) ?? 0.0;
          if (bwdScore >= 0.8) {
            return Colors.red;
          } else if (bwdScore >= 0.5) {
            return Colors.orange;
          } else if (bwdScore >= 0.2) {
            return Colors.yellow;
          } else {
            return Colors.green;
          }
        }
      }
    }
    return Colors.blue;
  }

  void _showWaterStressDialog(LatLng tappedPoint) {
    Map<String, dynamic> closestLocationData =
        _getClosestLocationData(tappedPoint);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text("물 스트레스 지수")),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("지역 이름: ${closestLocationData['location_name']}"),
                Text("위험 지수: ${closestLocationData['bws_label']}"),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("닫기"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('지도 페이지'),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(36.5, 127.5), 
          initialZoom: 13.0,
          // initialInteractiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
          onTap: (tapPosition, point) {
            _showWaterStressDialog(point);
          },
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          PolygonLayer(
            polygons: _polygons,
          ),
          if (_currentPosition != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(36.5, 127.5),
                  width: 80,
                  height: 80,
                  child: Icon(Icons.location_on,color: Colors.red,size: 40.0),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
