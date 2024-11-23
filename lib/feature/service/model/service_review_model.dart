import 'package:demandium/utils/core_export.dart';

class ReviewModel {
  String? responseCode;
  String? message;
  ReviewContent? content;

  ReviewModel({this.responseCode, this.message, this.content});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    content =
    json['content'] != null ? ReviewContent.fromJson(json['content']) : null;
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

class ReviewContent {
  Reviews? reviews;
  Rating? rating;

  ReviewContent({this.reviews, this.rating});

  ReviewContent.fromJson(Map<String, dynamic> json) {
    reviews = json['reviews'] != null ? Reviews.fromJson(json['reviews']) : null;
    rating = json['rating'] != null ? Rating.fromJson(json['rating']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (reviews != null) {
      data['reviews'] = reviews!.toJson();
    }
    if (rating != null) {
      data['rating'] = rating!.toJson();
    }
    return data;
  }
}

class Reviews {
  int? currentPage;
  List<Review>? reviewList;
  String? firstPageUrl;
  int? lastPage;
  int? total;

  Reviews(
      {this.currentPage,
        this.reviewList,
        this.firstPageUrl,
        this.lastPage,
        this.total});

  Reviews.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      reviewList = <Review>[];
      json['data'].forEach((v) {
        reviewList!.add(Review.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    lastPage = json['last_page'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (reviewList != null) {
      data['data'] = reviewList!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['last_page'] = lastPage;
    data['total'] = total;
    return data;
  }
}

class Review {
  String? id;
  String? bookingId;
  String? serviceId;
  String? providerId;
  int? reviewRating;
  String? reviewComment;
  String? bookingDate;
  int? isActive;
  String? createdAt;
  String? updatedAt;
  Customer? customer;
  ProviderData? provider;
  ReviewReply? reviewReply;
  int? isExpended;

  Review(
      {this.id,
        this.bookingId,
        this.serviceId,
        this.providerId,
        this.reviewRating,
        this.reviewComment,
        this.bookingDate,
        this.isActive,
        this.createdAt,
        this.updatedAt,
        this.customer,
        this.reviewReply,
        this.provider,
        this.isExpended,
      });

  Review.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['booking_id'];
    serviceId = json['service_id'];
    providerId = json['provider_id'];
    reviewRating = int.tryParse(json['review_rating'].toString());
    reviewComment = json['review_comment'];
    bookingDate = json['booking_date'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    customer = json['customer'] != null
        ? Customer.fromJson(json['customer'])
        : null;
    reviewReply = json['review_reply'] != null
        ? ReviewReply.fromJson(json['review_reply'])
        : null;
    provider = json['provider'] != null
        ? ProviderData.fromJson(json['provider'])
        : null;
    isExpended = 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['booking_id'] = bookingId;
    data['service_id'] = serviceId;
    data['provider_id'] = providerId;
    data['review_rating'] = reviewRating;
    data['review_comment'] = reviewComment;
    data['booking_date'] = bookingDate;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    if (reviewReply != null) {
      data['review_reply'] = reviewReply!.toJson();
    }
    if (provider != null) {
      data['provider'] = provider!.toJson();
    }
    return data;
  }
}
class Rating {
  int ? ratingCount;
  int ? reviewCount;
  double? averageRating;
  List<RatingGroupCount>? ratingGroupCount;

  Rating({this.ratingCount, this.averageRating, this.ratingGroupCount, this.reviewCount});

  Rating.fromJson(Map<String, dynamic> json) {
    ratingCount = int.tryParse(json['rating_count'].toString());
    reviewCount = int.tryParse(json['review_count'].toString());
    averageRating = double.tryParse(json['average_rating'].toString());
    if (json['rating_group_count'] != null) {
      ratingGroupCount = <RatingGroupCount>[];
      json['rating_group_count'].forEach((v) {
        ratingGroupCount!.add(RatingGroupCount.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rating_count'] = ratingCount;
    data['review_count'] = ratingCount;
    data['average_rating'] = averageRating;
    if (ratingGroupCount != null) {
      data['rating_group_count'] =
          ratingGroupCount!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RatingGroupCount {
  double? reviewRating;
  int? total;

  RatingGroupCount({this.reviewRating, this.total});

  RatingGroupCount.fromJson(Map<String, dynamic> json) {
    reviewRating = json['review_rating'] != null ? double.parse(json['review_rating'].toString()) : null;
    total = json['total'] != null ? int.parse(json['total'].toString()) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['review_rating'] = reviewRating;
    data['total'] = total;
    return data;
  }
}

class ReviewReply {
  String? id;
  int? readableId;
  String? userId;
  String? reply;
  String? createdAt;
  String? updatedAt;

  ReviewReply(
      {this.id,
        this.readableId,
        this.userId,
        this.reply,
        this.createdAt,
        this.updatedAt});

  ReviewReply.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    readableId = json['readable_id'];
    userId = json['user_id'];
    reply = json['reply'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['readable_id'] = readableId;
    data['user_id'] = userId;
    data['reply'] = reply;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}