class NotificationModel {
  String? responseCode;
  String? message;
  NotificationContent? content;

  NotificationModel({this.responseCode, this.message, this.content});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    content = json['content'] != null ? NotificationContent.fromJson(json['content']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response_code'] = responseCode;
    data['message'] = message;
    if (content != null) {
      data['content'] = content!.toJson();
    }
    return data;
  }
}

class NotificationContent {
  int? currentPage;
  List<NotificationData>? data;
  int? lastPage;
  int? total;

  NotificationContent(
      {this.currentPage,
        this.data,
        this.lastPage,
        this.total});

  NotificationContent.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <NotificationData>[];
      json['data'].forEach((v) {
        data!.add(NotificationData.fromJson(v));
      });
    }
    lastPage = json['last_page'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['last_page'] = lastPage;
    data['total'] = total;
    return data;
  }
}

class NotificationData {
  String? id;
  String? title;
  String? description;
  String? coverImage;
  String? coverImageFullPath;
  String? createdAt;
  String? updatedAt;

  NotificationData(
      {this.id,
        this.title,
        this.description,
        this.coverImage,
        this.coverImageFullPath,
        this.createdAt,
        this.updatedAt});

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    coverImage = json['cover_image'];
    coverImageFullPath = json['cover_image_full_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['cover_image'] = coverImage;
    data['cover_image_full_path'] = coverImageFullPath;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
