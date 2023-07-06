import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:owls_app/constants.dart';
import 'package:owls_app/data/mapImage_data.dart';
import 'package:owls_app/data/requestPlaceProvider.dart';
import 'package:owls_app/main.dart';
import 'package:provider/provider.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();

  Future<MapImageData> requestMap(String mapName) async {
    // Uri uri = Uri.https(baseUrl, '/map',{'site_name':'$mapName.siteName', 'space_name':'$mapName.spaceName', 'floor':'$mapName.floor'});
    Uri uri = Uri.https(baseUrl, '/map',
        {'site_id': 'seocho', 'space_id': 'tower', 'floor_id': '03F'});
    //TODO : change the location parameters
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return MapImageData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load map image');
    }
  }
}

class _MapWidgetState extends State<MapWidget> {
  late RequestPlaceProvider provider;
  late Future<MapImageData> futureMapImage;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    provider = Provider.of<RequestPlaceProvider>(context);
    if (!provider.isSearched) {
      futureMapImage = widget.requestMap('/');
    } else {
      futureMapImage = widget.requestMap(provider.getFloorImageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureMapImage,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // logger.d(snapshot.data!.imageUrl);
          return Image.network('https://$baseUrl${snapshot.data!.imageUrl}');
        } else if (snapshot.hasError) {
          logger.e("Error!", snapshot.error);
        }
        return const CircularProgressIndicator(
          color: primaryLight,
        );
      },
    );
  }
}
