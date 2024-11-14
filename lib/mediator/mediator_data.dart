import 'i_mediator_data.dart';

class MediatorData implements IMediatorData {
  Map<String, dynamic> _user = {};
  Map<String, dynamic> _drivers = {};

  @override
  Map<String, dynamic> getUser() => _user;

  @override
  void setUser(Map<String, dynamic> user) => _user = user;

  @override
  Map<String, dynamic> getDrivers() => _drivers;

  @override
  void setDrivers(Map<String, dynamic> drivers) => _drivers = drivers;

  @override
  void clear() {
    _user = {};
    _drivers = {}; 
  }
}
