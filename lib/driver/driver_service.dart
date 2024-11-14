part of 'driver_controller.dart';

class _DriverService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference<Map<String, dynamic>> _gps;

  static bool _alreadyListening = false;

  late DriverController _controller;

  void _listenGps() {
    if (_alreadyListening) return;
    _gps = _firestore.collection('gps').withConverter<Map<String, dynamic>>(
          fromFirestore: (data, _) => data.data()!,
          toFirestore: (data, _) => data,
        );
    _alreadyListening = true;
  }

  Future<void> _addUpdateGps(Map<String, dynamic> data, String email) async => await _gps.doc(email).set(data);
  Stream<DocumentSnapshot<Map<String, dynamic>>> _getGps(String email) => _gps.doc(email).snapshots();

  Future<String> _addUpdateDriver(String token, String email) async {
    if (_controller._mediatorData.getUser()['email'] == email) return 'Tidak bisa menambahkan email sendiri';
    final driversSnapshot = await _firestore.collection('drivers').doc(token).get();
    if (driversSnapshot.data() != null && driversSnapshot.data()?['emails'].contains(email)) {
      return 'Email sudah terdaftar sebagai driver';
    }

    final gpsSnapshot = await _firestore.collection('gps').doc(email).get();
    if (gpsSnapshot.data() == null) return 'Email tidak terdaftar sebagai driver';

    if (driversSnapshot.data() == null) {
      await _firestore.collection('drivers').doc(token).set({
        'emails': [email]
      });
    } else {
      final List<String> emails = List<String>.from(driversSnapshot.data()!['emails']);
      emails.add(email);
      await _firestore.collection('drivers').doc(token).update({'emails': emails});
    }

    return 'Berhasil menambahkan driver';
  }

  Future<String> _removeDriver(String token, String email) async {
    final snapshot = await _firestore.collection('drivers').doc(token).get();
    final List<String> emails = List<String>.from(snapshot.data()?['emails']);
    emails.remove(email);
    await _firestore.collection('drivers').doc(token).update({'emails': emails});
    return 'Berhasil menghapus driver';
  }

  Future<List<String>> _getDrivers(String token) async {
    final snapshot = await _firestore.collection('drivers').doc(token).get();
    if (snapshot.data() == null) return [];

    return List<String>.from(await snapshot.data()!['emails']);
  }
}
