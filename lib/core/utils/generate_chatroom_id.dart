(
  String chatroomId,
  List<String> members,
) generateChatroomId({
  required String senderId,
  required String receiverId,
}) {
  final List<String> members = [senderId, receiverId];
  members.sort((a, b) => a.compareTo(b));

  return (members.join('_'), members);
}
