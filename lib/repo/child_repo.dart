import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:loving_brain/model/child_model.dart';
import '../generated/locale_keys.g.dart';
import '../model/api_result_status.dart';
import '../model/routine_category_model.dart';

class ChildRepo {
  ChildRepo._();

  static final ChildRepo _instance = ChildRepo._();

  factory ChildRepo() {
    return _instance;
  }

  static ChildRepo get instance => _instance;

  var routineTypeCollection = FirebaseFirestore.instance.collection(
    'routine_type',
  );

  var childrenCollection = FirebaseFirestore.instance.collection('children');

  Future<ApiResultStatus> getAllRoutineCategories() async {
    try {
      var behaviours = await routineTypeCollection.get();
      if (behaviours.docs.isNotEmpty) {
        return ApiResultStatus.data(
          data: behaviours.docs
              .map((e) => RoutineCategoryModel.fromJson(e))
              .toList(),
        );
      } else {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }
    } on FirebaseException catch (e) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    } catch (e) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    }
  }

  Future<ApiResultStatus> addRoutine({
    required String? id,
    required Map<String, dynamic> request,
  }) async {
    try {
      var behaviours = await childrenCollection
          .doc(id)
          .collection("routines")
          .add(request);
      return ApiResultStatus.data(data: behaviours.id);
    } on FirebaseException catch (e) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    } catch (e) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    }
  }

  Future<ApiResultStatus> getChildren({
    required List<String> childrenIds,

  }) async {
    try {
      var childrenResponse = await childrenCollection
          .where(FieldPath.documentId, whereIn: childrenIds)
          .get();
      return ApiResultStatus.data(
        data: childrenResponse.docs.map((e) => ChildModel.fromJson(e.data())),
      );
    } on FirebaseException catch (e) {
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
