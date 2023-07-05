class Contact {
  final int? id;
  final String? name;
  final String? contact;

  Contact({ this.id,  this.name,  this.contact});

  Contact.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        contact = res['contact'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
    };
  }
}
