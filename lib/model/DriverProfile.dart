class DriverProfile {
  String? id;
  String? Name;
  String? email;
  String? phoneNumber;
  String? dateofBirth;
  String? image;
  String? userId;
  String? driverId;
  String? driverCNIC;
  String? driverLicense;
  String? passangerId;

  DriverProfile(
      {this.id,
      this.Name,
      this.email,
      this.phoneNumber,
      this.dateofBirth,
      this.image,
      this.userId,
      this.driverId,
      this.driverCNIC,
      this.driverLicense,
      this.passangerId});

  DriverProfile copyWith(
      {String? id,
      String? Name,
      String? email,
      String? phoneNumber,
      String? dateOfBirth,
      String? image,
      String? userId,
      String? driverId,
      String? driverCNIC,
      String? driverLicense,
      String? passangerId}) {
    return DriverProfile(
        id: id ?? this.id,
        Name: Name ?? this.Name,
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        image: image ?? this.image,
        userId: userId ?? this.userId,
        driverId: driverId ?? this.driverId,
        driverCNIC: driverCNIC ?? this.driverCNIC,
        driverLicense: driverLicense ?? this.driverLicense,
        passangerId: passangerId ?? this.passangerId);
  }
}
