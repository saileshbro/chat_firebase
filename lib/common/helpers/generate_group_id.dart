String generateGroupId(String senderId, String receiverId) {
  return senderId.hashCode > receiverId.hashCode
      ? "$senderId.$receiverId"
      : "$receiverId.$senderId";
}
