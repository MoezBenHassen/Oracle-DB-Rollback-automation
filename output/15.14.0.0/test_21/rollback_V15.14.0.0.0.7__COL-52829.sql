-- 🔁 Rollback of V15.14.0.0.0.7__COL-52829.sql
-- ⚠️ MANUAL CHECK REQUIRED: CASE NOT HANDLED
-- ORIGINAL: INSERT INTO preferences (ID, PARENT, PREFTYPE, NAME, PREFVALUE, PREFCLASS) VALUES (v_max_id, 7, '(global)','MTA BUSINESS LINES CONFIG','41,22',NULL);
DELETE FROM lrsschemaproperties WHERE modulename = 'collateral' AND propertyname = 'COL-52829_Adding_and_updating_the_existent_field_on_Configuration>Preferences' ;
