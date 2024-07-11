class Invitation {
  final String senderId;
  final String senderName;
  final String receiverEmail;
  final String message;

  Invitation({
    required this.senderId,
    required this.senderName,
    required this.receiverEmail,
    required this.message,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'receiverEmail': receiverEmail,
      'message': '來自$senderName的配對邀請',
    };
  }
}
