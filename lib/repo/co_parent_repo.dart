import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';

import '../generated/locale_keys.g.dart';
import '../model/api_result_status.dart';

class CoParentRepo {
  CoParentRepo._();

  static final CoParentRepo _instance = CoParentRepo._();

  factory CoParentRepo() {
    return _instance;
  }

  static CoParentRepo get instance => _instance;

  var sharedEventCollection = FirebaseFirestore.instance.collection(
    'shared_event',
  );

  var coParentInvitationCollection = FirebaseFirestore.instance.collection(
    'co-parent-invitation',
  );

  Future<ApiResultStatus> addSharedEvent({
    required Map<String, dynamic> request,
  }) async {
    try {
      var eventCollection = await sharedEventCollection.add(request);
      return ApiResultStatus.data(data: eventCollection.id);
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

  Stream<QuerySnapshot> sharedEventListener() {
    return sharedEventCollection.snapshots();
  }

  Stream<DocumentSnapshot> getSingleSharedEvent(String documentId) {
    return sharedEventCollection.doc(documentId).snapshots();
  }

  Future<ApiResultStatus> createInvitation({
    required Map<String, dynamic> request,
  }) async {
    try {
      var invitationCollectionResult = await coParentInvitationCollection.add(request);
      return ApiResultStatus.data(data: invitationCollectionResult.id);
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
