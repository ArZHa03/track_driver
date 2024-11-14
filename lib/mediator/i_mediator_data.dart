abstract class IMediatorData {
  Map<String, dynamic> getUser();
  void setUser(Map<String, dynamic> user);

  Map<String, dynamic> getDrivers();
  void setDrivers(Map<String, dynamic> drivers);

  void clear();
}
