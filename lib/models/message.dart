class Message {
  final String sender;
  final String receiver;
  final String type;

  Message({
    required this.sender,
    required this.receiver,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'receiver': receiver,
      'type': type,
    };
  }
}