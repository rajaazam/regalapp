class passangerProfile {
  String? id;
  String? Name;
  String? email;
  String? phoneNumber;
  String? dateofBirth;
  String? image;
  String? userId;
  String? driverId;
  String? passangerId;

  passangerProfile(
      {this.id,
      this.Name,
      this.email,
      this.phoneNumber,
      this.dateofBirth,
      this.image,
      this.userId,
      this.driverId,
      this.passangerId});

  passangerProfile copyWith(
      {String? id,
      String? Name,
      String? email,
      String? phoneNumber,
      String? dateOfBirth,
      String? image,
      String? userId,
      String? driverId,
      String? passangerId}) {
    return passangerProfile(
        id: id ?? this.id,
        Name: Name ?? this.Name,
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        image: image ?? this.image,
        userId: userId ?? this.userId,
        driverId: driverId ?? this.driverId,
        passangerId: passangerId ?? this.passangerId);
  }
}
