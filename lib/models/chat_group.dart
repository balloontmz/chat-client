class ChatGroup {
  String name;
  int id;

  ChatGroup({
    this.id,
    this.name,
  });

  factory ChatGroup.fromJson(Map<String, dynamic> json) {
    return ChatGroup(
      id: json['id'],
      name: json['name'],
    );
  }
}
