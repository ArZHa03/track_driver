part of 'driver_controller.dart';

class _DriverView extends StatefulWidget {
  late DriverController _controller;

  void setController(DriverController controller) => _controller = controller;

  @override
  State<_DriverView> createState() => _DriverViewState();
}

class _DriverViewState extends State<_DriverView> {
  late DriverController _controller;

  static final Color _primaryColor = Color(0xffFFFFFF);
  static final Color _secondaryColor = Color(0xff3A75C4);
  static final Color _tertiaryColor = Color(0xff2C3E50);

  @override
  void initState() {
    super.initState();
    _controller = widget._controller;
    _getDrivers();
  }

  void _getDrivers() async {
    setState(() => _controller._isLoading = true);
    await _controller._getDrivers();
    setState(() => _controller._isLoading = false);
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return Future.error('Location permissions are denied');
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();
    _updatePosition(position);
  }

  void _startTracking() {
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10),
    ).listen((Position position) => _updatePosition(position));
  }

  void _updatePosition(Position position) =>
      _controller._currentPosition = LatLng(position.latitude, position.longitude);

  void _startPeriodicUpdate() =>
      _controller._timer = Timer.periodic(Duration(minutes: 1), (Timer timer) => _sendGpsData());

  void _sendGpsData() {
    _controller._service._addUpdateGps({
      'latitude': _controller._currentPosition.latitude,
      'longitude': _controller._currentPosition.longitude,
    }, _controller._mediatorData.getUser()['email']);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: _controller._responsive.text('GPS data terkirim', color: _primaryColor)));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: _primaryColor,
        appBar: AppBar(
          title: _controller._responsive
              .text('Halo, ${_controller._convertEmailToDisplayName(_controller._mediatorData.getUser()['email'])}'),
          actions: [
            IconButton(
              icon: Icon(Icons.person_add),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                    title: _controller._responsive.text('Tambah Driver', fontWeight: FontWeight.bold),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _controller._driverEmailController,
                          decoration: InputDecoration(hintText: 'Email Driver'),
                        ),
                        SizedBox(height: _controller._responsive.hp(10)),
                        ElevatedButton(
                          onPressed: () async => await _controller._setDriver(context).then((value) => _getDrivers()),
                          child: _controller._responsive.text("Tambah Driver"),
                        ),
                      ],
                    )),
              ),
            ),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () => _controller._logout(context),
            ),
          ],
        ),
        body: _controller._isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _controller._responsive.text('Daftar Driver', fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  _controller._drivers.isEmpty
                      ? Center(child: _controller._responsive.text('Tidak ada driver'))
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: _controller._drivers.length,
                          itemBuilder: (context, index) => driverListItem(driverEmail: _controller._drivers[index]),
                        ),
                ],
              ),
        bottomNavigationBar: _bottomNavigationBar(context),
      ),
    );
  }

  Widget _bottomNavigationBar(BuildContext context) {
    return BottomAppBar(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _controller._isTracking ? _secondaryColor : _tertiaryColor,
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
        ),
        onPressed: () {
          if (_controller._isTracking) {
            _controller._timer?.cancel();
            setState(() => _controller._isTracking = false);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: _controller._responsive.text('Tracking dihentikan', color: _primaryColor)),
              );
            return;
          }

          _determinePosition().then((value) {
            setState(() => _controller._isTracking = true);
            _startTracking();
            _startPeriodicUpdate();
            _sendGpsData();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: _controller._responsive.text('Tracking dimulai', color: _primaryColor)),
              );
          }).catchError((error) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: _controller._responsive.text(error.toString(), color: _primaryColor)),
              );
          });
        },
        child: _controller._responsive
            .text(_controller._isTracking ? 'Hentikan Tracking' : 'Mulai Tracking', color: _primaryColor),
      ),
    );
  }

  Widget driverListItem({required String driverEmail}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GestureDetector(
        onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (context) => _DriverTracker(_controller, driverEmail))),
        child: Container(
          decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: CircleAvatar(backgroundColor: _secondaryColor, child: Icon(Icons.person, color: _primaryColor)),
            title: _controller._responsive.text(
              _controller._convertEmailToDisplayName(driverEmail),
              fontWeight: FontWeight.bold,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on, color: Colors.green),
                SizedBox(width: 8.0),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: _controller._responsive.text('Hapus Driver', fontWeight: FontWeight.bold),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _controller._responsive.text('Apakah anda yakin ingin menghapus driver ini?'),
                          SizedBox(height: _controller._responsive.hp(10)),
                          ElevatedButton(
                            onPressed: () async {
                              await _controller._deleteDriver(context, driverEmail);
                              _getDrivers();
                            },
                            child: _controller._responsive.text("Hapus Driver"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
