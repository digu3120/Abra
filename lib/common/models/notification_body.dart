
class NotificationBody {
  String? title;
  String? body;
  String? bookingId;
  String? repeatBookingType;
  String? bookingType;
  String? channelId;
  String? postId;
  String? notificationType;
  String? notificationImage;
  String? userProfileImage;
  String? userPhone;
  String? userName;
  String? userType;

  NotificationBody(
      {this.title, this.body, this.bookingId, this.notificationType, this.notificationImage,this.userProfileImage,this.channelId,this.userName,this.userPhone,this.userType, this.bookingType, this.repeatBookingType});

  NotificationBody.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    bookingId = json['booking_id'];
    repeatBookingType = json['repeat_type'];
    bookingType = json['booking_type'];
    channelId = json['channel_id'];
    postId = json['post_id'];
    notificationType = json['type'];
    notificationImage = json['image'];
    userProfileImage = json['user_image'];
    userType = json['user_type'];
    userName = json['user_name'];
    userPhone = json['user_phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['body'] = body;
    data['booking_id'] = bookingId;
    data['repeat_type'] = repeatBookingType;
    data['booking_type'] = bookingType;
    data['channel_id'] = channelId;
    data['post_id'] = postId;
    data['type'] = notificationType;
    data['image'] = notificationImage;
    data['user_image'] = userProfileImage;
    data['user_name'] = userName;
    data['user_phone'] = userPhone;
    data['user_type'] = userType;
    return data;
  }
}
