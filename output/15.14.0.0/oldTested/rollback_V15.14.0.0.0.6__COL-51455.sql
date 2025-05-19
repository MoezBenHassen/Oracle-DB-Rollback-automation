-- 🔁 Rollback of V15.14.0.0.0.6__COL-51455.sql
-- ⚠️ MANUAL CHECK REQUIRED: CASE NOT HANDLED
-- ORIGINAL: INSERT into preferences VALUES (LASTID , 7, '(global)', 'Stale_Approval_Restriction', 'false', null);
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-51455_Add_field_Stale_Approve_to_Preferences' ;
