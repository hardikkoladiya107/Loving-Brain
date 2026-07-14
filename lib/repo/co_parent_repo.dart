import 'dart:convert';
import 'dart:io' as io;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:loving_brain/model/user_model.dart';
import 'package:loving_brain/other/co_parent_invitation_helpers.dart';
import 'package:loving_brain/other/preferances.dart';

import '../generated/locale_keys.g.dart';
import '../model/api_result_status.dart';
import '../env/env.dart';
import '../model/invitation_model.dart';
import 'child_repo.dart';
import 'user_repo.dart';

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

  var userCollection = FirebaseFirestore.instance.collection('users');

  // ──────────────────────────────────────────────────────────────────────────
  // Brevo transactional email — API key from Env; sender must be verified in Brevo.
  // ──────────────────────────────────────────────────────────────────────────
  static final String _brevoApiKey = Env.brevoApiKey;
  static const String _brevoSendUrl = 'https://api.brevo.com/v3/smtp/email';

  /// Must match a verified sender domain in the Brevo dashboard.
  static const String _senderEmail = 'noreply@lovingbrain.com';
  static const String _senderName = 'Loving Brain';

  Future<ApiResultStatus> addSharedEvent({
    required Map<String, dynamic> request,
  }) async {
    try {
      var eventCollection = await sharedEventCollection.add(request);
      return ApiResultStatus.data(data: eventCollection.id);
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

  Future<ApiResultStatus> addProposeToSharedEvent({
    required String docId,
    required Map<String, dynamic> request,
  }) async {
    try {
      await sharedEventCollection.doc(docId).update({
        "propose": FieldValue.arrayUnion([request]),
      });
      return ApiResultStatus.data(data: "");
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

  Future<ApiResultStatus> updateSharedEvent({
    required String documentReference,
    required Map<String, dynamic> request,
  }) async {
    try {
      var eventCollection = await sharedEventCollection
          .doc(documentReference)
          .update(request);
      return ApiResultStatus.data(data: "");
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

  Stream<DocumentSnapshot> getSingleSharedEvent(String documentId) {
    return sharedEventCollection.doc(documentId).snapshots();
  }

  Future<ApiResultStatus> deleteSharedEvent({
    required String documentId,
  }) async {
    try {
      await sharedEventCollection.doc(documentId).delete();
      return ApiResultStatus.data(data: '');
    } on FirebaseException catch (_) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    } catch (e) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    }
  }

  /// Creates a pending invitation in Firestore (`co-parent-invitation` collection).
  /// Caller should then call [sendInvitationEmail] with the returned document id.
  Future<ApiResultStatus> createInvitation({
    required Map<String, dynamic> request,
  }) async {
    try {
      var invitationCollectionResult = await coParentInvitationCollection.add(
        request,
      );
      return ApiResultStatus.data(data: invitationCollectionResult.id);
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

  // ---------------------------------------------------------------------------
  // Send invitation email via Brevo API
  // ---------------------------------------------------------------------------
  Future<ApiResultStatus> sendInvitationEmail({
    required String toEmail,
    required String fromParentName,
    required String childrenNames,
    required String invitationId,
  }) async {
    try {
      final String invitationLink =
          CoParentInvitationHelpers.buildInvitationLink(invitationId);

      final String htmlContent =
          '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Co-Parent Invitation</title>
</head>
<body style="margin:0;padding:0;background:#f5f0ff;font-family:&#39;Helvetica Neue&#39;,Arial,sans-serif;">
  <table width="100%" cellpadding="0" cellspacing="0" style="background:#f5f0ff;padding:40px 0;">
    <tr>
      <td align="center">
        <table width="560" cellpadding="0" cellspacing="0" style="background:#ffffff;border-radius:24px;overflow:hidden;box-shadow:0 8px 32px rgba(107,36,196,0.12);">
          <!-- Header -->
          <tr>
            <td style="background:linear-gradient(135deg,#6a24b8 0%,#a96ee0 100%);padding:36px 40px 28px;text-align:center;">
              <p style="margin:0;font-size:28px;font-weight:900;color:#ffffff;letter-spacing:0.5px;">💜 Loving Brain</p>
              <p style="margin:8px 0 0;font-size:14px;color:rgba(255,255,255,0.88);font-weight:500;">Parenting Together, Beautifully</p>
            </td>
          </tr>
          <!-- Body -->
          <tr>
            <td style="padding:36px 40px 28px;">
              <p style="margin:0 0 16px;font-size:22px;font-weight:800;color:#1a1a2e;">You&#39;ve been invited! 🎉</p>
              <p style="margin:0 0 20px;font-size:15px;line-height:1.6;color:#4a4a6a;">
                <strong style="color:#6a24b8;">$fromParentName</strong> has invited you to become a co-parent for
                <strong style="color:#6a24b8;">$childrenNames</strong> on Loving Brain.
              </p>
              <p style="margin:0 0 28px;font-size:15px;line-height:1.6;color:#4a4a6a;">
                As a co-parent, you&#39;ll be able to share a calendar, coordinate events, and stay connected — all in one beautiful app.
              </p>
              <!-- CTA Button -->
              <table cellpadding="0" cellspacing="0" width="100%">
                <tr>
                  <td align="center" style="padding:8px 0 32px;">
                    <a href="$invitationLink"
                       style="display:inline-block;background:linear-gradient(135deg,#6a24b8,#a96ee0);color:#ffffff;font-size:16px;font-weight:800;text-decoration:none;padding:16px 48px;border-radius:50px;letter-spacing:0.3px;box-shadow:0 6px 20px rgba(107,36,196,0.38);">
                      Accept Invitation &amp; Open App
                    </a>
                  </td>
                </tr>
              </table>
              <p style="margin:0 0 8px;font-size:13px;color:#9090b0;">Or copy this link into your browser:</p>
              <p style="margin:0 0 24px;font-size:12px;color:#6a24b8;word-break:break-all;">$invitationLink</p>
              <hr style="border:none;border-top:1px solid #f0eafa;margin:0 0 20px;">
              <p style="margin:0;font-size:12px;color:#b0b0c8;line-height:1.5;">
                If you did not expect this invitation, you can safely ignore this email. The link expires once used.
              </p>
            </td>
          </tr>
          <!-- Footer -->
          <tr>
            <td style="background:#faf7ff;padding:20px 40px;text-align:center;border-top:1px solid #f0eafa;">
              <p style="margin:0;font-size:12px;color:#b0b0c8;">© 2025 Loving Brain · All rights reserved</p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>''';

      final Dio dio = Dio();
      final response = await dio.post(
        _brevoSendUrl,
        options: Options(
          headers: {
            'api-key': _brevoApiKey,
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        data: jsonEncode({
          'sender': {'name': _senderName, 'email': _senderEmail},
          'to': [
            {'email': toEmail},
          ],
          'subject':
              '$fromParentName invited you to co-parent on Loving Brain 💜',
          'htmlContent': htmlContent,
          'textContent':
              '$fromParentName has invited you to co-parent $childrenNames on Loving Brain.\n\nAccept the invitation: $invitationLink',
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ApiResultStatus.data(data: 'Email sent');
      } else {
        return ApiResultStatus.error(
          error: Exception(
            'Email sending failed: status ${response.statusCode}',
          ),
        );
      }
    } on DioException catch (e) {
      return ApiResultStatus.error(
        error: Exception(
          'Email sending failed: ${e.message ?? 'Network error'}',
        ),
      );
    } catch (e) {
      return ApiResultStatus.error(
        error: Exception('Email sending failed: $e'),
      );
    }
  }

  Future<ApiResultStatus> updateInvitation({
    required String referenceId,
    required Map<String, dynamic> request,
    required InvitationModel invitationModel,
  }) async {
    try {
      await coParentInvitationCollection.doc(referenceId).update(request);
      return ApiResultStatus.data(data: invitationModel);
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

  /// Accepts a co-parent invitation: links shared children, updates the co-parent
  /// user document, then marks the invitation ACCEPTED.
  ///
  /// Child/user updates run **before** status changes so a partial failure leaves
  /// the invitation in REQUESTED state and the co-parent can retry.
  Future<ApiResultStatus> addUserAsCoParent(
    String invitationReferenceId,
  ) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> response =
          await coParentInvitationCollection.doc(invitationReferenceId).get();
      final Map<String, dynamic>? data = response.data();
      if (data == null) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.thisInvitationIsNotForYou.tr()),
        );
      }

      final InvitationModel invitationModel = InvitationModel.fromJson(data);
      final UserModel? userModel = preferences.getUserModel();

      final String? validationKey =
          CoParentInvitationHelpers.validateInvitationForAccept(
            invitedEmail: invitationModel.toParent,
            loggedInEmail: userModel?.email,
            invitationStatus: invitationModel.status,
          );
      if (validationKey != null) {
        return ApiResultStatus.error(
          error: Exception(_localizedInvitationError(validationKey)),
        );
      }

      final String? parentUid = userModel?.uid;
      if (parentUid == null || parentUid.isEmpty) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }

      final List<String> childIds =
          CoParentInvitationHelpers.parseChildIdsFromCsv(
            invitationModel.children,
          );
      if (childIds.isEmpty) {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.somethingWentWrong.tr()),
        );
      }

      // Step 1 — link each child to the accepting co-parent.
      final List<DocumentReference> childRefs = <DocumentReference>[];
      for (final String childId in childIds) {
        final ApiResultStatus linkResult = await ChildRepo.instance
            .addParentReference(childId: childId, parentUid: parentUid);
        Exception? linkError;
        linkResult.whenOrNull(error: (Exception error) => linkError = error);
        if (linkError != null) {
          return ApiResultStatus.error(error: linkError!);
        }
        childRefs.add(
          FirebaseFirestore.instance.collection('children').doc(childId),
        );
      }

      // Step 2 — add child refs to the co-parent user doc (so children appear in their app).
      final DocumentSnapshot<Map<String, dynamic>> coParentDoc =
          await userCollection.doc(parentUid).get();
      final Map<String, dynamic>? coParentData = coParentDoc.data();
      final bool hasDefaultChild = coParentData?['default_child'] != null;

      final Map<String, dynamic> userUpdate = <String, dynamic>{
        'children': FieldValue.arrayUnion(childRefs),
      };
      if (!hasDefaultChild && childRefs.isNotEmpty) {
        userUpdate['default_child'] = childRefs.first;
      }
      await userCollection.doc(parentUid).update(userUpdate);

      // Step 2b — link partners and set active logger (inviter logs, acceptor views).
      final String? inviterEmail = invitationModel.fromParent?.trim();
      if (inviterEmail != null && inviterEmail.isNotEmpty) {
        final UserModel? inviterUser =
            await UserRepo.instance.getUserFromEmail(email: inviterEmail);
        final String? inviterUid = inviterUser?.uid;
        if (inviterUid != null && inviterUid.isNotEmpty) {
          final WriteBatch partnerBatch = FirebaseFirestore.instance.batch();
          partnerBatch.update(userCollection.doc(inviterUid), <String, dynamic>{
            'partner_user_id': parentUid,
            'is_active_logger': true,
          });
          partnerBatch.update(userCollection.doc(parentUid), <String, dynamic>{
            'partner_user_id': inviterUid,
            'is_active_logger': false,
          });
          await partnerBatch.commit();
        }
      }

      // Step 3 — refresh cached user model for the current session.
      final DocumentSnapshot<Map<String, dynamic>> freshDoc =
          await userCollection.doc(parentUid).get();
      if (freshDoc.exists && freshDoc.data() != null) {
        final Map<String, dynamic> freshData = freshDoc.data()!;
        freshData['uid'] = parentUid;
        final UserModel updatedUser = UserModel.fromJson(freshData);
        await preferences.saveUserModel(updatedUser);
      }

      // Step 4 — mark invitation accepted only after all linking succeeded.
      await coParentInvitationCollection.doc(invitationReferenceId).update(
        <String, dynamic>{'status': CoParentInvitationHelpers.statusAccepted},
      );

      return ApiResultStatus.data(
        data: invitationModel.copyWith(
          status: CoParentInvitationHelpers.statusAccepted,
        ),
      );
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

  String _localizedInvitationError(String validationKey) {
    switch (validationKey) {
      case 'deepLinkInvitationInvalidEmail':
        return LocaleKeys.deepLinkInvitationInvalidEmail.tr();
      case 'invitationAlreadyUsed':
        return LocaleKeys.invitationAlreadyUsed.tr();
      case 'thisInvitationIsNotForYou':
      default:
        return LocaleKeys.thisInvitationIsNotForYou.tr();
    }
  }

  Future<ApiResultStatus> getMyCoParents() async {
    try {
      var currentUserModel = preferences.getUserModel();
      var coParentInvitationResponse = await coParentInvitationCollection
          .where("from_parent", isEqualTo: currentUserModel?.email ?? "")
          .where("status", isEqualTo: "ACCEPTED")
          .get();
      if (coParentInvitationResponse.docs.isNotEmpty) {
        var invitationList = coParentInvitationResponse.docs
            .map((e) => InvitationModel.fromJson(e.data()))
            .toList();
        var userResponse = await userCollection
            .where("email", whereIn: invitationList.map((e) => e.toParent))
            .get();
        return ApiResultStatus.data(
          data: userResponse.docs
              .map((e) => UserModel.fromJson(e.data()))
              .toList(),
        );
      } else {
        return ApiResultStatus.error(
          error: Exception(LocaleKeys.coParentNotFound.tr()),
        );
      }
    } on FirebaseException catch (_) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    } catch (e) {
      return ApiResultStatus.error(
        error: Exception(LocaleKeys.somethingWentWrong.tr()),
      );
    }
  }

  Future<ApiResultStatus> uploadFileToFirebaseStorage({
    required io.File file,
    required String? referenceId,
  }) async {
    try {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('shared-event-documents')
          .child(referenceId ?? "TEST")
          .child('/${file.path.split("/").last}');
      final metadata = SettableMetadata(
        contentType: 'image/${file.path.split(".").last}',
        customMetadata: {'picked-file-path': file.path},
      );
      var uploadTask = ref.putFile(io.File(file.path), metadata);
      return ApiResultStatus.data(data: await Future.value(uploadTask));
    } on FirebaseException catch (e) {
      return ApiResultStatus.error(error: e);
    } on Exception catch (e) {
      return ApiResultStatus.error(error: e);
    }
  }
}
