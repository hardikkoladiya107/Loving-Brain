/**
 * Pure helpers for co-parent membership (no Firebase Admin dependency).
 */

/**
 * @param {string|null|undefined} email
 * @return {string}
 */
function normalizeEmail(email) {
  return (email || "").trim().toLowerCase();
}

/**
 * @param {string} email
 * @return {string}
 */
function maskEmail(email) {
  const clean = normalizeEmail(email);
  const at = clean.indexOf("@");
  if (at <= 1) return "***";
  return `${clean[0]}***${clean.slice(at)}`;
}

/**
 * @param {object|null|undefined} childData
 * @return {string|null}
 */
function resolvePrimaryParentUid(childData) {
  if (!childData) return null;
  if (
    typeof childData.primary_parent_uid === "string" &&
    childData.primary_parent_uid.trim()
  ) {
    return childData.primary_parent_uid.trim();
  }
  const ids = Array.isArray(childData.parent_reference_ids) ?
    childData.parent_reference_ids :
    [];
  if (ids.length === 0) return null;
  return String(ids[0] || "").trim() || null;
}

/**
 * @param {string} role
 * @return {object}
 */
function permissionsForRole(role) {
  const clean = (role || "").trim().toLowerCase();
  const isGrandparent = clean === "grandparent";
  return {
    role: role || "Co-Parent",
    can_view_sleep: true,
    can_view_behaviour: !isGrandparent,
    can_view_health_notes: false,
    can_view_plans: true,
    can_view_mentor_summaries: false,
  };
}

/**
 * @param {Array<string>} childIds
 * @return {string}
 */
function buildChildrenCsv(childIds) {
  return (childIds || [])
      .map((id) => String(id || "").trim())
      .filter((id) => id.length > 0)
      .join(",");
}

/**
 * @param {object} userData
 * @param {{id: string}} childRef
 * @return {{id: string}|null}
 */
function nextDefaultChild(userData, childRef) {
  const children = Array.isArray(userData.children) ? userData.children : [];
  const remaining = children.filter((ref) => {
    if (!ref) return false;
    const id = typeof ref.id === "string" ? ref.id : String(ref).split("/").pop();
    return id !== childRef.id;
  });
  return remaining.length > 0 ? remaining[0] : null;
}

/**
 * Validates create-invite preconditions (pure).
 * @param {object} input
 * @return {string|null} error code or null when ok
 */
function validateCreateInvite(input) {
  const {
    fromUid,
    fromEmail,
    toEmail,
    childIds,
    childrenById,
    pendingInvites,
  } = input;
  if (!fromUid) return "unauthenticated";
  const cleanEmail = normalizeEmail(toEmail);
  if (!cleanEmail) return "invalid-argument";
  const uniqueChildIds = [...new Set((childIds || []).map(String).filter(Boolean))];
  if (uniqueChildIds.length === 0) return "invalid-argument";
  if (normalizeEmail(fromEmail) === cleanEmail) return "self-invite";

  for (const childId of uniqueChildIds) {
    const childData = (childrenById && childrenById[childId]) || null;
    if (!childData) return "child-not-found";
    const primary = resolvePrimaryParentUid(childData);
    if (primary !== fromUid) return "not-primary";
    const parentIds = Array.isArray(childData.parent_reference_ids) ?
      childData.parent_reference_ids.map(String) :
      [];
    if (input.inviteeUid && parentIds.includes(input.inviteeUid)) {
      return "already-linked";
    }
  }

  for (const invite of pendingInvites || []) {
    if ((invite.status || "") !== "REQUESTED") continue;
    if (invite.from_uid !== fromUid) continue;
    if (normalizeEmail(invite.to_parent) !== cleanEmail) continue;
    const existingIds = Array.isArray(invite.child_ids) ?
      invite.child_ids.map(String) :
      String(invite.children || "")
          .split(",")
          .map((s) => s.trim())
          .filter(Boolean);
    const overlap = uniqueChildIds.some((id) => existingIds.includes(id));
    if (overlap) return "duplicate-invite";
  }
  return null;
}

/**
 * Validates accept-invite preconditions (pure).
 * @param {object} invite
 * @param {object} opts
 * @return {string|null}
 */
function validateAcceptInvite(invite, opts) {
  const {uid, userEmail, nowMs} = opts;
  if (!uid) return "unauthenticated";
  if (!invite) return "not-found";
  const status = invite.status || "";
  if (status === "ACCEPTED") {
    if (invite.accepted_by_uid === uid || invite.to_uid === uid) {
      return "already-accepted-self";
    }
    return "already-used";
  }
  if (status === "CANCELLED" || status === "REJECTED") {
    return "no-longer-valid";
  }
  if (status !== "REQUESTED") return "no-longer-valid";
  if (invite.expires_at) {
    const expiresMs = Date.parse(invite.expires_at);
    if (!Number.isNaN(expiresMs) && expiresMs < (nowMs || Date.now())) {
      return "expired";
    }
  }
  const invitedEmail = normalizeEmail(invite.to_parent);
  const loggedEmail = normalizeEmail(userEmail);
  const emailMatch = invitedEmail && loggedEmail && invitedEmail === loggedEmail;
  const uidMatch = invite.to_uid && invite.to_uid === uid;
  if (!emailMatch && !uidMatch) return "wrong-account";
  return null;
}

/**
 * Whether unlink is allowed for a target on a child.
 * @param {object} childData
 * @param {string} targetUid
 * @return {string|null} error or null
 */
function validateUnlinkCaregiver(childData, targetUid) {
  const primary = resolvePrimaryParentUid(childData);
  if (primary === targetUid) return "cannot-remove-primary";
  const parentIds = Array.isArray(childData.parent_reference_ids) ?
    childData.parent_reference_ids.map(String) :
    [];
  if (!parentIds.includes(targetUid)) return "not-linked";
  return null;
}

/**
 * Builds parent_reference_ids after accepting onto one child only.
 * Does not replace existing parents.
 * @param {Array<string>} existing
 * @param {string} newUid
 * @return {Array<string>}
 */
function parentIdsAfterAccept(existing, newUid) {
  const list = Array.isArray(existing) ? existing.map(String) : [];
  if (!list.includes(newUid)) list.push(newUid);
  return list;
}

/**
 * Whether to set default_child on accept.
 * @param {object} userData
 * @return {boolean}
 */
function shouldSetDefaultChildOnAccept(userData) {
  const def = userData && userData.default_child;
  if (def == null) return true;
  if (typeof def === "object" && def.id) return false;
  if (typeof def === "string" && def.length > 0) return false;
  return true;
}

/**
 * Whether partner_user_id should be cleared on unlink.
 * @param {object} userData
 * @param {string} removedUid
 * @return {boolean}
 */
function shouldClearPartnerUserId(userData, removedUid) {
  return !!(userData && userData.partner_user_id === removedUid);
}

module.exports = {
  normalizeEmail,
  maskEmail,
  resolvePrimaryParentUid,
  permissionsForRole,
  buildChildrenCsv,
  nextDefaultChild,
  validateCreateInvite,
  validateAcceptInvite,
  validateUnlinkCaregiver,
  parentIdsAfterAccept,
  shouldSetDefaultChildOnAccept,
  shouldClearPartnerUserId,
};
