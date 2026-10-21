import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:loving_brain/model/api_result_status.dart';

import '../generated/locale_keys.g.dart';
import '../model/behaviour_category_model.dart';

class BehavioursRepo {
  BehavioursRepo._();

  static final BehavioursRepo _instance = BehavioursRepo._();

  factory BehavioursRepo() {
    return _instance;
  }

  static BehavioursRepo get instance => _instance;

  final CollectionReference<Map<String, dynamic>> behavioursCollection =
      FirebaseFirestore.instance.collection('behaviours');

  final CollectionReference<Map<String, dynamic>> childrenCollection =
      FirebaseFirestore.instance.collection('children');

  Future<ApiResultStatus> getAllBehaviourCategories() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> behaviours =
          await behavioursCollection.get();
      if (behaviours.docs.isNotEmpty) {
        return ApiResultStatus.data(
          data: behaviours.docs
              .map((e) => BehaviourCategoryModel.fromJson(e))
              .toList(),
        );
      } else {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }
    } on FirebaseException {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    } catch (e) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    }
  }

  Future<ApiResultStatus> addChildBehaviour({
    required String? id,
    required Map<String, dynamic> request,
  }) async {
    try {
      final DocumentReference<Map<String, dynamic>> behaviours =
          await childrenCollection
              .doc(id)
              .collection("behaviours")
              .add(request);
      return ApiResultStatus.data(data: behaviours.id);
    } on FirebaseException {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    } catch (e) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    }
  }
}
