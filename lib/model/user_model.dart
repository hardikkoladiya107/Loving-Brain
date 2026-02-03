import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    String? uid,
    String? platform,
    String? email,
    String? productId,
    String? originalTransactionId,
    String? subscriptionStatus,
    String? transactionId,
    String? purchaseToken,
    DateTime? freeTaskUseTime,
    DateTime? updatedDate,
    DateTime? lastOpened,
    DateTime? lastStreakUpdate,
    String? displayName,
    String? parentName,
    String? parentGender,
    DateTime? parentDateOfBirth,
    String? childName,
    String? childAge,
    String? relationshipToChild,
    String? parentEmail,
    int? streak,
    List<DocumentReference>? children,
    DocumentReference? defaultChild,
    bool? getReminderNotification,
    bool? dailyEmotionCheck,
    bool? todaysPlayIdea,
    bool? scheduleReminder,
    String? profileImage,
  }) {
    _uid = uid;
    _platform = platform;
    _email = email;
    _productId = productId;
    _originalTransactionId = originalTransactionId;
    _subscriptionStatus = subscriptionStatus;
    _freeTaskUseTime = freeTaskUseTime;
    _updatedDate = updatedDate;
    _lastOpened = lastOpened;
    _lastStreakUpdate = lastStreakUpdate;
    _transactionId = transactionId;
    _purchaseToken = purchaseToken;
    _displayName = displayName;
    _parentName = parentName;
    _parentGender = parentGender;
    _parentDateOfBirth = parentDateOfBirth;
    _childName = childName;
    _childAge = childAge;
    _relationshipToChild = relationshipToChild;
    _parentEmail = parentEmail;
    _streak = streak;
    _children = children;
    _defaultChild = defaultChild;
    _getReminderNotification = getReminderNotification;
    _dailyEmotionCheck = dailyEmotionCheck;
    _todaysPlayIdea = todaysPlayIdea;
    _scheduleReminder = scheduleReminder;
    _profileImage = profileImage;
  }

  UserModel.fromJson(
    Map<String, dynamic> jsonObject, {
    bool fromConvert = false,
  }) {
    _uid = jsonObject['uid'];
    _platform = jsonObject['platform'];
    _productId = jsonObject['product_id'];
    _originalTransactionId = jsonObject['original_transaction_id'];
    _transactionId = jsonObject['transactionId'];
    _subscriptionStatus = jsonObject['subscription_status'];
    _purchaseToken = jsonObject['purchase_token'];
    _email = jsonObject['email'];
    _displayName = jsonObject['display_name'];
    _parentName = jsonObject['parent_name'];
    _parentGender = jsonObject['parent_gender'];
    _childName = jsonObject['child_name'];
    _childAge = jsonObject['child_age'];
    _relationshipToChild = jsonObject['relationship_to_child'];
    _parentEmail = jsonObject['parent_email'];
    _streak = jsonObject['streak'];
    _getReminderNotification = jsonObject['get_reminder_notification'];
    _dailyEmotionCheck = jsonObject['daily_emotion_check'];
    _todaysPlayIdea = jsonObject['todays_play_idea'];
    _scheduleReminder = jsonObject['schedule_reminder'];
    _profileImage = jsonObject['profile_image'];

    try {
      if (fromConvert) {
        _defaultChild = FirebaseFirestore.instance.doc(
          jsonObject['default_child'],
        );
      } else {
        if (jsonObject['default_child'] != null &&
            jsonObject['default_child'] is DocumentReference) {
          _defaultChild = jsonObject['default_child'] as DocumentReference;
        }
      }
    } catch (e) {
      e;
    }

    try {
      if (fromConvert) {
        if ((jsonObject['children'] is List<dynamic>)) {
          var paths = (jsonObject['children'] as List<dynamic>);
          _children = [];
          _children?.addAll(
            paths
                .map((e) => FirebaseFirestore.instance.doc(e.toString()))
                .toList(),
          );
        }
      } else {
        if (jsonObject['children'] != null) {
          _children = List<DocumentReference>.from(
            jsonObject['children'] ?? [],
          );
        }
      }
    } catch (e) {
      print(e);
    }

    try {
      if (fromConvert) {
        if (jsonObject['parent_date_of_birth'] != null) {
          _parentDateOfBirth = DateTime.parse(
            jsonObject['parent_date_of_birth'],
          );
        }
      } else {
        if (jsonObject['parent_date_of_birth'] != null) {
          _parentDateOfBirth = (jsonObject['parent_date_of_birth'] as Timestamp)
              .toDate();
        }
      }
    } catch (e) {
      e;
    }

    try {
      if (fromConvert) {
        if (jsonObject['updated_date'] != null) {
          _updatedDate = DateTime.parse(jsonObject['updated_date']);
        }
      } else {
        if (jsonObject['updated_date'] != null) {
          _updatedDate = (jsonObject['updated_date'] as Timestamp).toDate();
        }
      }
    } catch (e) {
      e;
    }
    try {
      if (fromConvert) {
        if (jsonObject['last_opened'] != null) {
          _lastOpened = DateTime.parse(jsonObject['last_opened']);
        }
      } else {
        if (jsonObject['last_opened'] != null) {
          _lastOpened = (jsonObject['last_opened'] as Timestamp).toDate();
        }
      }
    } catch (e) {
      e;
    }
    try {
      if (fromConvert) {
        if (jsonObject['last_streak_update'] != null) {
          _lastStreakUpdate = DateTime.parse(jsonObject['last_streak_update']);
        }
      } else {
        if (jsonObject['last_streak_update'] != null) {
          _lastStreakUpdate = (jsonObject['last_streak_update'] as Timestamp)
              .toDate();
        }
      }
    } catch (e) {
      e;
    }
    try {
      if (fromConvert) {
        if (jsonObject['free_task_use_time'] != null) {
          _freeTaskUseTime = DateTime.parse(jsonObject['free_task_use_time']);
        }
      } else {
        if (jsonObject['free_task_use_time'] != null) {
          _freeTaskUseTime = (jsonObject['free_task_use_time'] as Timestamp)
              .toDate();
        }
      }
    } catch (e) {
      e;
    }
  }

  String? _uid;

  String? _platform;
  String? _productId;
  String? _email;
  String? _originalTransactionId;
  String? _subscriptionStatus;
  String? _transactionId;
  String? _purchaseToken;
  String? _displayName;
  String? _parentName;
  String? _parentGender;

  String? _childName;
  String? _childAge;
  String? _relationshipToChild;
  String? _parentEmail;

  DateTime? _parentDateOfBirth;
  DateTime? _freeTaskUseTime;
  DateTime? _updatedDate;
  DateTime? _lastOpened;
  DateTime? _lastStreakUpdate;
  int? _streak;
  List<DocumentReference>? _children;
  DocumentReference? _defaultChild;
  bool? _getReminderNotification;
  bool? _dailyEmotionCheck;
  bool? _todaysPlayIdea;
  bool? _scheduleReminder;
  String? _profileImage;

  UserModel copyWith({
    String? uid,
    String? platform,
    String? productId,
    String? email,
    String? originalTransactionId,
    String? subscriptionStatus,
    String? transactionId,
    String? purchaseToken,
    DateTime? freeTaskUseTime,
    DateTime? updatedDate,
    DateTime? lastOpened,
    DateTime? lastStreakUpdate,
    String? displayName,
    String? parentName,
    String? parentGender,
    String? childName,
    String? childAge,
    String? relationshipToChild,
    DateTime? parentDateOfBirth,
    String? parentEmail,
    int? streak,
    List<DocumentReference>? children,
    DocumentReference? defaultChild,
    bool? getReminderNotification,
    bool? dailyEmotionCheck,
    bool? todaysPlayIdea,
    bool? scheduleReminder,
    String? profileImage,
  }) {
    return UserModel(
      uid: uid ?? _uid,
      platform: platform ?? _platform,
      email: email ?? _email,
      productId: productId ?? _productId,
      subscriptionStatus: subscriptionStatus ?? _subscriptionStatus,
      originalTransactionId: originalTransactionId ?? _originalTransactionId,
      freeTaskUseTime: freeTaskUseTime ?? _freeTaskUseTime,
      updatedDate: updatedDate ?? _updatedDate,
      lastOpened: lastOpened ?? _lastOpened,
      lastStreakUpdate: lastStreakUpdate ?? _lastStreakUpdate,
      transactionId: transactionId ?? _transactionId,
      purchaseToken: purchaseToken ?? _purchaseToken,
      displayName: displayName ?? _displayName,
      parentName: parentName ?? _parentName,
      parentGender: parentGender ?? _parentGender,
      parentDateOfBirth: parentDateOfBirth ?? _parentDateOfBirth,
      childName: childName ?? _childName,
      childAge: childAge ?? _childAge,
      parentEmail: parentEmail ?? _parentEmail,
      relationshipToChild: relationshipToChild ?? _relationshipToChild,
      streak: streak ?? _streak,
      children: children ?? _children,
      defaultChild: defaultChild ?? _defaultChild,
      getReminderNotification:
          getReminderNotification ?? _getReminderNotification,
      dailyEmotionCheck: dailyEmotionCheck ?? _dailyEmotionCheck,
      todaysPlayIdea: todaysPlayIdea ?? _todaysPlayIdea,
      scheduleReminder: scheduleReminder ?? _scheduleReminder,
      profileImage: profileImage ?? _profileImage,
    );
  }

  String? get uid => _uid;

  String? get platform => _platform;

  String? get productId => _productId;

  String? get email => _email;

  String? get parentEmail => _parentEmail;

  String? get subscriptionStatus => _subscriptionStatus;

  String? get originalTransactionId => _originalTransactionId;

  String? get transactionId => _transactionId;

  String? get purchaseToken => _purchaseToken;

  DateTime? get updatedDate => _updatedDate;

  DateTime? get lastOpened => _lastOpened;

  DateTime? get lastStreakUpdate => _lastStreakUpdate;

  DateTime? get freeTaskUseTime => _freeTaskUseTime;

  String? get displayName => _displayName;

  String? get parentName => _parentName;

  String? get parentGender => _parentGender;

  DateTime? get parentDateOfBirth => _parentDateOfBirth;

  String? get childName => _childName;

  String? get childAge => _childAge;

  String? get relationshipToChild => _relationshipToChild;

  int? get streak => _streak;

  /// Returns 0 if the user missed a day (difference > 1), otherwise returns the stored streak.
  int get displayStreak {
    if (_streak == null || _streak == 0) return 0;
    if (_lastStreakUpdate == null) return _streak!; // Should sync eventually

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final last = DateTime(
      _lastStreakUpdate!.year,
      _lastStreakUpdate!.month,
      _lastStreakUpdate!.day,
    );

    final difference = today.difference(last).inDays;

    if (difference > 1) {
      return 0; // Missed a day, streak is effectively broken
    }
    return _streak!;
  }

  bool? get getReminderNotification => _getReminderNotification;
  bool? get dailyEmotionCheck => _dailyEmotionCheck;
  bool? get todaysPlayIdea => _todaysPlayIdea;
  bool? get scheduleReminder => _scheduleReminder;
  String? get profileImage => _profileImage;

  List<DocumentReference>? get children => _children;

  DocumentReference? get defaultChild => _defaultChild;

  Map<String, dynamic> toJson({
    bool forConvert = false,
    bool updateFreeTaskTime = true,
  }) {
    final map = <String, dynamic>{};
    map['uid'] = _uid;

    map['platform'] = _platform;
    map['email'] = _email;
    map['product_id'] = _productId;
    map['original_transaction_id'] = _originalTransactionId;
    map['subscription_status'] = _subscriptionStatus;
    map['transactionId'] = _transactionId;
    map['purchase_token'] = _purchaseToken;
    map['display_name'] = _displayName;
    map['parent_name'] = _parentName;
    map['parent_gender'] = _parentGender;
    map['parent_email'] = _parentEmail;
    map['child_name'] = _childName;
    map['child_age'] = _childAge;
    map['relationship_to_child'] = _relationshipToChild;
    map['streak'] = _streak;
    map['get_reminder_notification'] = _getReminderNotification;
    map['daily_emotion_check'] = _dailyEmotionCheck;
    map['todays_play_idea'] = _todaysPlayIdea;
    map['schedule_reminder'] = _scheduleReminder;
    map['children'] = _children?.map((e) => e.path).toList();
    map['default_child'] = _defaultChild?.path;
    map['profile_image'] = _profileImage;

    try {
      if (forConvert) {
        if (_parentDateOfBirth != null) {
          Timestamp ts = Timestamp.fromDate(_parentDateOfBirth!);
          map['parent_date_of_birth'] = ts.toDate().toIso8601String();
        }
      } else {
        if (_parentDateOfBirth != null) {
          Timestamp ts = Timestamp.fromDate(_parentDateOfBirth!);
          map['parent_date_of_birth'] = ts;
        }
      }
    } catch (e) {
      e;
    }

    try {
      if (forConvert) {
        if (_updatedDate != null) {
          Timestamp ts = Timestamp.fromDate(_updatedDate!);
          map['updated_date'] = ts.toDate().toIso8601String();
        }
      } else {
        if (_updatedDate != null) {
          Timestamp ts = Timestamp.fromDate(_updatedDate!);
          map['updated_date'] = ts;
        }
      }
    } catch (e) {
      e;
    }

    try {
      if (forConvert) {
        if (_lastOpened != null) {
          Timestamp ts = Timestamp.fromDate(_lastOpened!);
          map['last_opened'] = ts.toDate().toIso8601String();
        }
      } else {
        if (_lastOpened != null) {
          Timestamp ts = Timestamp.fromDate(_lastOpened!);
          map['last_opened'] = ts;
        }
      }
    } catch (e) {
      e;
    }
    try {
      if (forConvert) {
        if (_lastStreakUpdate != null) {
          Timestamp ts = Timestamp.fromDate(_lastStreakUpdate!);
          map['last_streak_update'] = ts.toDate().toIso8601String();
        }
      } else {
        if (_lastStreakUpdate != null) {
          Timestamp ts = Timestamp.fromDate(_lastStreakUpdate!);
          map['last_streak_update'] = ts;
        }
      }
    } catch (e) {
      e;
    }

    try {
      if (updateFreeTaskTime) {
        if (forConvert) {
          if (_freeTaskUseTime != null) {
            Timestamp ts = Timestamp.fromDate(_freeTaskUseTime!);
            map['free_task_use_time'] = ts.toDate().toIso8601String();
          }
        } else {
          if (_freeTaskUseTime != null) {
            Timestamp ts = Timestamp.fromDate(_freeTaskUseTime!);
            map['free_task_use_time'] = ts;
          }
        }
      }
    } catch (e) {
      e;
    }

    return map;
  }
}
