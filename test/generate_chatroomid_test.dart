import 'package:flutter_chat_app/core/utils/generate_chatroom_id.dart';

void main() {
  final (chatrromId, members) = generateChatroomId(
      senderId: 'zhthewghbajghakg', receiverId: 'jghbaugqeahvjf');

  print('chatrromId $chatrromId, members $members');
}
