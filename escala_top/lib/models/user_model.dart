class User {
  final String id;
  final String name;
  final String phone;
  final String? email;
  
  User({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
    };
  }
  
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
    );
  }
}
