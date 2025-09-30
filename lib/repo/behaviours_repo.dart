import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:loving_brain/model/api_result_status.dart';

import '../generated/locale_keys.g.dart';
import '../model/behaviour_model.dart';

class BehavioursRepo {
  BehavioursRepo._();

  static final BehavioursRepo _instance = BehavioursRepo._();

  factory BehavioursRepo() {
    return _instance;
  }

  static BehavioursRepo get instance => _instance;

  var behavioursCollection = FirebaseFirestore.instance.collection(
    'behaviours',
  );

  Future<ApiResultStatus> getAllBehaviours() async {
    try {
      var behaviours = await behavioursCollection.get();
      if (behaviours.docs.isNotEmpty) {
        return ApiResultStatus.data(
          data: behaviours.docs.map((e) => BehaviourModel.fromJson(e)).toList(),
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
}
