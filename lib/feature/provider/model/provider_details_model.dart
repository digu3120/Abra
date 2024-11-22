import 'package:demandium/feature/provider/model/provider_model.dart';
import 'package:demandium/feature/service/model/service_model.dart';
import 'package:demandium/feature/service/model/service_review_model.dart';

class ProviderDetails {
  ProviderDetailsContent? content;

  ProviderDetails({this.content});

  ProviderDetails.fromJson(Map<String, dynamic> json) {
    content = json['content'] != null ? ProviderDetailsContent.fromJson(json['content']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (content != null) {
      data['content'] = content!.toJson();
    }
    return data;
  }
}

class ProviderDetailsContent {
  ProviderData? provider;
  List<SubCategories>? subCategories;
  ProviderReview? providerReview;
  Rating? providerRating;

  ProviderDetailsContent({this.provider, this.subCategories, this.providerReview, this.providerRating});

  ProviderDetailsContent.fromJson(Map<String, dynamic> json) {
    provider = json['provider'] != null
        ? ProviderData.fromJson(json['provider'])
        : null;
    if (json['sub_categories'] != null) {
      subCategories = <SubCategories>[];
      json['sub_categories'].forEach((v) {
        subCategories!.add(SubCategories.fromJson(v));
      });
    }
    providerReview = json['reviews'] != null
        ? ProviderReview.fromJson(json['reviews'])
        : null;
    providerRating = json['rating'] != null ? Rating.fromJson(json['rating']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (provider != null) {
      data['provider'] = provider!.toJson();
    }
    if (subCategories != null) {
      data['sub_categories'] =
          subCategories!.map((v) => v.toJson()).toList();
    }
    if (providerRating != null) {
      data['rating'] = providerRating!.toJson();
    }
    return data;
  }
}

class SubCategories {
  String? id;
  String? parentId;
  String? name;
  String? image;
  int? position;
  String? description;
  int? isActive;
  int? isFeatured;
  String? createdAt;
  String? updatedAt;
  List<Service>? services;

  SubCategories(
      {this.id,
        this.parentId,
        this.name,
        this.image,
        this.position,
        this.description,
        this.isActive,
        this.isFeatured,
        this.createdAt,
        this.updatedAt,
        this.services});

  SubCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    name = json['name'];
    image = json['image'];
    position = json['position'];
    description = json['description'];
    isActive = json['is_active'];
    isFeatured = int.tryParse(json['is_featured'].toString());
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['services'] != null) {
      services = <Service>[];
      json['services'].forEach((v) {
        services!.add(Service.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['parent_id'] = parentId;
    data['name'] = name;
    data['image'] = image;
    data['position'] = position;
    data['description'] = description;
    data['is_active'] = isActive;
    data['is_featured'] = isFeatured;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TimeSchedule {
  String? startTime;
  String? endTime;

  TimeSchedule({this.startTime, this.endTime});

  TimeSchedule.fromJson(Map<String, dynamic> json) {
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    return data;
  }
}

class ProviderReview {
  List<Review>? reviewList;
  int? lastPage;
  int? currentPage;
  int? total;

  ProviderReview({this.reviewList,
    this.lastPage,
    this.total,
    this.currentPage
  });

  ProviderReview.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      reviewList = <Review>[];
      json['data'].forEach((v) {
        reviewList!.add(Review.fromJson(v));
      });
    }
    lastPage = json['last_page'];
    currentPage = json['current_page'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (reviewList != null) {
      data['data'] = reviewList!.map((v) => v.toJson()).toList();
    }
    data['last_page'] = lastPage;
    data['current_page'] = currentPage;
    data['total'] = total;
    return data;
  }
}






