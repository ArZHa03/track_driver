part of 'driver_controller.dart';

class _DriverTracker extends StatefulWidget {
  final DriverController _controller;
  final String _email;

  const _DriverTracker(this._controller, this._email);

  @override
  State<_DriverTracker> createState() => __DriverTrackerState();
}

class __DriverTrackerState extends State<_DriverTracker> {
  late DriverController _controller;
  LatLng _currentPosition = LatLng(0, 0);
  final MapController _mapController = MapController();

  @override
  void initState() {
    _controller = widget._controller;
    _controller._service._listenGps();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Driver Tracker')),
      body: StreamBuilder(
          stream: _controller._service._getGps(widget._email),
          builder: (context, snapshot) {
            if (snapshot.hasError) return Center(child: Text("Error : ${snapshot.error}"));

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData && snapshot.connectionState == ConnectionState.active) {
              _currentPosition = LatLng(snapshot.data!['latitude'], snapshot.data!['longitude']);

              return FlutterMap(
                mapController: _mapController,
                options: MapOptions(initialCenter: _currentPosition, initialZoom: 15.0),
                children: <Widget>[
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: "com.gps.track_driver",
                  ),
                  MarkerLayer(
                    markers: <Marker>[
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: _currentPosition,
                        child: Icon(Icons.location_on, size: 50, color: Colors.red),
                      )
                    ],
                  )
                ],
              );
            }
            return Center(child: _controller._responsive.text('Tidak ada data'));
          }),
    );
  }
}
